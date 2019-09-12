--------------------------------------------------------------------------
-- Design unit: SquareRoot Top Entity
-- Description: SquareRoot with ControlPath and DataPath                --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ControlPath_pkg.all;

entity SquareRoot_v2 is
    port ( 
        clk, rst        : in std_logic;
        
        data_in         : in std_logic_vector(15 downto 0);
        root            : out std_logic_vector(7 downto 0);
        ready           : out std_logic
		
    );
end SquareRoot_v2;

architecture structural of SquareRoot_v2 is
    
    --Signals 
    signal uins: control_signals;
    signal less_than, go_fw: std_logic;
    
begin

    --INSTANCE OF CONTROL PATH - SQUARE ROOT
     CONTROL_PATH: entity work.ControlPath(structural)
         port map (
             clk            => clk,
             rst            => rst,
             less_than		=> less_than,
             go_fw  		=> go_fw,
             uins           => uins
			 
         );         
    
    --INSTANCE OF DATA PATH - SQUARE ROOT     
     DATA_PATH: entity work.DataPath(structural)
         port map (
            clk               => clk,
            rst               => rst,            
            data_in           => data_in,
            uins              => uins,              
            root              => root, 
            less_than         => less_than,
            go_fw      	      => go_fw,
            ready             => ready
            
         );
     
end structural;
