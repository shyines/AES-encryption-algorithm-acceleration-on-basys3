library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Include your package so we can use "conv_word" if needed, 
-- or just for consistency (though TB doesn't strictly need it if strictly using hex)
use work.aes_pkg.all; 

entity tb_Key_Expansion is
    -- Testbench has no ports
end tb_Key_Expansion;

architecture Behavioral of tb_Key_Expansion is

    -- 1. DUT Declaration (Must match your Key_Expansion.vhd Entity exactly)
    component key_expansion is
        Port (
           clk: in std_logic;
           en: in std_logic;
           key_in: in std_logic_vector(127 downto 0);
           rst: in std_logic;
    
           ready: out std_logic;
           round_sel: in integer range 0 to 10;
           out_key: out std_logic_vector (127 downto 0)
        );
    end component;

    -- 2. Signals
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '0';
    signal start          : std_logic := '0';
    signal key_in         : std_logic_vector(127 downto 0) := (others => '0');
    
    -- Removed sbox_read_addr / sbox_read_data (No longer needed!)
    
    signal ready          : std_logic;
    signal round_sel      : integer range 0 to 10 := 0;
    signal round_key_out  : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: Key_Expansion port map (
        clk => clk,
        rst => rst,
        en => start,
        key_in => key_in,
        ready => ready,
        round_sel => round_sel,
        out_key => round_key_out
    );

    -- Clock Process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        -- Test Vector from FIPS-197 (Appendix A.1)
        -- Input Key: 2b 7e 15 16 ...
        key_in <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for CLK_PERIOD;

        -- Start Expansion
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for computation to finish
        wait until ready = '1';
        wait for CLK_PERIOD;

        -- Verify Round Key 0 (Should match Input Key)
        round_sel <= 0;
        wait for CLK_PERIOD;
        assert round_key_out = x"2b7e151628aed2a6abf7158809cf4f3c" 
            report "Round 0 Failed" severity error;

        -- Verify Round Key 1
        -- Expected: a0 fa fe 17 ...
        round_sel <= 1;
        wait for CLK_PERIOD;
        assert round_key_out = x"a0fafe1788542cb123a339392a6c7605" 
            report "Round 1 Failed" severity error;

        -- Verify Round Key 10 (Final Key)
        -- Expected: d0 14 f9 a8 ...
        round_sel <= 10;
        wait for CLK_PERIOD;
        assert round_key_out = x"d014f9a8c9ee2589e13f0cc8b6630ca6" 
            report "Round 10 Failed" severity error;

        report "Key Expansion Simulation Completed." severity note;
        wait;
    end process;

end Behavioral;