library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity FlipFlopD_TestBench is 
end entity;

architecture beh of FlipFlopD_TestBench is 
      -- Clock frequency of 125MHz
      constant clk_period : time := 8 ns; 

      component FlipFlopD is
            port(
                  -- CLock signal
                  clk:	in	std_logic;
                  -- Reset signal (note: active low)
                  res:	in	std_logic;
                  -- Enable signal
                  en:	in	std_logic;
                  -- Data input
                  i:	in    std_logic;
                  -- Output
                  o:	out   std_logic
            );
      end component;

      signal clk_ext :  std_logic := '0';
      signal res_ext :  std_logic := '1';
      signal en_ext :   std_logic := '0'; 
      signal in_ext :   std_logic := '0';
      signal out_ext :  std_logic;
      signal testing :  boolean := true;
      
begin 
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';

      i_DUT: FlipFlopD
            port map ( 
                  clk => clk_ext, 
                  res => res_ext,
                  en => en_ext, 
                  i => in_ext, 
                  o => out_ext
            );

      p_STIMULUS: process 
      begin 
      -- Firstly set the DFF in an initial state
            wait for 20 ns;
            res_ext <= '0';
            wait for 4 ns;
            res_ext <= '1';
            
      -- Test when enabled

            -- Enable the DFF
            en_ext <= '1';

            -- Wait until falling edge
            wait until rising_edge(clk_ext);
            wait for clk_period/2;

            -- Toggle the input
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for 30 ns;
            
      -- Test when not enabled

            -- Deactivate the enable signal
            en_ext <= '0';

            -- Toggle the input some times
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 

      -- Test reset

            -- Activate the reset signal
            res_ext <= '0';

            -- Wait for at least one clock cycle, also under varying in_ext
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period;
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period;

            -- Deactivate the reset signal
            res_ext <= '1';

      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;