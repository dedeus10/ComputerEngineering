-------------------------------------------------------------------------
-- Design unit: ControlPath package of signals
-- Description:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package ControlPath_pkg is  
        
    -- Control signals to data path
    type control_signals is record
        en_ro_sq    : std_logic;
        en_input    : std_logic;
        sel_i       : std_logic_vector(1 downto 0);              
        ready       : std_logic;
    end record;
                
end ControlPath_pkg;


