library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aes_uart_top is
    Port (
        clk : in STD_LOGIC;
        led : out STD_LOGIC_VECTOR(3 downto 0);
        sw  : in STD_LOGIC_VECTOR(3 downto 0);
        btn : in STD_LOGIC_VECTOR(3 downto 0);
        rx  : in STD_LOGIC;
        tx  : out STD_LOGIC
    );
end aes_uart_top;

architecture Behavioral of aes_uart_top is

    -- =======================================================================
    -- 1. COMPONENT DECLARATIONS
    -- =======================================================================
    component MPG is
        Port ( en: out STD_LOGIC; input: in STD_LOGIC; clk: in STD_LOGIC );
    end component;

    component transmitfsm is
        Port (
            clk     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            baud_en : in STD_LOGIC;
            tx_en   : in STD_LOGIC;
            tx_data : in STD_LOGIC_VECTOR (7 downto 0);
            tx      : out STD_LOGIC;
            tx_rdy  : out STD_LOGIC
        );
    end component;

    component receivefsm is
        Port (
            clk     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            baud_en : in STD_LOGIC;
            rx      : in STD_LOGIC;
            rx_data : out STD_LOGIC_VECTOR (7 downto 0);
            rx_rdy  : out STD_LOGIC
        );
    end component;

    component AES_Top is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        intext     : in  std_logic_vector(127 downto 0); -- Renamed from plaintext/ciphertext to be generic
        key        : in  std_logic_vector(127 downto 0); 
        mode       : in  std_logic; -- '0' = Encrypt, '1' = Decrypt
        outtext    : out std_logic_vector(127 downto 0);
        done       : out std_logic
    );
    end component;
    
    component uart_fifo is
        generic (
            DEPTH_WIDTH : integer := 10;   -- 2^10 = 1024 bytes storage
            DATA_WIDTH  : integer := 8     -- Standard 8-bit UART data
        );
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            wr_en    : in  std_logic;
            wr_data  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            full     : out std_logic;
            rd_en    : in  std_logic;
            rd_data  : out std_logic_vector(DATA_WIDTH-1 downto 0);
            empty    : out std_logic
        );
    end component;

    -- =======================================================================
    -- 2. SIGNALS
    -- =======================================================================
    
    -- Control Signals
    signal rst_sys    : std_logic;
    signal en_mpg     : std_logic; 

    -- Baud Rate Signals (For 100MHz Clock -> 115200 Baud)
    signal baud_en     : std_logic := '0';
    signal baud_en_x16 : std_logic := '0';
    signal cnt         : std_logic_vector(13 downto 0) := (others => '0');
    signal cnt_x16     : std_logic_vector(9 downto 0) := (others => '0');

    -- UART Signals
    signal rx_data_out : std_logic_vector(7 downto 0);
    signal rx_rdy      : std_logic;
    
    signal tx_data_in  : std_logic_vector(7 downto 0);
    signal tx_en       : std_logic := '0';
    signal tx_rdy      : std_logic;
    signal tx_line_internal : std_logic;
    
    -- AES Signals
    signal aes_plaintext  : std_logic_vector(127 downto 0);
    signal aes_key        : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c"; 
    signal aes_ciphertext : std_logic_vector(127 downto 0);
    signal aes_ciphertext_reg : std_logic_vector(127 downto 0); 
    signal aes_start      : std_logic := '0';
    signal aes_done       : std_logic;
    
    -- FIFO Signals
    signal fifo_wr_en : std_logic;
    attribute keep : string;
    attribute keep of fifo_wr_en: signal is "true";
    signal fifo_din   : std_logic_vector(7 downto 0);
    signal fifo_rd_en : std_logic;
    signal fifo_dout  : std_logic_vector(7 downto 0);
    signal fifo_empty : std_logic;
    signal fifo_full  : std_logic;
    
    -- Main State Machine (UPDATED with Handshake states)
    type state_type is (IDLE, READ_FIFO, WAIT_AES, SEND_RESULT, WAIT_TX_START, WAIT_TX_DONE, SAVE_BYTE, WAIT_RAM);
    signal state : state_type := IDLE;
    
    signal byte_ctr : integer range 0 to 16 := 0;
    
    signal debug_mode : std_logic := '1'; -- Force Decrypt
    signal debug_key  : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";

-- Edge Detection Signals
    signal rx_rdy_raw  : std_logic; 
    attribute keep_1 : string;
    attribute keep_1 of rx_rdy_raw : signal is "true";-- To catch the output from RFSM
    signal rx_rdy_prev : std_logic := '0'; -- To remember the previous state


begin

    -- Use Switch 0 as Reset
    rst_sys <= sw(0); 
    
    -- Status LEDs
    led(0) <= rx;          
    tx     <= tx_line_internal;
    led(1) <= tx_line_internal; 
    led(2) <= aes_done;    
    led(3) <= not fifo_empty; -- LED 3 ON if FIFO has data

    -- =======================================================================
    -- 3. INSTANTIATIONS
    -- =======================================================================
    
    monopulse1: MPG port map(
        en    => en_mpg, 
        input => btn(0), 
        clk   => clk
    );

    inst_AES: AES_Top port map (
        clk        => clk, 
        rst        => rst_sys, 
        start      => aes_start,
        intext  => aes_plaintext, 
        mode => sw(1),
        key        => debug_key,
        outtext => aes_ciphertext, 
        done       => aes_done
    );

    -- UART Receiver (Connected DIRECTLY to FIFO)
    inst_RFSM: receivefsm port map (
        clk     => clk, 
        rst     => rst_sys, 
        baud_en => baud_en_x16, 
        rx      => rx,
        rx_data => fifo_din,   -- To FIFO Input
        rx_rdy  => rx_rdy_raw  -- Trigger FIFO Write
    );

    -- UART Transmitter
    inst_TFSM: transmitfsm port map (
        clk     => clk, 
        rst     => rst_sys, 
        baud_en => baud_en, 
        tx_en   => tx_en,
        tx_data => tx_data_in, 
        tx      => tx_line_internal, 
        tx_rdy  => tx_rdy
    );
