-------------------------------------------------------------------------
-- Design unit: ControlPath package of signals
-- Description:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package ControlPath_pkg is  
        
    -- Control signals to data path
    type control_signals is record
        en_0    : std_logic;
        en_1    : std_logic;
        en_2    : std_logic;
        en_3    : std_logic;
        en_4    : std_logic;
        en_5    : std_logic;
        en_6    : std_logic;
        en_7    : std_logic;
        en_8    : std_logic;
        en_9    : std_logic;

        sel_0   : std_logic;
        sel_1   : std_logic_vector(1 downto 0);
        sel_2   : std_logic_vector(1 downto 0);
        sel_3   : std_logic_vector(1 downto 0);
        sel_4   : std_logic_vector(1 downto 0);
        sel_5   : std_logic_vector(1 downto 0);
        sel_6   : std_logic_vector(1 downto 0);
        sel_7   : std_logic_vector(1 downto 0);
        sel_8   : std_logic_vector(1 downto 0);
        sel_9   : std_logic;
        
        
        even : std_logic;
        finish_even : std_logic;

        
    end record;
                
end ControlPath_pkg;


