-- Universidade Federal de Santa Maria - UFSM
-- Centro de Técnologia - CT
-- Projeto de Sistemas Digitais 2016/2
-- Luis Felipe, Pedro Basso, Lucas Lauck
-- Projeto Processador CORDIC - Package contendo Records
library IEEE;
use IEEE.std_logic_1164.all;

package Cordic_package is  
        
   type Command is record
      	x_new_en	: std_logic;
	x_en		: std_logic;
	sinal_desl	: std_logic;
	y_new_en	: std_logic;
	sumAngle_en	: std_logic;
	sub		: std_logic;
	mux_x 		: std_logic;
	it_en		: std_logic;
	mux_sm1		: std_logic_vector(1 downto 0);
	mux_sm2		: std_logic_vector(2 downto 0);
	angle_en	: std_logic;
	i_en		: std_logic;
        cos_en    	: std_logic;
	sin_en          : std_logic; 
   end record;
	     
end Cordic_package;
