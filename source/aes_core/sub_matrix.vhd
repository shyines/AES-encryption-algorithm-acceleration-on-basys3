----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2025 04:25:02 PM
-- Design Name: 
-- Module Name: sub_matrix - Behavioral
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

entity sub_matrix is
  Port (
    in_matrix: in state_matrix;
    out_matrix: out state_matrix;
    selection: in std_logic
   );
end sub_matrix;

architecture Behavioral of sub_matrix is

component sub_word is
    Port (
        in_word: in word;
        out_word: out word;
        selection: in std_logic
     );
end component;

begin

gen_matrix: for i in 0 to 3 generate
    sub_word_portmap: sub_word port map
    (
        in_word => in_matrix(i),
        out_word => out_matrix(i),
        selection => selection
    );
end generate gen_matrix;

end Behavioral;
