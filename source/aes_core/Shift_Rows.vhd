----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2025 04:03:32 PM
-- Design Name: 
-- Module Name: Shift_Rows - Behavioral
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

entity Shift_Rows is
    Port (
        in_bytes: in state_matrix;
        out_bytes: out state_matrix
        );
end Shift_Rows;

architecture Behavioral of Shift_Rows is
begin
    -- ROW 0: No Shift
    out_bytes(0)(0) <= in_bytes(0)(0);
    out_bytes(1)(0) <= in_bytes(1)(0);
    out_bytes(2)(0) <= in_bytes(2)(0);
    out_bytes(3)(0) <= in_bytes(3)(0);

    out_bytes(0)(1) <= in_bytes(1)(1);
    out_bytes(1)(1) <= in_bytes(2)(1);
    out_bytes(2)(1) <= in_bytes(3)(1);
    out_bytes(3)(1) <= in_bytes(0)(1);

    out_bytes(0)(2) <= in_bytes(2)(2);
    out_bytes(1)(2) <= in_bytes(3)(2);
    out_bytes(2)(2) <= in_bytes(0)(2);
    out_bytes(3)(2) <= in_bytes(1)(2);

    out_bytes(0)(3) <= in_bytes(3)(3);
    out_bytes(1)(3) <= in_bytes(0)(3);
    out_bytes(2)(3) <= in_bytes(1)(3);
    out_bytes(3)(3) <= in_bytes(2)(3);

end Behavioral;
