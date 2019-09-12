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
        
        rst_n            : in std_logic;
        Q0               : in std_logic;
        Q1               : in std_logic;
        less_than   	 : in std_logic;
        go_fw            : in std_logic;
        Q0p               : out std_logic;
        Q1p               : out std_logic

    );
end NextState;
                   

architecture structural of NextState is

    signal and_one, and_two, and_three, and_four, and_five, and_six, and_seven: std_logic;

begin

    --LOGIC OF NEXT STATE
    and_one <= (not go_fw) and rst_n;
    and_two <= Q1 and rst_n;
    and_three <= Q0 and rst_n;
    
    and_four <= (not Q0) and (not Q1) and go_fw and rst_n;
    and_five <= Q1 and less_than and rst_n;
    and_six <= Q0 and less_than and rst_n;
    and_seven <= Q0 and Q1 and rst_n;

    Q0p <= and_one or and_two or and_three;    
    Q1p <= and_four or and_five or and_six or and_seven;

end structural;
