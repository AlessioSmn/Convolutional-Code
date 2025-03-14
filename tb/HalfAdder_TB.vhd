library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity halfAdder_TestBench is 
end entity;

architecture beh of halfAdder_TestBench is 
      -- Clock frequency of 125MHz
      constant clk_period : time := 8 ns; 
      component HalfAdder is
            port(
                  -- Input 1
                  a:    in    std_logic;
                  -- Input 2 / Carry
                  cin:  in    std_logic;
                  -- Output
                  s:    out   std_logic
            );
      end component;

      -- clock signal
      signal clk_ext :  std_logic := '0';

      -- input signal
      signal a_ext :    std_logic := '0';

      -- cin signal
      signal cin_ext :  std_logic := '0';

      -- produced output signal
      signal s_ext :    std_logic;

      -- expected output signal
      signal s_e_ext :  std_logic;

      -- error flag
      signal out_error: std_logic; 

      -- testing flag
      signal testing :  boolean := true;

begin 
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';
      out_error <= '0' when s_ext = s_e_ext else '1';

      i_DUT: HalfAdder
            port map(
                  a => a_ext,
                  cin => cin_ext,
                  s => s_ext
            );
            
      p_STIMULUS: process 
      begin 

      -- Test all 4 possible cases
            a_ext <= '0';
            cin_ext <= '0';
            s_e_ext <= '0';
            wait for clk_period;

            a_ext <= '1';
            cin_ext <= '0';
            s_e_ext <= '1';
            wait for clk_period;

            a_ext <= '0';
            cin_ext <= '1';
            s_e_ext <= '1';
            wait for clk_period;

            a_ext <= '1';
            cin_ext <= '1';
            s_e_ext <= '0';
            wait for clk_period;

      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;