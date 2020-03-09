-- Universidade Federal de Santa Maria - UFSM
-- Centro de Técnologia - CT
-- Projeto de Sistemas Digitais 2016/2
-- Luis Felipe, Pedro Basso, Lucas Lauck
-- Projeto Processador CORDIC - Registrador Parametrizavel 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;	

entity RegisterNbits is
	generic (
		WIDTH		: integer := 32;
		INIT_VALUE	: integer := 0 
	);
	port (  
		clk		: in std_logic;
		rst		: in std_logic; 
		en		: in std_logic;
		d 		: in  std_logic_vector (WIDTH-1 downto 0);
		q 		: out std_logic_vector (WIDTH-1 downto 0)
	);
end RegisterNbits;


architecture behavioral of RegisterNbits is
begin

	process(clk, rst)
	begin
		if rst = '1' then
			q <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE,WIDTH));		
		
		elsif rising_edge(clk) then
			if en = '1' then
				q <= d; 
			end if;
		end if;
	end process;
        
end behavioral;
