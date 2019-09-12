-------------------------------------------------------------------------
-- Design unit: Circuito de Pulso Unitario
-- Description: FlipFlop

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pulse is
    port ( 
        clock           : in std_logic;
		ce				: in std_logic;
        d           	: in std_logic;
		q           	: out std_logic
        
    );
end Pulse;

architecture behavioral of Pulse is
signal flag: std_logic;
begin           
	--flag <= '1';
		process(clock)
		begin
			
			if rising_edge(clock)then
				if  ((flag = '1') and (ce = '1')) then
						q <= d;
						flag <= '0';
				
				else 
						q <= '0';
						flag <= '1';
				end if;		
			end if;			
		end process;
		
end behavioral;
