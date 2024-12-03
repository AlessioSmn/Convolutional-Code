library ieee;
use ieee.std_logic_1164.all;

entity Mask is
	generic (
            -- Number of bits
		N: positive := 8
	);
      port(
            -- Input data
            i:    in    std_logic_vector(N-1 downto 0);

            -- Mask
            mask: in    std_logic_vector(N-1 downto 0);
            
            -- Output
            o:    out   std_logic_vector(N-1 downto 0)
      );
end entity;

architecture beh of Mask is
begin
      o <= i AND mask;
end architecture;