library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity Mask_TestBench is 
end entity;

architecture beh of Mask_TestBench is 
      constant clk_period : time := 8 ns;
      constant Dimension : positive := 4;  

      component Mask is
            generic (
                  N: positive := 8
            );
            port(
                  i:    in    std_logic_vector(N-1 downto 0);
                  mask: in    std_logic_vector(N-1 downto 0);
                  o:    out   std_logic_vector(N-1 downto 0)
            );
      end component;

      -- clock signal
      signal clk_ext :  std_logic := '0';

      -- input signal
      signal i_ext :    std_logic_vector(Dimension - 1 downto 0) := (others => '0');

      -- mask signal
      signal m_ext :    std_logic_vector(Dimension - 1 downto 0) := (others => '0');

      -- produced output signal
      signal s_ext :    std_logic_vector(Dimension - 1 downto 0);

      -- expected output signal
      signal s_e_ext :  std_logic_vector(Dimension - 1 downto 0);

      -- error flag
      signal out_error: std_logic; 

      -- testing flag
      signal testing :  boolean := true;
begin

      clk_ext <= not clk_ext after clk_period/2 when testing else '0';
      out_error <= '0' when s_ext = s_e_ext else '1';

      i_DUT: Mask
            generic map(N => Dimension)
            port map ( 
                  i => i_ext, 
                  mask => m_ext, 
                  o => s_ext
            );

      p_STIMULUS: process 
      begin 
            wait for clk_period;

      -- Test various input with complete mask

		-- new mask: 0000
		m_ext <= "0000";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "0000";
		wait for clk_period;
		wait for clk_period*4;

		-- new mask: 0001
		m_ext <= "0001";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "0001";
		wait for clk_period;
		wait for clk_period*4;

		-- new mask: 0101
		m_ext <= "0101";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "0101";
		wait for clk_period;
		wait for clk_period*4;

		-- new mask: 0111
		m_ext <= "0111";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0011";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0110";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0111";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "0011";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "0110";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "0111";
		wait for clk_period;
		wait for clk_period*4;

		-- new mask: 1010
		m_ext <= "1010";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "1000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "1000";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "1010";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "1010";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "1000";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "1000";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "1010";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "1010";
		wait for clk_period;
		wait for clk_period*4;

		-- new mask: 1111
		m_ext <= "1111";
		i_ext <= "0000";
		s_e_ext <= "0000";
		wait for clk_period;
		i_ext <= "0001";
		s_e_ext <= "0001";
		wait for clk_period;
		i_ext <= "0010";
		s_e_ext <= "0010";
		wait for clk_period;
		i_ext <= "0011";
		s_e_ext <= "0011";
		wait for clk_period;
		i_ext <= "0100";
		s_e_ext <= "0100";
		wait for clk_period;
		i_ext <= "0101";
		s_e_ext <= "0101";
		wait for clk_period;
		i_ext <= "0110";
		s_e_ext <= "0110";
		wait for clk_period;
		i_ext <= "0111";
		s_e_ext <= "0111";
		wait for clk_period;
		i_ext <= "1000";
		s_e_ext <= "1000";
		wait for clk_period;
		i_ext <= "1001";
		s_e_ext <= "1001";
		wait for clk_period;
		i_ext <= "1010";
		s_e_ext <= "1010";
		wait for clk_period;
		i_ext <= "1011";
		s_e_ext <= "1011";
		wait for clk_period;
		i_ext <= "1100";
		s_e_ext <= "1100";
		wait for clk_period;
		i_ext <= "1101";
		s_e_ext <= "1101";
		wait for clk_period;
		i_ext <= "1110";
		s_e_ext <= "1110";
		wait for clk_period;
		i_ext <= "1111";
		s_e_ext <= "1111";
		wait for clk_period;



      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
      end process;
end architecture;