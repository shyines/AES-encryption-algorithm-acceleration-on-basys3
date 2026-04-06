library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.aes_pkg.all;

entity tb_Mix_Columns is
    -- Testbench entity is always empty
end tb_Mix_Columns;

architecture Behavioral of tb_Mix_Columns is

    -- 1. Component Declaration (Must match your Entity exactly)
    component Mix_Columns is
        Port ( 
            in_word  : in  word;
            out_word : out word
        );
    end component;

    -- 2. Signals to connect to the UUT (Unit Under Test)
    signal s_in_word  : word := (others => x"00");
    signal s_out_word : word;

begin

    uut: Mix_Columns port map (
        in_word  => s_in_word,
        out_word => s_out_word
    );

    stim_proc: process
begin
    
    -- TEST CASE 1: FIPS-197 Example
    -- Input: d4 bf 5d 30
    s_in_word <= (x"d4", x"bf", x"5d", x"30");
    
    wait for 100 ns;
    
    -- Expected Output: 04 66 81 e5
    -- We compare the array against an array aggregate
    assert s_out_word = (x"04", x"66", x"81", x"e5") 
        report "Error: FIPS-197 Example Failed!" severity error;


    -- TEST CASE 2: Zero Input
    s_in_word <= (others => x"00");
    wait for 100 ns;
    
    assert s_out_word = (x"00", x"00", x"00", x"00") 
        report "Error: Zero Test Failed!" severity error;


    -- TEST CASE 3: Identity / Single Bit Check
    -- Input: 01 00 00 00
    s_in_word <= (x"01", x"00", x"00", x"00");
    wait for 100 ns;
    
    -- Expected: 02 01 01 03 (Based on MixColumns matrix multiplication)
    assert s_out_word = (x"02", x"01", x"01", x"03") 
        report "Error: Identity Test Failed!" severity error;


    report "Simulation Finished" severity note;
    wait;
end process;

end Behavioral;