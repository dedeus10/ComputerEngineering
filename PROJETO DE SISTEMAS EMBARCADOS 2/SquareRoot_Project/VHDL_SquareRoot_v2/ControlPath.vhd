--------------------------------------------------------------------------
-- Design unit: Control path                                               --
-- Description: Control Path of SquareRoot Project Based on the Logisim    --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ControlPath_pkg.all;

entity ControlPath is
    port (  
        clk             : in std_logic;
        rst             : in std_logic;

        less_than   	: in std_logic;
        go_fw          	: in std_logic;
        uins            : out control_signals				-- Control signals to data path
        
    );
end ControlPath;
                   

architecture structural of ControlPath is
    
    ----------------------------------------------
    -- Internal nets to interconnect components --
    ----------------------------------------------
    signal rst_n, enable: std_logic;
    signal Q0, Q1, Q0p, Q1p: std_logic;
    

begin

    rst_n <= not rst;
    enable <= '1';      --FF's usados para next state sempre habilitados
    
    
----------------------------------------------------------------------------------------------
    -- INSTANCE OF FF Q0p (Proximo estado)
    Q0P_STATE: entity work.dffa_R(behaviour)
    port map(
        clock       => clk,
        reset       => rst_n,
        d           => Q0p,
        q           => Q0, 
        enable      => enable
    );    

----------------------------------------------------------------------------------------------
    -- INSTANCE OF FF Q1p (Proximo estado)
    Q1P_STATE: entity work.dffa_R(behaviour)
    port map(
        clock       => clk,
        reset       => rst_n,
        d           => Q1p,
        q           => Q1, 
        enable      => enable
    );    


----------------------------------------------------------------------------------------------
    -- INSTANCE OF NextState Logic
    NEXT_STATE: entity work.NextState(structural)
    port map(
        rst_n        => rst_n,
        Q0           => Q0,
        Q1           => Q1, 
        less_than    => less_than,
        go_fw        => go_fw,
        Q0p          => Q0p,
        Q1p          => Q1p
    );    

----------------------------------------------------------------------------------------------
    -- INSTANCE OF Output
    OUTPUT: entity work.Output(structural)
    port map(
        Q0           => Q0,
        Q1           => Q1,
        uins         => uins
    );    
    

end structural;
