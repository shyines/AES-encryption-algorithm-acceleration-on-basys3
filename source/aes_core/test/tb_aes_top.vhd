library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_AES_Top is
    -- Testbench has no ports
end tb_AES_Top;

architecture Behavioral of tb_AES_Top is

    -- 1. DUT Declaration
    component AES_Top is
        Port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            start      : in  std_logic;
            intext     : in  std_logic_vector(127 downto 0);
            key        : in  std_logic_vector(127 downto 0);
            mode       : in  std_logic; -- '0' = Encrypt, '1' = Decrypt
            
            outtext    : out std_logic_vector(127 downto 0);
            done       : out std_logic
        );
    end component;

    -- 2. Signals
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal start      : std_logic := '0';
    signal mode       : std_logic := '0';
    signal intext     : std_logic_vector(127 downto 0) := (others => '0');
    signal key        : std_logic_vector(127 downto 0) := (others => '0');
    signal outtext    : std_logic_vector(127 downto 0);
    signal done       : std_logic;

    -- Clock Period (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

    -- FIPS-197 Test Vectors
    constant KEY_VECTOR   : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
    constant PLAIN_VECTOR : std_logic_vector(127 downto 0) := x"3243f6a8885a308d313198a2e0370734";
    constant CIPHER_VECTOR: std_logic_vector(127 downto 0) := x"3925841d02dc09fbdc118597196a0b32";

begin

    -- 3. Instantiate the DUT
    uut: AES_Top port map (
        clk        => clk,
        rst        => rst,
        start      => start,
        intext     => intext,
        key        => key,
        mode       => mode,
        outtext    => outtext,
        done       => done
    );

    -- 4. Clock Generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Stimulus Process
    stim_proc: process
    begin
        ------------------------------------------------------------
        -- 0. RESET SYSTEM
        ------------------------------------------------------------
        rst <= '1';
        start <= '0';
        wait for 100 ns;
        rst <= '0';
        wait for CLK_PERIOD;

        ------------------------------------------------------------
        -- TEST CASE 1: DECRYPTION
        -- Goal: Turn CIPHER_VECTOR back into PLAIN_VECTOR
        ------------------------------------------------------------
        report "Starting TEST 1: Decryption (Cipher -> Plain)..." severity note;
        
        mode   <= '1';              -- Enable Decryption
        intext <= CIPHER_VECTOR;    -- Input is Ciphertext
        key    <= KEY_VECTOR;
        
        -- Pulse Start
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for finish
        wait until done = '1';
        wait for CLK_PERIOD; -- Settle

        -- Verify
        if outtext = PLAIN_VECTOR then
            report ">> SUCCESS: Decryption Matched FIPS-197 Plaintext!" severity note;
        else
            report ">> FAILURE: Decryption Wrong." severity error;
        end if;

        wait for 100 ns;

        ------------------------------------------------------------
        -- TEST CASE 2: ENCRYPTION (Regression Test)
        -- Goal: Turn PLAIN_VECTOR back into CIPHER_VECTOR
        -- This ensures we didn't break encryption while adding decryption.
        ------------------------------------------------------------
        report "Starting TEST 2: Encryption (Plain -> Cipher)..." severity note;

        mode   <= '0';              -- Enable Encryption
        intext <= PLAIN_VECTOR;     -- Input is Plaintext
        key    <= KEY_VECTOR;

        -- Pulse Start
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for finish
        wait until done = '1';
        wait for CLK_PERIOD;

        -- Verify
        if outtext = CIPHER_VECTOR then
            report ">> SUCCESS: Encryption Matched FIPS-197 Ciphertext!" severity note;
        else
            report ">> FAILURE: Encryption Wrong." severity error;
        end if;

        ------------------------------------------------------------
        -- END SIMULATION
        ------------------------------------------------------------
        report "All Tests Completed." severity note;
        wait;
    end process;

end Behavioral;