-- EDGE DETECTOR PROCESS
--    process(clk)
--    begin
--        if rising_edge(clk) then
--            if rst_sys = '1' then
--                rx_rdy_prev <= '0';
--                fifo_wr_en  <= '0';
--            else
--                rx_rdy_prev <= rx_rdy_raw; -- Save current state for next cycle
--                
--                -- Fire Pulse ONLY if it's High NOW and was Low BEFORE
--                if rx_rdy_raw = '1' and rx_rdy_prev = '0' then
--                    fifo_wr_en <= '1';
--                else
--                    fifo_wr_en <= '0';
--                end if;
--            end if;
--       end if;
--    end process;    
    -- The FIFO Buffer
    fifo_wr_en <= rx_rdy_raw;
    fifo_inst : uart_fifo
    port map (
        clk     => clk,
        rst     => rst_sys,
        wr_en   => fifo_wr_en,
        wr_data => fifo_din,
        full    => fifo_full,
        rd_en   => fifo_rd_en,  
        rd_data => fifo_dout,   
        empty   => fifo_empty      
    );

    -- =======================================================================
    -- 4. BAUD RATE GENERATORS (115200 for 100MHz Clock)
    -- =======================================================================
    
    -- TX Baud Rate (115200)
    process(clk)
    begin
        if rising_edge(clk) then
            if cnt = 868 then
                baud_en <= '1';
                cnt <= (others => '0');
            else
                baud_en <= '0';
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    -- RX Baud Rate (115200 x16)
    process(clk)
    begin
        if rising_edge(clk) then
            if cnt_x16 = 54 then 
                baud_en_x16 <= '1';
                cnt_x16 <= (others => '0');
            else
                baud_en_x16 <= '0';
                cnt_x16 <= cnt_x16 + 1;
            end if;
        end if;
    end process;

    -- =======================================================================
    -- 5. MAIN CONTROLLER FSM (FIFO + Handshake)
    -- =======================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_sys = '1' then
                state      <= IDLE;
                byte_ctr   <= 0;
                aes_start  <= '0';
                tx_en      <= '0';
                fifo_rd_en <= '0';
            else
                -- Default assignments
                aes_start  <= '0';
                tx_en      <= '0';
                fifo_rd_en <= '0';

                case state is
                    
                    -- STATE 1: Wait for Data in FIFO
-- STATE 1: IDLE / RESET
                    when IDLE =>
                        byte_ctr <= 0;
                        -- BUG FIX: Do NOT read from FIFO here. 
                        -- Just go to READ_FIFO and let it handle the logic.
                        state    <= READ_FIFO;

                    -- STATE 2: Read 16 Bytes from FIFO
                    when READ_FIFO =>
                            -- Need more bytes. Check FIFO.
                            if fifo_empty = '0' then
                                fifo_rd_en <= '1'; -- Request next byte
                                state   <= SAVE_BYTE;
                            end if;
                            
                    when WAIT_RAM =>
                        state <= SAVE_BYTE;
                    
                    when SAVE_BYTE =>
                        -- Capture the data that is now valid on fifo_dout
                        aes_plaintext(127 - (byte_ctr * 8) downto 120 - (byte_ctr * 8)) <= fifo_dout;
                        
                        if byte_ctr = 15 then
                            -- We just captured the last byte (Byte 15)
                            aes_start <= '1'; -- Start AES
                            state     <= WAIT_AES;
                        else
                            -- Need more bytes
                            byte_ctr <= byte_ctr + 1;
                            state    <= READ_FIFO; -- Go back and ask for next
                        end if;
                    
                    -- STATE 3: Wait for Encryption
                    when WAIT_AES =>
                        if aes_done = '1' then
                            -- Save result to register
                            aes_ciphertext_reg <= aes_ciphertext;
                            byte_ctr           <= 0;
                            state              <= SEND_RESULT;
                        end if;

                    -- STATE 4: Send Result Byte
                    when SEND_RESULT =>
                        tx_data_in <= aes_ciphertext_reg(127 - (byte_ctr * 8) downto 120 - (byte_ctr * 8));
                        tx_en      <= '1'; -- Trigger Start
                        state      <= WAIT_TX_START;

                    -- STATE 5: Wait for UART to Start (Handshake Part 1)
                    -- We wait for tx_rdy to go LOW (Busy)
                    when WAIT_TX_START =>
                        if tx_rdy = '0' then
                            -- UART has started sending. We can release Enable.
                            tx_en <= '0'; 
                            state <= WAIT_TX_DONE;
                        else
                            -- Keep asserting Enable until UART catches it
                            tx_en <= '1'; 
                        end if;

                    -- STATE 6: Wait for UART to Finish (Handshake Part 2)
                    -- We wait for tx_rdy to go HIGH (Idle)
                    when WAIT_TX_DONE =>
                        if tx_rdy = '1' then
                            if byte_ctr = 15 then
                                state <= IDLE; -- Done with packet
                            else
                                byte_ctr <= byte_ctr + 1;
                                state    <= SEND_RESULT; -- Send next byte
                            end if;
                        end if;

                end case;
            end if;
        end if;
    end process;

end Behavioral;