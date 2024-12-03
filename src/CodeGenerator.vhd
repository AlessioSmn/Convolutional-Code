library ieee;
use ieee.std_logic_1164.all;

entity CodeGenerator is
      generic (
            -- Input memory of the convolutional code
            InputMemory: positive := 8;

            -- State memory of the convolutional code
            StateMemory: positive := 8
      );
      port(
            -- Current input
            c:    in    std_logic;
            -- Mask to select if to consider the current input to determine the current state
            c_m:  in    std_logic;

            -- Past inputs array
            i:	in    std_logic_vector(InputMemory - 1 downto 0);
            -- Mask to select which inputs to consider to determine the current state
            i_m:  in    std_logic_vector(InputMemory - 1 downto 0);

            -- Past states array
            s:	in    std_logic_vector(StateMemory - 1 downto 0);
            -- Mask to select which states to consider to determine the current state
            s_m:  in    std_logic_vector(StateMemory - 1 downto 0);

            -- Code output
            o:	out    std_logic
      );
end entity;

architecture beh of CodeGenerator is

      -- Derived dimensions
      constant TotalInputMemory : positive := InputMemory + 1;
      constant AdderDimension : positive := TotalInputMemory + StateMemory;

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

      -- Signal composed by c and i
      signal inputs: std_logic_vector(TotalInputMemory - 1 downto 0);

      -- Signal composed by c_m and i_m
      signal input_mask: std_logic_vector(TotalInputMemory - 1 downto 0);

      -- Signal from the input mask to the adder
      -- signal input_masked_sig: std_logic_vector(TotalInputMemory - 1 downto 0);

      -- Signal from the state mask to the adder
      -- signal state_masked_sig: std_logic_vector(StateMemory - 1 downto 0);

      -- Signal from the masks to the adder
      signal masked_sig: std_logic_vector(AdderDimension - 1 downto 0);


begin

      inputs(0) <= c;
      inputs(TotalInputMemory - 1 downto 1) <= i;
      
      input_mask(0) <= c_m;
      input_mask(TotalInputMemory - 1 downto 1) <= i_m;

      -- Input mask, also includes the current input
      MaskInput: Mask
            generic map(N => TotalInputMemory)
            port map(
                  i => inputs,
                  mask => input_mask,
                  o => masked_sig(TotalInputMemory - 1 downto 0)
            );

      -- State mask
      MaskState: Mask
            generic map(N => StateMemory)
            port map(
                  i => s,
                  mask => s_m,
                  o => masked_sig(AdderDimension - 1 downto TotalInputMemory)
            );

      -- Code egenrator
      CodeAdder: Adder
            generic map(N => AdderDimension)
            port map(
                  a => masked_sig,
                  s => o
            );


end architecture;