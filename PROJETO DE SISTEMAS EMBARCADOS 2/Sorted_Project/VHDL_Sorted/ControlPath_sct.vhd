--------------------------------------------------------------------------
-- Design unit: Control path                                               --
-- Description: Control Path of SquareRoot Project Based on the Logisim    --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 30/10/18                                                       --
-- Update: 31/10/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ControlPath_pkg.all;
use work.DataPath_pkg.all;


entity ControlPath is
    port (  
        clk             : in std_logic;
        rst             : in std_logic;

        sorted        	: out std_logic;

        uins            : out control_signals;				-- Control signals to data path
        -- Data path interface
        uins_o          : in  data_signals               -- Data path record (data signals)

        
    );
end ControlPath;
                   

architecture structural of ControlPath is
    
    ----------------------------------------------
    -- Internal nets to interconnect components --
    ----------------------------------------------
    signal rst_n, enable: std_logic;
    signal Q0, Q1, Q0p, Q1p: std_logic;
    signal finish_sorted, finish_odd, in_even, q_even :std_logic;    

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
----------------------------------------------------------------------------------------------
    -- INSTANCE OF FF FOR SORTED 
    EVEN_SORTED: entity work.dffa_R(behaviour)
    port map(
        clock       => clk,
        reset       => rst_n,
        d           => in_even,
        q           => q_even, 
        enable      => enable
    );    

in_even <= (not Q0) and Q1 and (not uins_o.less_than_A) and (not uins_o.less_than_B)  and (not uins_o.less_than_C) and (not uins_o.less_than_D) and (not uins_o.BltA_E);
----------------------------------------------------------------------------------------------

    -- INSTANCE OF NextState Logic
    NEXT_STATE: entity work.NextState(structural)
    port map(
        Q0           => Q0,
        Q1           => Q1, 
        
        finish_sorted => finish_sorted,

        Q0p          => Q0p,
        Q1p          => Q1p
        --sorted       => sorted
    );    

----------------------------------------------------------------------------------------------
    -- INSTANCE OF Output
    OUTPUT: entity work.Output(structural)
    port map(
        Q0           => Q0,
        Q1           => Q1,
        uins         => uins,
        uins_o       => uins_o
    );    
    
---------------------------------------------------------------------------------------
    --LOGIC OF SORTED
 finish_odd <= Q0 and (not Q1) and (not uins_o.BltA_A) and (not uins_o.BltA_B) and (not uins_o.BltA_C) and (not uins_o.BltA_D);

 finish_sorted <= (q_even and finish_odd) or (Q0 and Q1);
 sorted <= finish_sorted;

end structural;
