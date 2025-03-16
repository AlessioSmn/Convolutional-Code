library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity ConvolutionalCoder_TestBench is 
end entity;

architecture beh of ConvolutionalCoder_TestBench is 
      constant clk_period : time := 8 ns;
      constant InputMemory : positive := 4; 
      constant CodewordMemory : positive := 6;

      component ConvolutionalCoder is
            generic (
                  InputMemory: positive := 8;
                  CodewordMemory: positive := 8
            );
            port(
            TEST_INPUT_REG: out std_logic_vector(InputMemory - 1 downto 0);
            TEST_STATE_REG: out std_logic_vector(CodewordMemory - 1 downto 0);
                  clk:	      in	std_logic;
                  res:	      in	std_logic;
                  i_valid:	in	std_logic;
                  a_k_i:	in    std_logic;
                  c_mask:     in    std_logic;
                  i_mask:     in    std_logic_vector(InputMemory - 1 downto 0);
                  s_mask:     in    std_logic_vector(CodewordMemory - 1 downto 0);
                  o_valid:	out	std_logic;
                  a_k_o:	out	std_logic;
                  c:	      out   std_logic
            );
      end component;

      -- clock signal
      signal clk_ext :        std_logic := '0';

      signal TEST_INPUT_REG_ext: std_logic_vector(InputMemory - 1 downto 0);
      signal TEST_STATE_REG_ext: std_logic_vector(CodewordMemory - 1 downto 0);
            
      -- Reset signal (note: active low)
      signal res_ext:         std_logic := '1';

      -- current input signal
      signal a_k_ext:         std_logic := '0';

      -- valid input signal
      signal i_v_ext:         std_logic := '0';

      -- current input mask signal
      signal c_m_ext:         std_logic := '0';

      -- past input array mask signal
      signal i_m_ext:         std_logic_vector(InputMemory - 1 downto 0) := "0000";

      -- past codewords array mask signal
      signal s_m_ext:         std_logic_vector(CodewordMemory - 1 downto 0) := "000000";

      -- valid output signal
      signal o_v_ext:         std_logic;

      -- out signal
      signal c_ext :          std_logic;

      -- Current input, taken out, signal
      signal a_k_o_ext :      std_logic;

      -- expected output signal
      signal c_expected :     std_logic;

      -- error flag
      signal c_error :        std_logic;

      -- testing flag
      signal testing :        boolean := true;
      
