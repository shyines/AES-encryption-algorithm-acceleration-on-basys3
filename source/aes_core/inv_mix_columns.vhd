----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2026 04:54:21 PM
-- Design Name: 
-- Module Name: inv_mix_columns - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.aes_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inv_mix_columns is
  Port (
        in_word: in word;
        out_word: out word
        );
end inv_mix_columns;

architecture Behavioral of inv_mix_columns is

function xtimes(a: std_logic_vector(7 downto 0)) return std_logic_vector;
function xtimes (a: std_logic_vector(7 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(7 downto 0);
    begin
        result := a(6 downto 0) & '0';
        if(a(7) = '1')then
        result := result xor x"1B"; 
        end if;
        return result;
    end function;

signal x1: word;
signal x2: word;
signal x4: word;
signal x8: word;

begin

x1 <= in_word;

precalculate: for i in 0 to 3 generate
                x2(i) <= xtimes(x1(i));
                x4(i) <= xtimes(x2(i));
                x8(i) <= xtimes(x4(i));
    end generate;
    
    out_word(0) <= (x8(0) xor x4(0) xor x2(0))       -- 14 * in(0)
               xor (x8(1) xor x2(1) xor x1(1))       -- 11 * in(1)
               xor (x8(2) xor x4(2) xor x1(2))       -- 13 * in(2)
               xor (x8(3) xor x1(3));                -- 9  * in(3)

    out_word(1) <= (x8(0) xor x1(0))                 -- 9  * in(0)
               xor (x8(1) xor x4(1) xor x2(1))       -- 14 * in(1)
               xor (x8(2) xor x2(2) xor x1(2))       -- 11 * in(2)
               xor (x8(3) xor x4(3) xor x1(3));      -- 13 * in(3)

    out_word(2) <= (x8(0) xor x4(0) xor x1(0))       -- 13 * in(0)
               xor (x8(1) xor x1(1))                 -- 9  * in(1)
               xor (x8(2) xor x4(2) xor x2(2))       -- 14 * in(2)
               xor (x8(3) xor x2(3) xor x1(3));      -- 11 * in(3)

    out_word(3) <= (x8(0) xor x2(0) xor x1(0))       -- 11 * in(0)
               xor (x8(1) xor x4(1) xor x1(1))       -- 13 * in(1)
               xor (x8(2) xor x1(2))                 -- 9  * in(2)
               xor (x8(3) xor x4(3) xor x2(3));

end Behavioral;
