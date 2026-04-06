----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2025 11:48:38 AM
-- Design Name: 
-- Module Name: key_expansion - Behavioral
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
use IEEE.numeric_std.all;
use work.aes_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_expansion is
  Port (
    clk: in std_logic;
    en: in std_logic;
    key_in: in std_logic_vector(127 downto 0);
    rst: in std_logic;
    
    
    ready: out std_logic;
    round_sel: in integer range 0 to 10;
    out_key: out std_logic_vector (127 downto 0)
   );
end key_expansion;

architecture Behavioral of key_expansion is
--all the keys for the round will be stored in a
type rom is array (0 to 43) of word;
signal key_words: rom;

type rcon_type is array (1 to 10) of std_logic_vector(7 downto 0);
constant RCON : rcon_type := (
    x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36"
);

component sub_word is
       port (
           in_word   : in word;
           out_word  : out word;
           selection : in std_logic 
       );
end component;
    
--states for the fsm machine
type states is (idle, first_4_rows, computing, nk_row, finished);
signal state: states := idle;

signal word_index: integer range 0 to 44 := 0;
signal byte_index: integer range 0 to 3 := 0;

signal temp_word: word := (others => x"00");

signal sub_word_out: word := (others => x"00");
signal sub_word_in: word := (others => x"00");

signal debug_i_nk: integer;

signal s_en: std_logic;
begin

sub_word_portmap: sub_word port map(
        in_word   => sub_word_in,
        out_word  => sub_word_out,
        selection => '0'
    );

process(clk)
variable i_nk: integer := 0;
begin
if(rising_edge(clk)) then
 if rst = '1' then
    state <= idle;
    byte_index <= 0;
    word_index <= 0;
    ready <= '0';
    temp_word <= (others => x"00");
 else
    case state is
       when idle =>
        if en = '1' then
            state <= first_4_rows;
        else
            state <= idle;
            word_index <= 0;
            byte_index <= 0;
            ready <= '0';
            temp_word <= (others => x"00");
        end if;
       when first_4_rows =>
        key_words(0) <= conv_word(key_in(127 downto 96));
        key_words(1) <= conv_word(key_in(95 downto 64));
        key_words(2) <= conv_word(key_in(63 downto 32));
        key_words(3) <= conv_word(key_in(31 downto 0));
        word_index <= 4; -- Incepem sa calculam de la word_index = 4
        state <= computing;
       when computing =>
       if word_index = 44 then
            state <= finished;
        else
            temp_word <= key_words(word_index - 1);
            if((word_index mod 4) = 0)then
                sub_word_in(0) <= key_words(word_index - 1)(1);
                sub_word_in(1) <= key_words(word_index - 1)(2);
                sub_word_in(2) <= key_words(word_index - 1)(3);
                sub_word_in(3) <= key_words(word_index - 1)(0);
                state <= nk_row;
            else
                key_words(word_index) <= key_words(word_index - 4) xor key_words(word_index - 1);
                word_index <= word_index + 1;
            end if;
        end if;
       when nk_row =>
        i_nk := word_index / 4;
        key_words(word_index) <= key_words(word_index - 4) xor 
                             (sub_word_out xor conv_word(rcon(i_nk) & x"000000"));
                             
        word_index <= word_index + 1;
        state <= computing;
       when finished =>
        ready <= '1';
        if en = '0' then
            state <= idle;
        else
            state <= finished;
        end if;
    end case;
end if;
end if;

end process;

out_key <= word_to_slv(key_words(round_sel*4)) & word_to_slv(key_words(round_sel*4 + 1)) & word_to_slv(key_words(round_sel*4 + 2)) & word_to_slv(key_words(round_sel*4 + 3));
end Behavioral;
