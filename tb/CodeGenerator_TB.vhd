library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity CodeGenerator_TestBench is 
end entity;

architecture beh of CodeGenerator_TestBench is 
      -- Clock frequency of 125MHz
      constant clk_period : time := 8 ns;
      constant InputMemory : positive := 4; 
      constant StateMemory : positive := 4;

      component CodeGenerator is
            generic (
                  -- Input memory of the convolutional code
                  InputMemory: positive := 8;
                  -- State memory of the convolutional code
                  StateMemory: positive := 8
            );
            port(
                  -- Current input
                  c:    in    std_logic;
                  -- Past inputs array
                  i:	in    std_logic_vector(InputMemory - 1 downto 0);
                  -- Programming array to select which inputs to consider to determine the current state
                  i_en: in    std_logic_vector(InputMemory - 1 downto 0);
                  -- Past states array
                  s:	in    std_logic_vector(StateMemory - 1 downto 0);
                  -- Programming array to select which states to consider to determine the current state
                  s_en: in    std_logic_vector(StateMemory - 1 downto 0);
                  -- Code output
                  o:	out    std_logic
            );
      end component;

      signal clk_ext :  std_logic := '0';
      signal i_c_ext:     std_logic := '0';
      signal i_ext:     std_logic_vector(InputMemory - 1downto 0) := "00000";
      signal i_mask:    std_logic_vector(InputMemory - 1 downto 0) := "0000";
      signal s_ext:     std_logic_vector(StateMemory - 1 downto 0) := "0000";
      signal s_mask:    std_logic_vector(StateMemory - 1 downto 0) := "0000";
      signal out_expected :  std_logic;
      signal out_error :  std_logic;
      signal out_s :  std_logic;
      signal testing :  boolean := true;
      
begin 
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';

      out_error <= '0' when out_expected = out_s else '1';

      i_DUT: CodeGenerator
            generic map(
                  InputMemory => InputMemory,
                  StateMemory => StateMemory
            )
            port map ( 
                  c => i_c_ext, 
                  i => i_ext,
                  i_en => i_mask,
                  s => s_ext, 
                  s_en => s_mask, 
                  o => out_s
            );

      p_STIMULUS: process 
      begin 

      -- All inputs masked out
            -- masks set to 0 by default
            out_expected <= '0'; 
            i_ext <= "1111";
            s_ext <= "1111";
            wait for 2 ns;
            i_ext <= "0101";
            s_ext <= "1001";
            wait for 2 ns;
            i_ext <= "0000";
            s_ext <= "0000";
            wait for 2 ns;
            
      -- Out = current input

            -- Toggle the current input i_c_ext
            i_c_ext <= '0';
            out_expected <= '0'; 
            wait for 2 ns;
            i_c_ext <= '1';
            out_expected <= '1'; 
            wait for 2 ns;
            i_c_ext <= '0';
            out_expected <= '0'; 
            wait for 2 ns;

      -- Out = function of all past and current inputs
            -- Unmask all the inputs
            i_mask <= "1111";

            -- Toggle the inputs array
            i_c_ext <= '1';
            i_ext <= "1111";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_c_ext <= '0';
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "1110";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "0001";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '0';
            i_ext <= "0000";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '0';
            i_ext <= "0111";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;

            -- Toggle the state too, they shouldn't affect the output
            i_ext <= "00000";
            s_ext <= "1000";
            wait for 2 ns;
            s_ext <= "0010";
            wait for 2 ns;

      -- Out = function of part of past and current inputs            
            -- Set all inputs to 1
            i_ext <= "1111";
            i_c_ext <= '1';

            -- Toggle the mask
            i_mask <= "1111";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_mask <= "1110";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_mask <= "1101";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_mask <= "0011";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_mask <= "0001";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;

            -- Toggle the state too, they shouldn't affect the output
            s_ext <= "1000";
            wait for 2 ns;
            s_ext <= "0010";
            wait for 2 ns;

      -- Out = function of all past and current inputs
            -- Mask all the inputs
            i_mask <= "0000";
            -- Set current input to zero
            i_c_ext <= '0';
            -- Unmask all the states
            s_mask <= "1111";

            -- Toggle the inputs array
            s_ext <= "1111";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_ext <= "1110";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            s_ext <= "1011";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            s_ext <= "1001";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_ext <= "0000";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_ext <= "1000";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            s_ext <= "0010";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;

            -- Toggle the inputs too, they shouldn't affect the output
            i_ext <= "1000";
            wait for 2 ns;
            i_ext <= "0100";
            wait for 2 ns;

      -- Out = function of part of states            
            -- Set all states to 1
            s_ext <= "1111";

            -- Toggle the mask
            s_mask <= "1111";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_mask <= "1110";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            s_mask <= "0000";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_mask <= "1011";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            s_mask <= "1100";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            s_mask <= "0111";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;

            -- Toggle the inputs too, they shouldn't affect the output
            i_ext <= "1000";
            wait for 2 ns;
            i_ext <= "0010";
            wait for 2 ns;

      -- Out = function of inputs and states          
            -- Set a random mask
            --    in this case O = i(current) + i(-4) + s(-3) + s(-4)
            i_mask <= "0001";
            s_mask <= "0011";

            -- Toggle the state and inputs
            i_c_ext <= '0';
            i_ext <= "0000";
            s_ext <= "0000";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "0000";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1000";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1100";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1110";
            out_expected <= '0'; -- expected 0
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '1'; -- expected 1
            wait for 2 ns;
            i_c_ext <= '0';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '0';
            wait for 2 ns;
            i_c_ext <= '1';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '1';
            wait for 2 ns;

      -- End Test
            testing <= false; 
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;