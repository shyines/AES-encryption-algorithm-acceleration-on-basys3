----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2026 05:03:52 PM
-- Design Name: 
-- Module Name: inv_cypher_round - Behavioral
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

entity inv_cypher_round is
    Port ( 
        in_matrix: in state_matrix;
        round_key: in std_logic_vector(127 downto 0);
        out_matric: out state_matrix
      );
end inv_cypher_round;

architecture Behavioral of inv_cypher_round is

    component inv_shift_rows is
        Port ( in_bytes: in state_matrix; out_bytes: out state_matrix );
    end component;

    component inv_mix_columns is
        Port ( in_word: in word; out_word: out word );
    end component;

    component sub_matrix is
        Port ( in_matrix: in state_matrix; out_matrix: out state_matrix; selection: in std_logic );
    end component;

    component add_round_key is
        Port ( in_matrix: in state_matrix; round_key: in std_logic_vector(127 downto 0); out_matrix: out state_matrix );
    end component;

    signal out_matrix_inv_sub_bytes     : state_matrix;
    signal out_matrix_inv_shift_rows    : state_matrix;
    signal out_matrix_add_round_key   : state_matrix;
begin
    inverse_shift_rows: inv_shift_rows port map (
        in_bytes  => in_matrix,
        out_bytes => out_matrix_inv_shift_rows
    );
    
    inv_sub_matrix: sub_matrix port map(
        in_matrix => out_matrix_inv_shift_rows,
        out_matrix => out_matrix_inv_sub_bytes,
        selection => '1'
    );
    
    inv_add_round_key: add_round_key port map(
        in_matrix => out_matrix_inv_sub_bytes,
        out_matrix => out_matrix_add_round_key,
        round_key => round_key
    );
    
    inverse_column:
        for i in 0 to 3 generate
            U_InvMixCols: inv_mix_columns port map (
                in_word  => out_matrix_add_round_key(i),
                out_word => out_matric(i)
            );
        end generate;
        
end Behavioral;
