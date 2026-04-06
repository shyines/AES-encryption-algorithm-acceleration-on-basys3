library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.aes_pkg.all;

entity AES_Top is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        intext     : in  std_logic_vector(127 downto 0); -- Renamed from plaintext/ciphertext to be generic
        key        : in  std_logic_vector(127 downto 0);
        
        mode       : in  std_logic; -- '0' = Encrypt, '1' = Decrypt
        
        outtext    : out std_logic_vector(127 downto 0);
        done       : out std_logic
    );
end AES_Top;

architecture Behavioral of AES_Top is

    -- 1. COMPONENT DECLARATIONS (Kept exactly as you had them)
    component Key_Expansion is
        Port (
            clk, rst, en : in std_logic;
            key_in : in std_logic_vector(127 downto 0);
            ready : out std_logic;
            round_sel : in integer range 0 to 10;
            out_key : out std_logic_vector(127 downto 0)
        );
    end component;

    component cypher_round is
        Port ( in_matrix : in state_matrix; round_key : in std_logic_vector(127 downto 0); out_matric : out state_matrix );
    end component;
    
    component inv_cypher_round is
        Port ( in_matrix : in state_matrix; round_key : in std_logic_vector(127 downto 0); out_matric : out state_matrix );
    end component;

    component sub_matrix is
        Port ( in_matrix: in state_matrix; out_matrix: out state_matrix; selection: in std_logic );
    end component;

    component shift_rows is
        Port ( in_bytes: in state_matrix; out_bytes: out state_matrix );
    end component;
    
    component inv_shift_rows is
        Port ( in_bytes: in state_matrix; out_bytes: out state_matrix );
    end component;

    component add_round_key is
        Port ( in_matrix: in state_matrix; round_key: in std_logic_vector(127 downto 0); out_matrix: out state_matrix );
    end component;

    -- 2. SIGNALS
    type fsm_state is (IDLE, KEY_EXPANSION_WAIT, ROUND_0, ROUNDS_1_9, ROUND_10, FINISH);
    signal state : fsm_state;

    signal current_state    : state_matrix; 
    signal intext_matrix    : state_matrix;
    
    -- ENCRYPTION SIGNALS
    signal r0_out_matrix           : state_matrix;
    signal r1_9_out_matrix_enc     : state_matrix; -- Renamed for clarity
    signal r10_sub_out_enc         : state_matrix;
    signal r10_shift_out_enc       : state_matrix;
    signal r10_final_out_enc       : state_matrix;
    
    -- DECRYPTION SIGNALS
    signal r0_out_matrix_dec       : state_matrix; -- Needed separate R0 output for Decryption
    signal r1_9_out_matrix_dec     : state_matrix;
    signal r10_shift_out_dec       : state_matrix;
    signal r10_sub_out_dec         : state_matrix;
    signal r10_final_out_dec       : state_matrix;
    
    -- CONTROL SIGNALS
    signal round_key        : std_logic_vector(127 downto 0);
    signal key_exp_ready    : std_logic;
    signal key_gen_start    : std_logic := '0';
    signal round_ctr        : integer range 0 to 10;

    --debug
    signal debug_state_flat : std_logic_vector(127 downto 0);
    attribute mark_debug : string;
    attribute mark_debug of debug_state_flat : signal is "true";

