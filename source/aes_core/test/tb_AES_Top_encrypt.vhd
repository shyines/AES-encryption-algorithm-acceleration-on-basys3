library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Depending on your tool version, you might need this for to_hstring
-- use std.textio.all; 

entity tb_AES_Top_encrypt is
-- Testbench has no ports
end tb_AES_Top_encrypt;

architecture Behavioral of tb_AES_Top_encrypt is

    -- 1. Component Declaration for the AES Core
    component AES_Top
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

    -- 2. Signals to connect to the DUT (Device Under Test)
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal start   : std_logic := '0';
    signal intext  : std_logic_vector(127 downto 0) := (others => '0');
    signal key     : std_logic_vector(127 downto 0) := (others => '0');
    signal mode    : std_logic := '0';
    signal outtext : std_logic_vector(127 downto 0);
    signal done    : std_logic;

    -- Clock definition (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- 3. Instantiate the AES Core
    uut: AES_Top PORT MAP (
          clk     => clk,
          rst     => rst,
          start   => start,
          intext  => intext,
          key     => key,
          mode    => mode,
          outtext => outtext,
          done    => done
        );

    -- 4. Clock Generation Process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Stimulus Process (The actual test)
    stim_proc: process
    begin
        ------------------------------------------------------------
        -- RESET SYSTEM
        ------------------------------------------------------------
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for clk_period*5;

        ------------------------------------------------------------
        -- TEST CASE: FIPS-197 Standard Vector
        ------------------------------------------------------------
        -- Expected Output: 39 25 84 1d 02 dc 09 fb dc 11 85 97 19 6a 0b 32
        ------------------------------------------------------------
        
        -- 1. Set Mode to ENCRYPT
        mode <= '0';
        
        -- 2. Set Key (Standard 128-bit key)
        -- Key: 2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c
        key <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        -- 3. Set Plaintext Input
        -- Input: 32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34
        intext <= x"3243f6a8885a308d313198a2e0370734";
        
        -- 4. Pulse Start
        wait for clk_period;
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- 5. Wait for Done Signal
        wait until done = '1';
        wait for clk_period;

        -- 6. Check Result
        -- Note: If your simulation stops here with an error, the encryption logic is incorrect.
        assert outtext = x"3925841d02dc09fbdc118597196a0b32"
        report "ERROR: Encrypted output does not match FIPS-197 standard!"
        severity error;
        
        report "SUCCESS: Encryption matched expected FIPS-197 Ciphertext.";

        -- End Simulation
        wait;
    end process;

end Behavioral;