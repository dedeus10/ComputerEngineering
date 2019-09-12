--------------------------------------------------------------------------
-- Design unit: Output
-- Description: Logic of Output for Signals Control Path of SquareRoot  --
-- Project Based on the Logisim                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ControlPath_pkg.all;


entity Output is
    port (  
        
        Q0               : in std_logic;
        Q1               : in std_logic;
        
        uins            : out  control_signals               -- Control path (control signals)
        

    );
end Output;
                   

architecture structural of Output is

begin

    --LOGIC OF CONTROL SIGNS 
    uins.sel_i(0) <= Q1;
    uins.sel_i(1) <= Q0;
    uins.en_input <= (not Q0) and (not Q1);
    uins.en_ro_sq <= (not Q0) or (not Q1);
    uins.ready <= Q0 and Q1;

end structural;
