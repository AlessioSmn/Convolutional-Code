library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity Adder_TestBench is 
end entity;

architecture beh of Adder_TestBench is 
      -- Clock frequency of 125MHz
      constant clk_period : time := 8 ns;
      constant Dimension : positive := 4;  

      component Adder is
            generic (
                  N: positive := 8
            );
            port(
                  a:    in    std_logic_vector(N-1 downto 0);
                  s:    out   std_logic
            );
      end component;

      -- clock signal
      signal clk_ext :  std_logic := '0';

      -- input signal
      signal a_ext :    std_logic_vector(Dimension - 1 downto 0) := (others => '0');

      -- output signal
      signal s_ext :    std_logic;

      -- excpected output signal
      signal s_e_ext :  std_logic;

      -- error flag
      signal out_error: std_logic; 

      -- testing flag
      signal testing :  boolean := true;
begin

      clk_ext <= not clk_ext after clk_period/2 when testing else '0';

      out_error <= '0' when s_ext = s_e_ext else '1';

      i_DUT: Adder
            generic map(N => Dimension)
            port map ( 
                  a => a_ext, 
                  s => s_ext
            );

      p_STIMULUS: process 
      begin 
		s_e_ext <= '0';
            wait for clk_period;

      -- Test various inputs
            a_ext <= "0000";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "0001";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "0010";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "0011";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "0100";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "0101";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "0110";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "0111";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "1000";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "1001";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "1010";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "1011";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "1100";
		s_e_ext <= '0';
		wait for clk_period;

		a_ext <= "1101";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "1110";
		s_e_ext <= '1';
		wait for clk_period;

		a_ext <= "1111";
		s_e_ext <= '0';
		wait for clk_period;

      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
      end process;
end architecture;