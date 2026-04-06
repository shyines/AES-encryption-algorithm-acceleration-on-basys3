library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.aes_pkg.all;

entity sub_word is
    Port (
        in_word   : in word;
        out_word  : out word;
        selection : in std_logic
     );
end entity sub_word;

architecture Behavioral of sub_word is

    component Sbox is 
        port(
            in_byte   : in byte;
            out_byte  : out byte;
            selection : in std_logic
        );
    end component;

begin

    gen_sbox: for i in 0 to 3 generate
        sbox_portmap: Sbox port map (
            in_byte   => in_word(i),
            out_byte  => out_word(i),
            
            selection => selection 
        );
    end generate gen_sbox;

end Behavioral;