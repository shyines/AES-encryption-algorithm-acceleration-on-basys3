----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2025 12:56:59 PM
-- Design Name: 
-- Module Name: Mix_Columns - Behavioral
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

entity Mix_Columns is
  Port (
        in_word: in word;
        out_word: out word
        );
end Mix_Columns;

architecture Behavioral of Mix_Columns is
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


begin

out_word(0) <= xtimes(in_word(0)) xor (xtimes(in_word(1)) xor in_word(1)) xor in_word(2) xor in_word(3);
out_word(1) <= in_word(0) xor xtimes(in_word(1)) xor (xtimes(in_word(2)) xor in_word(2)) xor in_word(3);
out_word(2) <= in_word(0) xor in_word(1) xor xtimes(in_word(2)) xor (xtimes(in_word(3)) xor in_word(3));
out_word(3) <= (xtimes(in_word(0)) xor in_word(0)) xor in_word(1) xor in_word(2) xor xtimes(in_word(3));


end Behavioral;
