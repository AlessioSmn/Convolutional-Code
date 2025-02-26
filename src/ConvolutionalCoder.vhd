library ieee;
use ieee.std_logic_1164.all;

-- Main ConvolutionalCoder entity
entity ConvolutionalCoder is
      port(
            -- CLock signal
            clk:	      in	std_logic;
            
            -- Reset signal (note: active low)
            res:	      in	std_logic;

            -- Flag to signal if data input ('a_i') is valid
            i_valid:	in	std_logic;
            -- Data input
            a_i:	      in    std_logic;

            -- Flag to signal if data output ('a_o' and 'c') is valid
            o_valid:	out	std_logic;

            -- Current input
            a_o:	      out   std_logic;
            -- New code symbol generated
            c:	      out   std_logic
      );
end entity;

architecture beh of ConvolutionalCoder is

      -- Convolutional Code Memory dimensions, as per specs
      constant InputMemory : positive := 4;
      constant CodewordMemory : positive := 10;

      -- Masks for the convolutional code
      -- These are defined in order to match the specifications, the values can be changed to implement a different code
      constant CurrentInputMask : std_logic:= '1';
      constant InputMask : std_logic_vector(InputMemory - 1 downto 0) := "0011"; -- Only a(k-3) and a(k-4)
      constant CodewordMask : std_logic_vector(CodewordMemory - 1 downto 0) := "0000000101";  -- Only c(k-8) and c(k-10)

      component CodeGenerator is
            generic (
                  InputMemory: positive := 8;
                  CodewordMemory: positive := 8
            );
            port(
                  c:    in    std_logic;
                  c_m:  in    std_logic;
                  i:	in    std_logic_vector(InputMemory - 1 downto 0);
                  i_m:  in    std_logic_vector(InputMemory - 1 downto 0);
                  s:	in    std_logic_vector(CodewordMemory - 1 downto 0);
                  s_m:  in    std_logic_vector(CodewordMemory - 1 downto 0);
                  o:	out   std_logic
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

      component FlipFlopD is
            port(
                  clk:	in	std_logic;
                  res:	in	std_logic;
                  en:	in	std_logic;
                  i:	in    std_logic;
                  o:	out   std_logic
            );
      end component;

      -- Signal from the Input shift register to the CodeGenerator
      signal input_sig: std_logic_vector(InputMemory - 1 downto 0);

      -- Signal from the Codeword shift register to the CodeGenerator
      signal codeword_sig: std_logic_vector(CodewordMemory - 1 downto 0);

      -- Signal from CodeGenerator to the output register
      signal new_codeword: std_logic;

      -- Signal from output register to Codeword shift register
      signal cur_codeword: std_logic;

begin

      -- Shift register component
      -- To store and access past inputs
      ShiftRegInput: ShiftRegister
            generic map(
                  Memory => InputMemory
            )
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => a_i,
                  o => input_sig
            );

      -- Shift register component
      -- To store and access past codewords
      ShiftRegCodeword: ShiftRegister
            generic map(
                  Memory => CodewordMemory
            )
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => cur_codeword,
                  o => codeword_sig
            );
            
      -- CodeGenerator component
      -- To generate the code words, according to current and past inputs and codedwords, and according to the masks defined
      codeGen: CodeGenerator
            generic map(
                  InputMemory => InputMemory,
                  CodewordMemory => CodewordMemory
            )
            port map(
                  c => a_i,
                  c_m => CurrentInputMask,
                  i => input_sig,
                  i_m => InputMask,
                  s => codeword_sig,
                  s_m => CodewordMask,
                  o => new_codeword
            );

      -- Final register for the generated code
      CurrentCodewordFFD: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => new_codeword,
                  o => cur_codeword
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

      -- Final register for the validity of the outputs
      ValidFFD: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => '1',
                  i => i_valid,
                  o => o_valid
            );

      c <= cur_codeword;
end architecture;