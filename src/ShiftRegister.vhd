library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
	generic (
            -- Length of the register
            --    Memory of the convolutional code
		Memory: positive := 11
	);
      port(
            -- CLock signal
            clk:	in	std_logic;
            
            -- Reset signal (note: active low)
            res:	in	std_logic;

            -- Enable signal
            --    If 1 the register content is shifted at rising edge
            --    If 0 it keeps the state of the previous clock cycle
            en:	in	std_logic;

            -- Data input
            i:	in    std_logic;

            -- Output
            --    Content of the register
            o:	out   std_logic_vector(Memory - 1 downto 0)
      );
end entity;

architecture beh of ShiftRegister is
      
      component FlipFlopD is
            port(
                  clk:	in	std_logic;
                  res:	in	std_logic;
                  en:	in	std_logic;
                  i:	in    std_logic;
                  o:	out   std_logic
            );
      end component;

      -- Internal connections between FFDs
      signal s:   std_logic_vector(Memory - 1 downto 0);

begin
      -- Note: the output lines are 'inverted' (FlipFlopD[0] outputs s(Memory - 1), all the way down to FlipFlopD[Memory - 1] outputting s(0))
      -- so that we are able to later specify the masks in the form "abc....z", where a masks the most recent bit and z masks the least recent saved bit.
      -- Note that another possibility is to use 'to' instead of 'downto'
      generate_DFF: for j in 0 to Memory - 1 generate

            -- First FFD has its input connected to the shift register input
            gen_first: if j = 0 generate
                  dff_first: FlipFlopD
                        port map(
                              clk => clk,
                              res => res,
                              en => en,
                              i => i,
                              o => s(Memory - 1)
                        );
            end generate;
            
            -- All other FFDs are linked in chain, using signal s
            gen_others: if j > 0 generate
                  dff_other: FlipFlopD
                        port map(
                              clk => clk,
                              res => res,
                              en => en,
                              i => s(Memory - j),
                              o => s(Memory - j - 1)
                        );
            end generate;

      end generate;

      -- Connect all FFDs outputs to the shift register output array
      o <= s;

end architecture;