library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_fifo is
    generic (
        DEPTH_WIDTH : integer := 10;   -- 2^10 = 1024 bytes storage
        DATA_WIDTH  : integer := 8     -- Standard 8-bit UART data
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        -- Write Interface (Connect to UART RX)
        wr_en    : in  std_logic;
        wr_data  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        full     : out std_logic;
        -- Read Interface (Connect to your AES Core)
        rd_en    : in  std_logic;
        rd_data  : out std_logic_vector(DATA_WIDTH-1 downto 0);
        empty    : out std_logic
    );
end uart_fifo;

architecture Behavioral of uart_fifo is
    type fifo_array is array (0 to (2**DEPTH_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal memory : fifo_array := (others => (others => '0'));
    
    signal head : unsigned(DEPTH_WIDTH-1 downto 0) := (others => '0'); -- Write pointer
    signal tail : unsigned(DEPTH_WIDTH-1 downto 0) := (others => '0'); -- Read pointer
    
    signal count : integer range 0 to 2**DEPTH_WIDTH := 0; -- How many bytes are currently stored
begin

    -- Memory Process
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                head  <= (others => '0');
                tail  <= (others => '0');
                count <= 0;
            else
                -- WRITE
                if wr_en = '1' and count < 2**DEPTH_WIDTH then
                    memory(to_integer(head)) <= wr_data;
                    head <= head + 1;
                end if;
                
                -- READ
                if rd_en = '1' and count > 0 then
                    rd_data <= memory(to_integer(tail));
                    tail <= tail + 1;
                end if;
                
                -- COUNT TRACKING
                if wr_en = '1' and rd_en = '0' and count < 2**DEPTH_WIDTH then
                    count <= count + 1;
                elsif wr_en = '0' and rd_en = '1' and count > 0 then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    -- Flags
    full  <= '1' when count = 2**DEPTH_WIDTH else '0';
    empty <= '1' when count = 0 else '0';

end Behavioral;