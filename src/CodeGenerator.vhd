library ieee;
use ieee.std_logic_1164.all;

-- Generates convolutional code symbols.
--    It processes the current input, past inputs and past codewords
--    It applies masks to determine which values contribute to the next codeword
entity CodeGenerator is
      generic (
            -- Input memory of the convolutional code (without considering the current input)
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
            -- Mask to select which inputs to consider to determine the next codeword
            i_m:  in    std_logic_vector(InputMemory - 1 downto 0);

            -- Past codewords array
            s:	in    std_logic_vector(CodewordMemory - 1 downto 0);
            -- Mask to select which codewords to consider to determine the next codeword
            s_m:  in    std_logic_vector(CodewordMemory - 1 downto 0);

            -- Code output
            o:	out    std_logic
      );
end entity;

architecture beh of CodeGenerator is

      -- Derived dimensions
      constant TotalInputMemory : positive := InputMemory + 1;
      constant AdderDimension : positive := TotalInputMemory + CodewordMemory;

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
      
      component Adder is
            generic (
                  N: positive := 8
            );
            port(
                  a:    in    std_logic_vector(N-1 downto 0);
                  s:    out   std_logic
            );
      end component;

      -- Concatenated signal containing the current input ('c') and past inputs ('i')
      signal inputs: std_logic_vector(TotalInputMemory - 1 downto 0);

      -- Concatenated signal containing the mask for the current input ('c_m') and past input masks ('i_m')
      signal input_mask: std_logic_vector(TotalInputMemory - 1 downto 0);

      -- Masked signal to be processed by the adder, containing both the inputs signals 'inputs' and codewords signals 's'
      signal masked_sig: std_logic_vector(AdderDimension - 1 downto 0);


begin

      -- Construct 'inputs' array as previously described
      inputs(0) <= c;
      inputs(TotalInputMemory - 1 downto 1) <= i;
      
      -- Construct 'inputs_mask' array as previously described
      input_mask(0) <= c_m;
      input_mask(TotalInputMemory - 1 downto 1) <= i_m;

      -- Mask component, in order to mask the 'inputs' array
      MaskInput: Mask
            generic map(N => TotalInputMemory)
            port map(
                  i => inputs,
                  mask => input_mask,
                  o => masked_sig(TotalInputMemory - 1 downto 0)
            );

      -- Mask component, in order to mask the codeword array ('s')
      MaskCodeword: Mask
            generic map(N => CodewordMemory)
            port map(
                  i => s,
                  mask => s_m,
                  o => masked_sig(AdderDimension - 1 downto TotalInputMemory)
            );

      -- Generation of the new code symbol
      -- It computes the XOR of all bits in the 'masked_sig' array
      -- The ouput of the Adder component is used as the output of the CodeGenerator entity
      CodeAdder: Adder
            generic map(N => AdderDimension)
            port map(
                  a => masked_sig,
                  s => o
            );

end architecture;