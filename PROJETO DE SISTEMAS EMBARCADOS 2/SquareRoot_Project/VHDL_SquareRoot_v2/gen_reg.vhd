--------------------------------------------------------------------------
--  Entidade Registrador
--------------------------------------------------------------------------


library ieee;
	use ieee.std_logic_1164.all;

package gen_reg_package is

component gen_reg is
	generic ( REG_WIDTH : INTEGER := 8);
	port (	datain	: in std_logic_vector(REG_WIDTH - 1 downto 0);
			enable	: in std_logic;
			clock	: in std_logic;
			dataout	: out std_logic_vector(REG_WIDTH - 1 downto 0)
		 );
end component;

end gen_reg_package;

library ieee;
	use ieee.std_logic_1164.all;
library work;
	use work.dffa_package.all;
	use work.gen_reg_package.all;

entity gen_reg is
	generic ( REG_WIDTH : INTEGER := 8);
	port (	datain	: in std_logic_vector(REG_WIDTH - 1 downto 0);
			enable	: in std_logic;
			clock	: in std_logic;
			dataout	: out std_logic_vector(REG_WIDTH - 1 downto 0)
		 );
end gen_reg;



architecture structure of gen_Reg is
begin
	reg : for bit_number in 0 to REG_WIDTH - 1 generate
	dffn : dffa
		port map (	d		=> datain(bit_number),
					enable	=> enable,
					clock	=> clock,
					q		=> dataout(bit_number)
				 );
	end generate;
end structure;

