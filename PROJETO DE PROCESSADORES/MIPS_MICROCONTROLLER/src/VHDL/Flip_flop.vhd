-------------------------------------------------------------------------
-- Design unit: Register file
-- Description: 32 general purpose registers
--     - 2 read ports
--     - 1 write port
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Flip_flop is
    port ( 
        clock           : in std_logic;
		--ce				: in std_logic;
        d           	: in std_logic;
		q           	: out std_logic
        
    );
end Flip_flop;

architecture behavioral of Flip_flop is
begin           
	
		process(clock)
		begin
		
			if rising_edge(clock)	then
				q <= d;
			end if;
			
		end process;
		
end behavioral;
