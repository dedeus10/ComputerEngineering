--------------------------------------------------------------------------
-- Design unit: SquareRoot Test Bench
-- Description:                                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SquareRoot_tb is
end SquareRoot_tb;

architecture structural of SquareRoot_tb is

    component SquareRoot_F is
        port(
            clk     : in std_logic := '1';
            rst     : in std_logic;
            data_in : in std_logic_vector(15 downto 0);
            root    : out std_logic_vector(7 downto 0);
            ready   : out std_logic
        
        );
        end component;

    	signal clk : std_logic := '1';
	signal rst : std_logic;
	signal root : std_logic_vector(7 downto 0);
	signal ready : std_logic;
	signal data_in : std_logic_vector(15 downto 0);
begin
 	

    clk <= not clk after 1.875 ns; -- 266 MHz Best frequency
    rst <= '1', '0' after 20 ns;
    data_in <= x"0089";
         

	DUV: SquareRoot_F port map(
		clk => clk,
                rst => rst,
                data_in => data_in,
                root => root,
                ready => ready
        );
      

end structural;
