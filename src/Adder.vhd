library ieee;
use ieee.std_logic_1164.all;

-- Performs the sum of N bits in GF(2)
-- In fact the output is equal to 1 if there is an odd number of bits set to 1 in the input array, 0 otherwise
entity Adder is
	generic (
            -- Number of bits of the input
		N: positive := 8
	);
      port(
            -- Input
            a:    in    std_logic_vector(N-1 downto 0);
            
            -- Output
            s:    out   std_logic
      );
end entity;

architecture beh of Adder is
      component HalfAdder is
            port(
                  a:    in    std_logic;
                  cin:  in    std_logic;
                  s:    out   std_logic
            );
      end component;

	signal carry_a:	std_logic_vector(N - 2 downto 0);
begin
      
      -- Chain of HalfAdders
      gen_Adder: for i in 1 to N - 1 generate

            -- First HalfAdder takes teh first two bits of the input array vector a
            gen_first: if i = 1 generate
                  halfAdder_first: HalfAdder
                  port map(
                        a => a(0),
                        cin => a(1),
                        s => carry_a(0)
                  );
            end generate;

            -- All others HalfAdders sum a bit of the input array with the carry bit of the previous HalfAdder
            gen_middle: if i > 1 generate
                  halfAdder_other: HalfAdder
                  port map(
                        a => carry_a(i-2),
                        cin => a(i),
                        s => carry_a(i-1)
                  );
            end generate;

      end generate;

      -- Output of the last halfAdder goes out as final output
      s <= carry_a(N-2);

end architecture;
