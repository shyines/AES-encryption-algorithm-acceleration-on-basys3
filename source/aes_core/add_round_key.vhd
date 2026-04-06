----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2025 05:23:38 PM
-- Design Name: 
-- Module Name: add_round_key - Behavioral
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

entity add_round_key is
  Port (
    in_matrix: in state_matrix;
    round_key: in std_logic_vector(127 downto 0);
    out_matrix: out state_matrix
   );
end add_round_key;

architecture Behavioral of add_round_key is
begin
    out_matrix(0) <= in_matrix(0) xor conv_word(round_key(127 downto 96));
    out_matrix(1) <= in_matrix(1) xor conv_word(round_key(95 downto 64));
    out_matrix(2) <= in_matrix(2) xor conv_word(round_key(63 downto 32));
    out_matrix(3) <= in_matrix(3) xor conv_word(round_key(31 downto 0));
end Behavioral;
