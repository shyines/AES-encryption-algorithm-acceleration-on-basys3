----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2025 05:29:18 PM
-- Design Name: 
-- Module Name: cypher_round - Behavioral
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

entity cypher_round is
  Port ( 
    in_matrix: in state_matrix;
    round_key: in std_logic_vector(127 downto 0);
    out_matric: out state_matrix
  );
end cypher_round;

architecture Behavioral of cypher_round is

    -- Component Declarations (Paste yours here if not already present in package)
    component shift_rows is
        Port ( in_bytes: in state_matrix; out_bytes: out state_matrix );
    end component;

    component mix_columns is
        Port ( in_word: in word; out_word: out word );
    end component;

    component sub_matrix is
        Port ( in_matrix: in state_matrix; out_matrix: out state_matrix; selection: in std_logic );
    end component;

    component add_round_key is
        Port ( in_matrix: in state_matrix; round_key: in std_logic_vector(127 downto 0); out_matrix: out state_matrix );
    end component;

    -- Intermediate signals
    signal out_matrix_sub_bytes     : state_matrix;
    signal out_matrix_shift_rows    : state_matrix;
    signal out_matrix_mix_columns   : state_matrix;

begin

    ---------------------------------------------------------------------------
    -- Step 1: SubBytes (Standard AES Step 1)
    -- Transforms the input state using the S-Box
    ---------------------------------------------------------------------------
    U_SubBytes: sub_matrix port map (
        in_matrix  => in_matrix,
        out_matrix => out_matrix_sub_bytes,
        selection => '0'
    );

    ---------------------------------------------------------------------------
    -- Step 2: ShiftRows (Standard AES Step 2)
    -- Permutes the rows of the matrix
    ---------------------------------------------------------------------------
    U_ShiftRows: shift_rows port map (
        in_bytes  => out_matrix_sub_bytes,
        out_bytes => out_matrix_shift_rows
    );

    ---------------------------------------------------------------------------
    -- Step 3: MixColumns (Standard AES Step 3)
    -- Linearly combines the columns.
    -- NOTE: MixColumns works on 1 column (Word) at a time. 
    -- We must generate 4 instances to process the full matrix in parallel.
    ---------------------------------------------------------------------------
    Gen_MixCols: for i in 0 to 3 generate
        U_MixCols: mix_columns port map (
            in_word  => out_matrix_shift_rows(i),
            out_word => out_matrix_mix_columns(i)
        );
    end generate Gen_MixCols;

    ---------------------------------------------------------------------------
    -- Step 4: AddRoundKey (Standard AES Step 4)
    -- XORs the state with the Round Key
    ---------------------------------------------------------------------------
    U_AddKey: add_round_key port map (
        in_matrix  => out_matrix_mix_columns,
        round_key  => round_key,
        out_matrix => out_matric  -- Note: Using the name from your entity port
    );

end Behavioral;
