library ieee;
use ieee.std_logic_1164.all;

-- Convolutional Coder wrapper
-- 1) Resolves all generic instances using the project specifications
-- 2) Puts register on output lines if not present

entity CC_Wrapper is
      port(
            -- Clock signal
            clk:	      in	std_logic;
            
            -- Reset signal (note: active low)
            res:	      in	std_logic;

            -- Flag to signal if data input ('a_k') is valid
            i_valid:	in	std_logic;

            -- Current input
            a_k_i:      in    std_logic;

            -- Current input, output line
            a_k_o:	out std_logic;

            -- Flag to signal if data output ('c') is valid
            o_valid:	out	std_logic;

            -- New code symbol generated
            c:	      out   std_logic
      );
end entity;

architecture beh of CC_Wrapper is

      -- Convolutional Code Memory dimensions, as per specifications
      constant InputMemory : positive := 4;
      constant CodewordMemory : positive := 10;

      -- Masks for the convolutional code, as per specifications
      constant CurrentInputMask : std_logic:= '1';
      constant InputMask : std_logic_vector(InputMemory - 1 downto 0) := "0011"; -- Only a(k-3) and a(k-4)
      constant CodewordMask : std_logic_vector(CodewordMemory - 1 downto 0) := "0000000101";  -- Only c(k-8) and c(k-10)

      component ConvolutionalCoder is
            port(
                  clk:	      in	std_logic;
                  res:	      in	std_logic;
                  i_valid:	in	std_logic;
                  a_k:	      inout std_logic;
                  c_mask:     in    std_logic;
                  i_mask:     in    std_logic_vector(InputMemory - 1 downto 0);
                  s_mask:     in    std_logic_vector(CodewordMemory - 1 downto 0);
                  o_valid:	out	std_logic;
                  c:	      out   std_logic
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

      signal a_k_sig: std_logic;

begin

      -- Link the in line of the current input to the internal signal
      a_k_sig <= a_k_i;

      -- ConvolutionalCoder component
      convCode: ConvolutionalCoder
            generic map(
                  InputMemory => InputMemory,
                  CodewordMemory => CodewordMemory
            )
            port map(
                  clk => clk,
                  res => res,
                  i_valid => i_valid,
                  a_k => a_k_sig,
                  c_mask => CurrentInputMask,
                  i_mask => InputMask,
                  s_mask => CodewordMask,
                  c => c
            );
      
      -- Output register for a_k (here called a_k_o)
      akRegister: FlipFlopD
            port map(
                  clk => clk,
                  res => res,
                  en => i_valid,
                  i => a_k_i,
                  o => a_k_o
            );


end architecture;