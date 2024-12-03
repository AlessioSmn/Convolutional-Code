library ieee;
use ieee.std_logic_1164.all;

-- Performs the sum of two bits
entity HalfAdder is
      port(
            -- Input 1
            a:    in    std_logic;

            -- Input 2 / Carry
            cin:  in    std_logic;
            
            -- Output
            s:    out   std_logic
      );
end entity;

architecture rtl of HalfAdder is
begin
      s <= a XOR cin;
end architecture;