begin
    debug_state_flat <= word_to_slv(current_state(0)) & 
                        word_to_slv(current_state(1)) & 
                        word_to_slv(current_state(2)) & 
                        word_to_slv(current_state(3));
    -- 3. DATA CONVERSION
    intext_matrix(0) <= conv_word(intext(127 downto 96));
    intext_matrix(1) <= conv_word(intext(95 downto 64));
    intext_matrix(2) <= conv_word(intext(63 downto 32));
    intext_matrix(3) <= conv_word(intext(31 downto 0));

    -- 4. HARDWARE INSTANTIATION

    -- Key Expansion
    U_KeyGen : Key_Expansion port map (
        clk => clk, rst => rst, en => key_gen_start, key_in => key,
        ready => key_exp_ready, round_sel => round_ctr, out_key => round_key
    );

    -----------------------------------------------------------------------
    -- ENCRYPTION CHAIN
    -----------------------------------------------------------------------
    U_R0_Add_Enc: add_round_key port map (intext_matrix, round_key, r0_out_matrix);

    U_Standard_Round: cypher_round port map (current_state, round_key, r1_9_out_matrix_enc);

    -- Round 10 Encrypt: Sub -> Shift -> Add
    U_R10_Sub_Enc:   sub_matrix    port map (current_state, r10_sub_out_enc, '0'); 
    U_R10_Shift_Enc: shift_rows    port map (r10_sub_out_enc, r10_shift_out_enc);
    U_R10_Add_Enc:   add_round_key port map (r10_shift_out_enc, round_key, r10_final_out_enc);

    -----------------------------------------------------------------------
    -- DECRYPTION CHAIN
    -----------------------------------------------------------------------
    -- Note: Decryption also starts with AddRoundKey (using Key[10])
    U_R0_Add_Dec: add_round_key port map (intext_matrix, round_key, r0_out_matrix_dec);

    U_Inv_Standard_Round: inv_cypher_round port map (current_state, round_key, r1_9_out_matrix_dec);

    -- Round 10 Decrypt: InvShift -> InvSub -> Add
    -- (Order is different for decryption!)
    inv_U_R10_Shift: inv_shift_rows port map (current_state, r10_shift_out_dec);
    
    -- We reuse sub_matrix with selection='1' for InvSubBytes
    inv_U_R10_Sub:   sub_matrix     port map (r10_shift_out_dec, r10_sub_out_dec, '1'); 
    
    inv_U_R10_Add:   add_round_key  port map (r10_sub_out_dec, round_key, r10_final_out_dec);


    -- 5. FSM (CONTROLLER WITH KEY REVERSAL LOGIC)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                done <= '0';
                key_gen_start <= '0';
                round_ctr <= 0;
            else
                case state is
                    when IDLE =>
                        done <= '0';
                        if start = '1' then
                            key_gen_start <= '1';
                            state <= KEY_EXPANSION_WAIT;
                        end if;

                    when KEY_EXPANSION_WAIT =>
                        key_gen_start <= '0';
                        if key_exp_ready = '1' then
                            -- SETUP COUNTERS: ENCRYPT=0, DECRYPT=10
                            if mode = '0' then
                                round_ctr <= 0;
                            else
                                round_ctr <= 10;
                            end if;
                            state <= ROUND_0;
                        end if;

                    when ROUND_0 =>
                        if mode = '0' then
                            -- ENCRYPTION: Uses Key 0, moves to Key 1
                            current_state <= r0_out_matrix;
                            round_ctr <= 1;
                        else
                            -- DECRYPTION: Uses Key 10, moves to Key 9
                            current_state <= r0_out_matrix_dec;
                            round_ctr <= 9;
                        end if;
                        state <= ROUNDS_1_9;

                    when ROUNDS_1_9 =>
                        -- MUX SELECT
                        if mode = '0' then
                            current_state <= r1_9_out_matrix_enc;
                            -- COUNT UP
                            if round_ctr = 9 then
                                round_ctr <= 10;
                                state <= ROUND_10;
                            else
                                round_ctr <= round_ctr + 1;
                            end if;
                        else
                            current_state <= r1_9_out_matrix_dec;
                            -- COUNT DOWN
                            if round_ctr = 1 then
                                round_ctr <= 0;
                                state <= ROUND_10;
                            else
                                round_ctr <= round_ctr - 1;
                            end if;
                        end if;

                    when ROUND_10 =>
                        -- FIXED: Tap the FINAL output, not the intermediate SUB output
                        if mode = '0' then
                            current_state <= r10_final_out_enc;
                        else
                            current_state <= r10_final_out_dec;
                        end if;
                        state <= FINISH;

                    when FINISH =>
                        done <= '1';
                        outtext <= word_to_slv(current_state(0)) & 
                                   word_to_slv(current_state(1)) & 
                                   word_to_slv(current_state(2)) & 
                                   word_to_slv(current_state(3));
                        
                        if start = '0' then 
                            state <= IDLE; 
                        end if;
                end case;
            end if;
        end if;
    end process;

end Behavioral;