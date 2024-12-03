library ieee;
use ieee.std_logic_1164.all;

entity ConvolutionalCoder is
      port(
            -- CLock signal
            clk:	      in	std_logic;
            
            -- Reset signal (note: active low)
            res:	      in	std_logic;

            -- Flag to signal if data input is valid
            i_valid:	in	std_logic;
            -- Data input
            a_i:	      in    std_logic;

            -- Flag to signal if data output is valid
            o_valid:	out	std_logic;
            -- Data output
            a_o:	      out   std_logic;
            c:	      out   std_logic
      );
end entity;

architecture beh of ConvolutionalCoder is
      -- Convolutional Code Memory dimensions
      constant InputMemory : positive := 4;
      constant StateMemory : positive := 10;

      -- Derived dimensions
      constant TotalInputMemory : positive := InputMemory + 1;
      constant AdderDimension : positive := TotalInputMemory + StateMemory - 1;

      -- Masks for the convolutional code
      constant CurrentInputMask : std_logic:= '1';
      constant PastInputsMask : std_logic_vector(InputMemory - 1 downto 0) := "0011";
      constant InputMask : std_logic_vector(InputMemory downto 0) := CurrentInputMask & PastInputsMask;
      constant StateMask : std_logic_vector(StateMemory - 1 downto 0) := "0000000101";

      component CodeGenerator is
            generic (
                  InputMemory: positive := 8;
                  StateMemory: positive := 8
            );
            port(
                  c:    in    std_logic;
                  i:	in    std_logic_vector(InputMemory - 1 downto 0);
                  i_en: in    std_logic_vector(InputMemory - 1 downto 0);
                  s:	in    std_logic_vector(StateMemory - 1 downto 0);
                  s_en: in    std_logic_vector(StateMemory - 1 downto 0);
                  o:	out    std_logic
            );
      end component;

      component ShiftRegister is
            generic (
                  Memory: positive := 11
            );
            port(
                  clk:	in	std_logic;
                  res:	in	std_logic;
                  en:	in	std_logic;
                  i:	in    std_logic;
                  o:	out   std_logic_vector(Memory - 1 downto 0)
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

      component FlipFlopD is
            port(
                  clk:	in	std_logic;
                  res:	in	std_logic;
                  en:	in	std_logic;
                  i:	in    std_logic;
                  o:	out   std_logic
            );
      end component;

      -- Signal from the current input and Input shift register to the input mask
      signal input_sig: std_logic_vector(InputMemory downto 0);

      -- Signal from the input mask to the adder
      signal input_masked_sig: std_logic_vector(InputMemory downto 0);

      -- Signal from the State shift register to the state mask
      signal state_sig: std_logic_vector(StateMemory - 1 downto 0);

      -- Signal from the state mask to the adder
      signal state_masked_sig: std_logic_vector(StateMemory - 1 downto 0);

      -- Signal from the masks to the adder
      signal masked_sig: std_logic_vector(AdderDimension downto 0);

      -- Signal from adder to output register
      signal new_state: std_logic;

      -- Signal from output register to states shift register
      signal cur_state: std_logic;

begin

      -- Shift register for the inputs
      ShiftRegInput: ShiftRegister
            generic map(
                  Memory => InputMemory
            )
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => a_i,
                  o => input_sig(InputMemory - 1 downto 0)
            );

      input_sig(InputMemory) <= a_i;

      -- Shift register for the past states
      ShiftRegState: ShiftRegister
            generic map(
                  Memory => StateMemory
            )
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => cur_state,
                  o => state_sig
            );
      
      -- Input mask, also includes the current input
      MaskInput: Mask
            generic map(N => TotalInputMemory)
            port map(
                  i => input_sig,
                  mask => InputMask,
                  o => input_masked_sig
            );

      -- State mask
      MaskState: Mask
            generic map(N => StateMemory)
            port map(
                  i => state_sig,
                  mask => StateMask,
                  o => state_masked_sig
            );

      masked_sig <= input_masked_sig & state_masked_sig;

      -- New state generator
      CodeAdder: Adder
            generic map(N => AdderDimension)
            port map(
                  a => masked_sig,
                  s => new_state
            );

      -- Final register for the generated code
      CurrentStateFFD: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => new_state,
                  o => cur_state
            );

      -- Final register for the current input
      CurrentInputFFD: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => a_i,
                  o => a_o
            );

      ValidFFD: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => '1',
                  i => i_valid,
                  o => o_valid
            );

      c <= cur_state;
end architecture;