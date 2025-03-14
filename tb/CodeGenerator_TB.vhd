library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
entity CodeGenerator_TestBench is 
end entity;

architecture beh of CodeGenerator_TestBench is 
      constant clk_period : time := 8 ns;
      constant InputMemory : positive := 4; 
      constant CodewordMemory : positive := 4;

      component CodeGenerator is
            generic (
                  -- Input memory of the convolutional code
                  InputMemory: positive := 8;
                  -- Codeword memory of the convolutional code
                  CodewordMemory: positive := 8
            );
            port(
                  -- Current input
                  c:    in    std_logic;
                  -- Mask to select if to consider the current input to determine the next codeword
                  c_m:  in    std_logic;
                  -- Past inputs array
                  i:	in    std_logic_vector(InputMemory - 1 downto 0);
                  -- Programming array to select which inputs to consider to determine the next codeword
                  i_m: in    std_logic_vector(InputMemory - 1 downto 0);
                  -- Past codewords array
                  s:	in    std_logic_vector(CodewordMemory - 1 downto 0);
                  -- Programming array to select which codewords to consider to determine the next codeword
                  s_m: in    std_logic_vector(CodewordMemory - 1 downto 0);
                  -- Code output
                  o:	out    std_logic
            );
      end component;

      -- clock signal
      signal clk_ext :  std_logic := '0';

      -- current input signal
      signal c_ext:           std_logic := '0';

      -- current input mask signal
      signal c_mask:          std_logic := '0';

      -- past input array signal
      signal i_ext:           std_logic_vector(InputMemory - 1 downto 0) := "0000";

      -- past input array mask signal
      signal i_mask:          std_logic_vector(InputMemory - 1 downto 0) := "0000";

      -- past codewords array signal
      signal s_ext:           std_logic_vector(CodewordMemory - 1 downto 0) := "0000";

      -- past codewords array mask signal
      signal s_mask:          std_logic_vector(CodewordMemory - 1 downto 0) := "0000";

      -- out signal
      signal out_s :          std_logic;

      -- expected output signal
      signal out_expected :   std_logic;

      -- error flag
      signal out_error :      std_logic;

      -- testing flag
      signal testing :        boolean := true;
      