begin  
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';
      c_error <= '0' when c_expected = c_ext else '1';

      i_DUT: ConvolutionalCoder
            generic map(
                  InputMemory => InputMemory,
                  CodewordMemory => CodewordMemory
            )
            port map (
                  TEST_INPUT_REG => TEST_INPUT_REG_ext,
                  TEST_STATE_REG => TEST_STATE_REG_ext,
                  clk => clk_ext,
                  res => res_ext,
                  i_valid => i_v_ext,
                  a_k_i => a_k_ext,
                  c_mask => c_m_ext,
                  i_mask => i_m_ext,
                  s_mask => s_m_ext,
                  o_valid => o_v_ext,
                  a_k_o => a_k_o_ext,
                  c => c_ext
            );

      p_STIMULUS: process 
      begin 
      -- Test 1) Test reset
            res_ext <= '0';
            wait for clk_period*2;
            -- reset off
            res_ext <= '1';

            wait until rising_edge(clk_ext);


            -- Current Input: 1
            c_m_ext <= '1';

            -- Set the input to valid
            i_v_ext <= '1';

            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
      
      -- Test 2) Keep input to 0: should keep outputting 0
            -- Input Mask:	
            i_m_ext <= "0011";	
		-- Codeword Mask:
            s_m_ext <= "000101";

            a_k_ext <= '0';
		c_expected <= '0';
		wait for clk_period*CodewordMemory;




            -- Reset to initial state
            res_ext <= '0';
            a_k_ext <= '0';
		wait for clk_period;
            res_ext <= '1';

      

            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;

      -- Test 3) Keep input to 1
            -- Input Mask: 		
            i_m_ext <= "1100";
		-- State Mask: 		
            s_m_ext <= "011010";

		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [100000]
		 -- Register masked [10xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1100] [010000]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1110] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [001000]
		 -- Register masked [11xx] [x01x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [000100]
		 -- Register masked [11xx] [x00x0x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [100010]
		 -- Register masked [11xx] [x00x1x]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [010001]
		 -- Register masked [11xx] [x10x0x]

            -- Reset to initial state
            res_ext <= '0';
            a_k_ext <= '0';
		wait for clk_period;
            res_ext <= '1';



            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;


      -- Test 4) Alternate input between 0 and 1
            -- Input Mask: 
		i_m_ext <= "1001";
		-- Codeword Mask: 
		s_m_ext <= "010001";

		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [000000]
		 -- Register masked [0xx0] [x0xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [100000]
		 -- Register masked [1xx0] [x0xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [110000]
		 -- Register masked [0xx0] [x1xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [011000]
		 -- Register masked [1xx0] [x1xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [001100]
		 -- Register masked [0xx1] [x0xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [000110]
		 -- Register masked [1xx0] [x0xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [100011]
		 -- Register masked [0xx1] [x0xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [110001]
		 -- Register masked [1xx0] [x1xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [111000]
		 -- Register masked [0xx1] [x1xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [111100]
		 -- Register masked [1xx0] [x1xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [011110]
		 -- Register masked [0xx1] [x1xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [101111]
		 -- Register masked [1xx0] [x0xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [010111]
		 -- Register masked [0xx1] [x1xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [001011]
		 -- Register masked [1xx0] [x0xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [000101]
		 -- Register masked [0xx1] [x0xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [100010]
		 -- Register masked [1xx0] [x0xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [110001]
		 -- Register masked [0xx1] [x1xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [011000]
		 -- Register masked [1xx0] [x1xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [001100]
		 -- Register masked [0xx1] [x0xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [000110]
		 -- Register masked [1xx0] [x0xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [100011]
		 -- Register masked [0xx1] [x0xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [110001]
		 -- Register masked [1xx0] [x1xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [111000]
		 -- Register masked [0xx1] [x1xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [111100]
		 -- Register masked [1xx0] [x1xxx0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [011110]
		 -- Register masked [0xx1] [x1xxx0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [101111]
		 -- Register masked [1xx0] [x0xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [010111]
		 -- Register masked [0xx1] [x1xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [001011]
		 -- Register masked [1xx0] [x0xxx1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [000101]
		 -- Register masked [0xx1] [x0xxx1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [100010]
		 -- Register masked [1xx0] [x0xxx0]


		wait for clk_period;

            -- Reset to initial state
            res_ext <= '0';
		c_expected <= '0';
            a_k_ext <= '0';
		wait for clk_period;
            res_ext <= '1';



            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;

      -- Test 5) Random input stream
            -- Input Mask: 
		i_m_ext <= "0100";
		-- Codeword Mask: 
		s_m_ext <= "011000";

		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [000000]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [000000]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [000000]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [100000]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0100] [010000]
		 -- Register masked [x1xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0010] [001000]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0001] [100100]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [110010]
		 -- Register masked [x0xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [111001]
		 -- Register masked [x1xx] [x11xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [011100]
		 -- Register masked [x0xx] [x11xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [001110]
		 -- Register masked [x1xx] [x01xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [100111]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0101] [010011]
		 -- Register masked [x1xx] [x10xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1010] [101001]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0101] [110100]
		 -- Register masked [x1xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0010] [011010]
		 -- Register masked [x0xx] [x11xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1001] [101101]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [110110]
		 -- Register masked [x1xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0010] [011011]
		 -- Register masked [x0xx] [x11xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0001] [001101]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [100110]
		 -- Register masked [x0xx] [x00xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [010011]
		 -- Register masked [x0xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [101001]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [110100]
		 -- Register masked [x0xx] [x10xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1000] [011010]
		 -- Register masked [x0xx] [x11xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1100] [101101]
		 -- Register masked [x1xx] [x01xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1110] [110110]
		 -- Register masked [x1xx] [x10xxx]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0111] [011011]
		 -- Register masked [x1xx] [x11xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1011] [001101]
		 -- Register masked [x0xx] [x01xxx]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1101] [000110]
		 -- Register masked [x1xx] [x00xxx]


            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;


      -- Test 6) Switch off i_valid, toggling the input
            i_v_ext <= '0';
		c_expected <= '0';
		a_k_ext <= '1';
		wait for clk_period*5;
		a_k_ext <= '0';
		wait for clk_period*5;



            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;


      -- Test 7) Test reset
            res_ext <= '0';
            c_expected <= '0';
            wait for clk_period*2;



            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;

      -- Test 8) Test current input in-out relation;
            a_k_ext <= '1';
            wait for clk_period;
            -- a_k_o should be 1
            a_k_ext <= '0';
            wait for clk_period;
            -- a_k_o should be 0
            a_k_ext <= '1';
            wait for clk_period;
            -- a_k_o should be 1
            a_k_ext <= '0';
            wait for clk_period;
            -- a_k_o should be 0
            a_k_ext <= '1';
            wait for clk_period;
            -- a_k_o should be 1



            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;

      -- Test 9) Test output_valid flag
            i_v_ext <= '1';
            wait for clk_period;
            -- o_valid should be 1
            i_v_ext <= '0';
            wait for clk_period;
            -- o_valid should be 0
            i_v_ext <= '1';
            wait for clk_period;
            -- o_valid should be 1
            i_v_ext <= '0';
            wait for clk_period;
            -- o_valid should be 0
            i_v_ext <= '1';
            wait for clk_period;
            -- o_valid should be 1
            


            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;
            c_expected <= '1'; wait for 1 ns; c_expected <= '0'; wait for 1 ns;

      -- End Tests
            testing <= false;
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;