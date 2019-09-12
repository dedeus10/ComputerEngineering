--------------------------------------------------------------------------
--  Entidade Flip-Flop
--------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

package dffa_package_R is

	component dffa is
		port (	d		: in std_logic;
				reset	: in std_logic;
				enable	: in std_logic;
				clock	: in std_logic;
				q		: out std_logic
			 );
	end component;

end dffa_package_R;

library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.dffa_package_R.all;

entity dffa_R is
	port (	d		: in std_logic;
			reset	: in std_logic;
			enable	: in std_logic;
			clock	: in std_logic;
			q		: out std_logic
		 );
end dffa_R;



architecture behaviour of dffa_R is
	signal sig_q : std_logic;
begin
	
	dffares_proc : process( reset, clock)
	begin
		if (reset = '0') then
			sig_q <= '0';
		elsif (clock = '1' and clock'event) then
			if (enable = '1') then
				sig_q <= d;
			else 
				sig_q <= sig_q;
			end if;
		end if;
	end process;	
	q <= sig_q;
end behaviour;



