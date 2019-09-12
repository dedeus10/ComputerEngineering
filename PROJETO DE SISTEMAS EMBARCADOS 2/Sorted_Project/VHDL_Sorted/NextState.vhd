--------------------------------------------------------------------------
-- Design unit: Next State
-- Description: Logic of NextState for Control Path of SquareRoot       --
-- Project Based on the Logisim                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity NextState is
    port (  
        
        Q0               : in std_logic;
        Q1               : in std_logic;
        
        finish_sorted    : in std_logic;

        Q0p               : out std_logic;
        Q1p               : out std_logic;
        sorted            : out std_logic

    );
end NextState;
                   

architecture structural of NextState is


begin

    --LOGIC OF NEXT STATE
    Q0p <= finish_sorted or Q1;    
    Q1p <= (not Q1) or finish_sorted or Q0;
    --sorted <= (Q0 and Q1) or finish_sorted;

end structural;
