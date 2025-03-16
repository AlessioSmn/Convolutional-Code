library ieee;
use ieee.std_logic_1164.all;

-- Convolutional Coder wrapper
--    Resolves all generic instances using the project specifications

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
            a_k_o:	out   std_logic;

            -- Flag to signal if data output ('c') is valid
            o_valid:	out	std_logic;

            -- New code symbol generated
            c:	      out   std_logic
      );
end entity;

architecture beh of CC_Wrapper is

      -- Convolutional Code Memory dimensions, as per specifications
      constant InputMemory :        positive := 4;
      constant CodewordMemory :     positive := 10;

      -- Masks for the convolutional code, as per specifications
      constant CurrentInputMask : std_logic := '1';
      constant InputMask : std_logic_vector(InputMemory - 1 downto 0) := "0011"; -- Only a(k-3) and a(k-4)
      constant CodewordMask : std_logic_vector(CodewordMemory - 1 downto 0) := "0000000101";  -- Only c(k-8) and c(k-10)

      component ConvolutionalCoder is
            generic (
                  InputMemory: positive := 8;
                  CodewordMemory: positive := 8
            );
            port(
                  clk:	      in	std_logic;
                  res:	      in	std_logic;
                  i_valid:	in	std_logic;
                  a_k_i:	in    std_logic;
                  c_mask:     in    std_logic;
                  i_mask:     in    std_logic_vector(InputMemory - 1 downto 0);
                  s_mask:     in    std_logic_vector(CodewordMemory - 1 downto 0);
                  o_valid:	out	std_logic;
                  a_k_o:	out	std_logic;
                  c:	      out   std_logic
            );
      end component;

begin

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
                  a_k_i => a_k_i,
                  c_mask => CurrentInputMask,
                  i_mask => InputMask,
                  s_mask => CodewordMask,
                  o_valid => o_valid,
                  a_k_o => a_k_o,
                  c => c
            );

end architecture;