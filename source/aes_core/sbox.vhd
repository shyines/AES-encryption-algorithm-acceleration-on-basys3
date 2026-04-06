library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.aes_pkg.all;

entity Sbox is
    port (
       in_byte: in byte;
       out_byte: out byte;
       selection: in std_logic
       );
end Sbox;

architecture Behavioral of Sbox is

begin

out_byte <= sbox_rom(to_integer(unsigned(in_byte))) when selection  = '0' else inv_sbox_rom(TO_INTEGER(unsigned(in_byte)));

end Behavioral;