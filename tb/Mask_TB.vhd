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

      signal clk_ext :  std_logic := '0';
      signal i_ext :    std_logic_vector(Dimension - 1 downto 0) := (others => '0');
      signal m_ext :    std_logic_vector(Dimension - 1 downto 0) := (others => '0');
      signal s_ext :    std_logic_vector(Dimension - 1 downto 0);
      signal testing :  boolean := true;
begin

      clk_ext <= not clk_ext after clk_period/2 when testing else '0';

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
            -- Set the mask to 1
            m_ext <= "1111";

            -- Toggle the inputs
            i_ext <= "0000"; -- expected 0
            wait for clk_period;

            i_ext <= "0111"; -- expected 1
            wait for clk_period;

            i_ext <= "1111"; -- expected 0
            wait for clk_period;

            i_ext <= "1010"; -- expected 0
            wait for clk_period;

            i_ext <= "1000"; -- expected 1
            wait for clk_period;

      -- Test various input with a random mask
            -- Set the mask
            m_ext <= "1001";

            -- Toggle the inputs
            i_ext <= "0000"; -- expected 0
            wait for clk_period;

            i_ext <= "0111"; -- expected 1
            wait for clk_period;

            i_ext <= "1111"; -- expected 0
            wait for clk_period;

            i_ext <= "1010"; -- expected 1
            wait for clk_period;

            i_ext <= "1000"; -- expected 1
            wait for clk_period;

      -- Test various input with another random mask
            -- Set the mask
            m_ext <= "1101";

            -- Toggle the inputs
            i_ext <= "0000"; -- expected 0
            wait for clk_period;

            i_ext <= "0111"; -- expected 0
            wait for clk_period;

            i_ext <= "1111"; -- expected 1
            wait for clk_period;

            i_ext <= "1010"; -- expected 1
            wait for clk_period;

            i_ext <= "1000"; -- expected 1
            wait for clk_period;

      -- Test various input with null mask
            -- Set the mask
            m_ext <= "0000";

            -- Toggle the inputs
            i_ext <= "0000"; -- expected 0
            wait for clk_period;

            i_ext <= "0111"; -- expected 0
            wait for clk_period;

            i_ext <= "1111"; -- expected 0
            wait for clk_period;

            i_ext <= "1010"; -- expected 0
            wait for clk_period;

            i_ext <= "1000"; -- expected 0
            wait for clk_period;

      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
      end process;
end architecture;