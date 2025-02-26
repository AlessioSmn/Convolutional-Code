library ieee;
use ieee.std_logic_1164.all;

entity FlipFlopD is
      port(
            -- CLock signal
            clk:	in	std_logic;
            
            -- Reset signal (note: active low)
            res:	in	std_logic;

            -- Enable signal
            --    If 1 the entity functions as a normal D FlipFlop
            --    If 0 it keeps the state of the previous clock cycle
            en:	in	std_logic;

            -- Data input
            i:	in    std_logic;

            -- Output
            o:	out   std_logic
      );
end entity;

architecture rtl of FlipFlopD is
      signal i_s: std_logic;
      signal o_s: std_logic;

begin

      d_ff_update: process(clk, res)
      begin 
            -- Firstly check the reset signal
            if (res = '0') then
                  o_s <= '0';
                  
            -- If reset not active, only update on rising edge
            elsif rising_edge(clk) then
                  o_s <= i_s;

            end if;

      end process;

      -- Link internal state signal either to the input or to the past state
      i_s <= i when en = '1' else o_s;

      -- Bring out the current state to the FFD output line
      o <= o_s;

end architecture;