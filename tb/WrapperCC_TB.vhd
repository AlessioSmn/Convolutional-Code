library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity Wrapper_TestBench is 
end entity;

architecture beh of Wrapper_TestBench is 
      constant clk_period : time := 8 ns;

      component CC_Wrapper is
            port(
                  clk:	      in	std_logic;
                  res:	      in	std_logic;
                  i_valid:	in	std_logic;
                  a_k_i:      in    std_logic;
                  a_k_o:	out   std_logic;
                  o_valid:	out	std_logic;
                  c:	      out   std_logic
            );
      end component;
      
      -- clock signal
      signal clk_ext :        std_logic := '0';
   
      -- Reset signal (note: active low)
      signal res_ext:         std_logic := '1';

      -- current input signal
      signal a_k_ext:         std_logic := '0';

      -- valid input signal
      signal i_v_ext:         std_logic := '0';

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

      i_DUT: CC_Wrapper
            port map(
                  clk => clk_ext,
                  res => res_ext,
                  i_valid => i_v_ext,
                  a_k_i => a_k_ext,
                  o_valid => o_v_ext,
                  a_k_o => a_k_o_ext,
                  c => c_ext
            );
      
      p_STIMULUS: process 
      begin 

      -- Test 1) Test Reset
            res_ext <= '0';
            c_expected <= '0';
            wait for clk_period*2;
            wait until rising_edge(clk_ext);
            res_ext <= '1';

      -- Test 2) Test i_valid
            -- 2.1) Change the input stream
		a_k_ext <= '1';
		wait for clk_period*5;

            -- 2.1) Set an internal state, change the input stream
		a_k_ext <= '1';
            i_v_ext <= '1';
		wait for clk_period;
            i_v_ext <= '0';
		c_expected <= '1';
		wait for clk_period*3;

            -- Reset internal state
            res_ext <= '0';
		c_expected <= '0';
            wait for clk_period;
            res_ext <= '1';


            i_v_ext <= '1';


      -- Test 3) Keep input to zero 
		a_k_ext <= '0';
		c_expected <= '0';
		wait for clk_period*11;

            -- Reset internal state
            res_ext <= '0';
            wait for clk_period;
            res_ext <= '1';


      -- Test 4) Keep input to one 
      
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [1000000000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1100] [1100000000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1110] [1110000000]
		 -- Register masked [xx10] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0111000000]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1011100000]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1101110000]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1110111000]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1111011100]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0111101110]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0011110111]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1001111011]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0100111101]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1010011110]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0101001111]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1010100111]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1101010011]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0110101001]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0011010100]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0001101010]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1000110101]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1100011010]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1110001101]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1111000110]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0111100011]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0011110001]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0001111000]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1000111100]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0100011110]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0010001111]
		 -- Register masked [xx11] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1001000111]
		 -- Register masked [xx11] [xxxxxxx1x1]

            -- Reset internal state
            res_ext <= '0';
		c_expected <= '0';
            wait for clk_period;
            res_ext <= '1';


      -- Test 5) Random input stream 

		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [1000000000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0100] [0100000000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0010] [0010000000]
		 -- Register masked [xx10] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1001] [0001000000]
		 -- Register masked [xx01] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [1000100000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0010] [0100010000]
		 -- Register masked [xx10] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1001] [0010001000]
		 -- Register masked [xx01] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [1001000100]
		 -- Register masked [xx00] [xxxxxxx1x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0010] [1100100010]
		 -- Register masked [xx10] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0001] [1110010001]
		 -- Register masked [xx01] [xxxxxxx0x1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [0111001000]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [0011100100]
		 -- Register masked [xx00] [xxxxxxx1x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [1001110010]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0000] [0100111001]
		 -- Register masked [xx00] [xxxxxxx0x1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [1010011100]
		 -- Register masked [xx00] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1000] [0101001110]
		 -- Register masked [xx00] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1100] [0010100111]
		 -- Register masked [xx00] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1110] [1001010011]
		 -- Register masked [xx10] [xxxxxxx0x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1111] [1100101001]
		 -- Register masked [xx11] [xxxxxxx0x1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0111] [1110010100]
		 -- Register masked [xx11] [xxxxxxx1x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0011] [1111001010]
		 -- Register masked [xx11] [xxxxxxx0x0]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [0001] [0111100101]
		 -- Register masked [xx01] [xxxxxxx1x1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0000] [1011110010]
		 -- Register masked [xx00] [xxxxxxx0x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1000] [1101111001]
		 -- Register masked [xx00] [xxxxxxx0x1]
		a_k_ext <= '0';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [0100] [1110111100]
		 -- Register masked [xx00] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1010] [0111011110]
		 -- Register masked [xx10] [xxxxxxx1x0]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '1';

		 -- Register states [1101] [1011101111]
		 -- Register masked [xx01] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1110] [0101110111]
		 -- Register masked [xx10] [xxxxxxx1x1]
		a_k_ext <= '1';
		wait for clk_period;
		c_expected <= '0';

		 -- Register states [1111] [0010111011]
		 -- Register masked [xx11] [xxxxxxx0x1]

            -- Reset internal state
            res_ext <= '0';
            wait for clk_period;
            res_ext <= '1';

      
      -- End Tests
            testing <= false;
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;