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
use work.DataPath_pkg.all;

entity Sorted_stc is
    port ( 
        clk, rst        : in std_logic;

        --Data Input (Vector)
        v_0             :in std_logic_vector(15 downto 0);
        v_1             :in std_logic_vector(15 downto 0);
        v_2             :in std_logic_vector(15 downto 0);
        v_3             :in std_logic_vector(15 downto 0);
        v_4             :in std_logic_vector(15 downto 0);
        v_5             :in std_logic_vector(15 downto 0);
        v_6             :in std_logic_vector(15 downto 0);
        v_7             :in std_logic_vector(15 downto 0);
        v_8             :in std_logic_vector(15 downto 0);
        v_9             :in std_logic_vector(15 downto 0);

        R_0             :out std_logic_vector(15 downto 0);
        R_1             :out std_logic_vector(15 downto 0);
        R_2             :out std_logic_vector(15 downto 0);
        R_3             :out std_logic_vector(15 downto 0);
        R_4             :out std_logic_vector(15 downto 0);
        R_5             :out std_logic_vector(15 downto 0);
        R_6             :out std_logic_vector(15 downto 0);
        R_7             :out std_logic_vector(15 downto 0);
        R_8             :out std_logic_vector(15 downto 0);
        R_9             :out std_logic_vector(15 downto 0);

        
        -- Output
        sorted           : out std_logic
		
    );
end Sorted_stc;

architecture structural of Sorted_stc is
    
    --Signals 
    signal uins: control_signals;
    signal uins_o: data_signals;

    
begin

    --INSTANCE OF CONTROL PATH - SORTED
     CONTROL_PATH: entity work.ControlPath(structural)
         port map (
             clk            => clk,
             rst            => rst,
             uins_o         => uins_o,
             uins           => uins,
             sorted         => sorted
			 
         );         
    
    --INSTANCE OF DATA PATH - SORTED
     DATA_PATH: entity work.DataPath(structural)
         port map (
            clk               => clk,
            rst               => rst,           

            v_0               => v_0,
            v_1               => v_1,
            v_2               => v_2,
            v_3               => v_3,
            v_4               => v_4,
            v_5               => v_5,
            v_6               => v_6,
            v_7               => v_7,
            v_8               => v_8,
            v_9               => v_9,

            R_0               => R_0,
            R_1               => R_1,
            R_2               => R_2,
            R_3               => R_3,
            R_4               => R_4,
            R_5               => R_5,
            R_6               => R_6,
            R_7               => R_7,
            R_8               => R_8,
            R_9               => R_9,

            uins              => uins,              
            uins_o            => uins_o
            
            
         );
     
end structural;
