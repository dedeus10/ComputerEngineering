-------------------------------------------------------------------------
-- Design unit: ControlPath package of signals
-- Description:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package DataPath_pkg is  
        
    -- Control signals to data path
    type data_signals is record
        
        less_than_A : std_logic;
        less_than_B : std_logic;
        less_than_C : std_logic;
        less_than_D : std_logic;
        less_than_E : std_logic;

        equal_A : std_logic;
        equal_B : std_logic;
        equal_C : std_logic;
        equal_D : std_logic;
        equal_E : std_logic;

        BltA_A : std_logic;
        BltA_B : std_logic;
        BltA_C : std_logic;
        BltA_D : std_logic;
        BltA_E : std_logic;

    end record;
                
end DataPath_pkg;


