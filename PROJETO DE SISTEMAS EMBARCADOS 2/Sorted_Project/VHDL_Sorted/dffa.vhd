--------------------------------------------------------------------------
--  Entidade Flip-Flop
--------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

package dffa_package is

	component dffa is
		port (	d		: in std_logic;
				enable	: in std_logic;
				clock	: in std_logic;
				q		: out std_logic
			 );
	end component;

end dffa_package;

library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.dffa_package.all;

entity dffa is
	port (	d		: in std_logic;
			enable	: in std_logic;
			clock	: in std_logic;
			q		: out std_logic
		 );
end dffa;



architecture behaviour of dffa is
	signal sig_q : std_logic;
begin
	
	dffares_proc : process(clock)
	begin
		if (clock = '1' and clock'event) then
			if (enable = '1') then
				sig_q <= d;
			else 
				sig_q <= sig_q;
			end if;
		end if;
	end process;	
	q <= sig_q;
end behaviour;



