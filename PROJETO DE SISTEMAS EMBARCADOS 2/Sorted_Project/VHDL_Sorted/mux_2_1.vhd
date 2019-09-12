-------------------------------------------------------------------------
-- Design unit: Multiplexador
-- Description: Multiplexador 2:1
--------------------------------------------------------------------------

library IEEE;						
use IEEE.std_logic_1164.all;

-- Component interface declaration
entity multiplexador_2_1 is
	generic ( MUX_WIDTH : INTEGER := 8);
	port(
		-- Inputs
		i0, i1			: in std_logic_vector(MUX_WIDTH - 1 downto 0);
		sel				: in std_logic;
		
		-- Output
		q			: out std_logic_vector(MUX_WIDTH - 1 downto 0)
	);
end multiplexador_2_1;


-- Functional description (implementation)
architecture arch1 of multiplexador_2_1 is

begin
	
	q <=	i0 when sel = '0' else
			i1;
				
end arch1;
