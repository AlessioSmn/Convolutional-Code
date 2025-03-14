library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity ShiftRegister_TestBench is 
end entity;

architecture beh of ShiftRegister_TestBench is 
      -- Clock frequency of 125MHz
      constant clk_period : time := 8 ns;
      constant Dimension : positive := 9; -- easy to visualize in octal

      component ShiftRegister is
            generic (
                  -- Length of the register
                  Memory: positive := 11
            );
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
                  o:	out   std_logic_vector(Memory - 1 downto 0)
            );
      end component;

      signal clk_ext :  std_logic := '0';
      signal res_ext :  std_logic := '1';
      signal en_ext :   std_logic := '0'; 
      signal in_ext :   std_logic := '0';
      signal out_ext :  std_logic_vector(Dimension - 1 downto 0);
      signal testing :  boolean := true;
      
begin 
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';

      i_DUT: ShiftRegister
            generic map(Memory => Dimension)
            port map ( 
                  clk => clk_ext, 
                  res => res_ext,
                  en => en_ext, 
                  i => in_ext, 
                  o => out_ext
            );

      p_STIMULUS: process 
      begin 

      -- Firstly set the register in an initial state
            wait for clk_period;
            res_ext <= '0';
            wait for clk_period;
            res_ext <= '1';
            
      -- Test when enabled

            -- Enable the register
            en_ext <= '1';

            -- Wait until falling edge
            wait until rising_edge(clk_ext);
            wait for clk_period/2;

            -- Set input: "111000111"
            in_ext <= '1'; 
            wait for clk_period*3;
            in_ext <= '0'; 
            wait for clk_period*3;
            in_ext <= '1'; 
            wait for clk_period*3;

            -- Keep '0' at the input with register enabled
            in_ext <= '0'; 
            wait for clk_period*Dimension;

            -- Keep '1' at the input with register enabled
            in_ext <= '1'; 
            wait for clk_period*Dimension;
            
      -- Test when not enabled

            -- Insert a '0' to keep track of the state
            in_ext <= '0'; 
            wait for clk_period;
            in_ext <= '1'; 
            wait for clk_period*Dimension/2;

            -- Deactivate the enable signal
            en_ext <= '0';

            -- Wait for some clock cycles while setting the input to 1
            in_ext <= '0'; 
            wait for clk_period*Dimension;

      -- Test reset

            -- Activate the reset signal
            res_ext <= '0';

            -- Wait for at least one clock cycle, also under varying in_ext
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