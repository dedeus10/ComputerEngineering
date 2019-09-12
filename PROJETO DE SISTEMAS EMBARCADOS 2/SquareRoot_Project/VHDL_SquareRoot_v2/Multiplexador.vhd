-------------------------------------------------------------------------
-- Design unit: Multiplexador
-- Description: Multiplexador 4:1
--------------------------------------------------------------------------

library IEEE;						
use IEEE.std_logic_1164.all;

-- Component interface declaration
entity multiplexador is
	generic ( MUX_WIDTH : INTEGER := 8);
	port(
		-- Inputs
		i0, i1, i2, i3			: in std_logic_vector(MUX_WIDTH - 1 downto 0);
		sel				: in std_logic_vector(1 downto 0);
		
		-- Output
		q			: out std_logic_vector(MUX_WIDTH - 1 downto 0)
	);
end multiplexador;


-- Functional description (implementation)
architecture arch1 of multiplexador is

begin
	
	q <=	i0 when sel = "00" else
			i1 when sel = "01" else
			i2 when sel = "10" else
			i3;
				
end arch1;