begin  
      clk_ext <= not clk_ext after clk_period/2 when testing else '0';
      out_error <= '0' when out_expected = out_s else '1';

      i_DUT: CodeGenerator
            generic map(
                  InputMemory => InputMemory,
                  CodewordMemory => CodewordMemory
            )
            port map ( 
                  c => c_ext, 
                  c_m => c_mask,
                  i => i_ext,
                  i_m => i_mask,
                  s => s_ext, 
                  s_m => s_mask, 
                  o => out_s
            );

      p_STIMULUS: process 
      begin 

      -- Test 1) All inputs masked out
            -- masks set to 0
            c_mask <= '0';
            i_mask <= "0000";
            s_mask <= "0000";
            -- toggle all input, output should stay fixed to 0
            out_expected <= '0'; 
            c_ext <= '1';
            i_ext <= "1111";
            s_ext <= "1111";
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0101";
            s_ext <= "1001";
            wait for 2 ns;
            c_ext <= '0';
            i_ext <= "0000";
            s_ext <= "0000";
            wait for 10 ns;

            
      -- Test 2) Only the current input is not masked out
            c_mask <= '1';
            i_mask <= "0000";
            s_mask <= "0000";
            -- Toggle the current input c_ext
            c_ext <= '0';
            out_expected <= '0'; 
            wait for 2 ns;
            c_ext <= '1';
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '0';
            out_expected <= '0'; 
            wait for 2 ns;
            c_ext <= '1';
            out_expected <= '1'; 
            wait for 10 ns;


      -- Test 3) Output is function of ALL past and current inputs
            -- Unmask all the inputs (current and past)
            c_mask <= '1';
            i_mask <= "1111";
            s_mask <= "0000";

            -- Toggle the inputs array
            c_ext <= '1';
            i_ext <= "1111";
            out_expected <= '1';
            wait for 2 ns;
            c_ext <= '0';
            i_ext <= "1111";
            out_expected <= '0';
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "1110";
            out_expected <= '0';
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0001";
            out_expected <= '0';
            wait for 2 ns;
            c_ext <= '0';
            i_ext <= "0000";
            out_expected <= '0';
            wait for 2 ns;
            c_ext <= '0';
            i_ext <= "0111";
            out_expected <= '1';
            wait for 2 ns;

            -- Toggle the codewords too, they shouldn't affect the output
            c_ext <= '0';
            i_ext <= "0000";
            out_expected <= '0';
            s_ext <= "1000";
            wait for 2 ns;
            s_ext <= "0010";
            wait for 2 ns;
            s_ext <= "1110";
            wait for 10 ns;


      -- Test 4) Output is function of a SUBSET of past and current inputs, 
      -- realized by changing the inputs masks
            -- Set all inputs to 1
            i_ext <= "1111";
            c_ext <= '1';

            -- Toggle the masks
            i_mask <= "1111";
            out_expected <= '1'; 
            wait for 2 ns;
            i_mask <= "1110";
            out_expected <= '0'; 
            wait for 2 ns;
            i_mask <= "1101";
            out_expected <= '0'; 
            wait for 2 ns;
            i_mask <= "0011";
            out_expected <= '1'; 
            wait for 2 ns;
            i_mask <= "0001";
            out_expected <= '0'; 
            wait for 2 ns;

            -- Toggle the codewords too, they shouldn't affect the output
            s_ext <= "1000";
            wait for 2 ns;
            s_ext <= "0010";
            wait for 10 ns;


      -- Test 5) Output is function of ALL of codewords
            -- Mask all the inputs
            c_mask <= '0';
            i_mask <= "0000";
            -- Unmask all the codewords
            s_mask <= "1111";

            -- Toggle the codewords array
            s_ext <= "1111";
            out_expected <= '0'; 
            wait for 2 ns;
            s_ext <= "1110";
            out_expected <= '1'; 
            wait for 2 ns;
            s_ext <= "1011";
            out_expected <= '1'; 
            wait for 2 ns;
            s_ext <= "1001";
            out_expected <= '0'; 
            wait for 2 ns;
            s_ext <= "0000";
            out_expected <= '0'; 
            wait for 2 ns;
            s_ext <= "1000";
            out_expected <= '1'; 
            wait for 2 ns;
            s_ext <= "0010";
            out_expected <= '1';
            wait for 2 ns;

            -- Toggle the inputs too, they shouldn't affect the output
            i_ext <= "1000";
            wait for 2 ns;
            i_ext <= "0100";
            wait for 2 ns;
            i_ext <= "1111";
            wait for 10 ns;


      -- Test 6) Output is function of SUBSET of codewords
            c_mask <= '0';
            i_mask <= "0000";
            -- Set all codewords to 1
            s_ext <= "1111";

            -- Toggle the mask
            s_mask <= "1111";
            out_expected <= '0';
            wait for 2 ns;
            s_mask <= "1110";
            out_expected <= '1';
            wait for 2 ns;
            s_mask <= "0000";
            out_expected <= '0';
            wait for 2 ns;
            s_mask <= "1011";
            out_expected <= '1';
            wait for 2 ns;
            s_mask <= "1100";
            out_expected <= '0';
            wait for 2 ns;
            s_mask <= "0111";
            out_expected <= '1';
            wait for 2 ns;

            -- Toggle the inputs too, they shouldn't affect the output
            i_ext <= "1000";
            wait for 2 ns;
            i_ext <= "0010";
            wait for 2 ns;
            i_ext <= "1111";
            wait for 10 ns;


      -- Test 7) Output is generic function of all inputs          
            -- Set a random mask
            --    in this case O = i(current) + i(-4) + s(-3) + s(-4)
            c_mask <= '1';
            i_mask <= "0001";
            s_mask <= "0011";

            -- Toggle the codewords and inputs
            c_ext <= '0';
            i_ext <= "0000";
            s_ext <= "0000";
            out_expected <= '0'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "0000";
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1000";
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1100";
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1110";
            out_expected <= '0'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "0000";
            s_ext <= "1111";
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '1'; 
            wait for 2 ns;
            c_ext <= '0';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '0';
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "1011";
            s_ext <= "1110";
            out_expected <= '1';
            wait for 2 ns;
            c_ext <= '1';
            i_ext <= "1111";
            s_ext <= "1111";
            out_expected <= '0';
            wait for 10 ns;


      -- End Test
            testing <= false;
            wait until rising_edge(clk_ext);
            
      end process; 
end architecture;