--------------------------------------------------------------------------
-- Design unit: Output
-- Description: Logic of Output for Signals Control Path of SquareRoot  --
-- Project Based on the Logisim                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 30/10/18                                                       --
-- Update: 31/10/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ControlPath_pkg.all;
use work.DataPath_pkg.all;


entity Output is
    port (  
        
        Q0               : in std_logic;
        Q1               : in std_logic;
        
        uins            : out  control_signals;               -- Control path (control signals)
        -- Data path interface
        uins_o          : in  data_signals               -- Data path record (data signals)

    );
end Output;
                   

architecture structural of Output is

signal state_S0, state_even, state_odd :std_logic;
signal sel_0, sel0_1, sel0_2, sel0_3, sel0_4, sel0_5, sel0_6, sel0_7, sel0_8 :std_logic;
signal sel1_1, sel1_2, sel1_3, sel1_4, sel1_5, sel1_6, sel1_7, sel1_8 :std_logic;

begin

    --LOGIC OF CONTROL SIGNS 
    state_S0 <= (not Q0) and (not Q1);
    state_even <= (not Q0) and Q1;
    state_odd <= Q0 and (not Q1);

    -- Seletor of Mux
        --Seletor mux0
    sel_0 <= state_even and uins_o.less_than_A;
    uins.sel_0 <= sel_0;

        --Seletor mux1
    sel0_1 <= sel_0;
    sel1_1 <= state_odd and uins_o.BltA_A;
    uins.sel_1 <= sel1_1 & sel0_1;

        --Seletor mux2
    sel0_2 <= sel1_1;
    sel1_2 <= state_even and uins_o.less_than_B;    
    uins.sel_2 <= sel1_2 & sel0_2;

        --Seletor mux3
    sel0_3 <= sel1_2;
    sel1_3 <= state_odd and uins_o.BltA_B;    
    uins.sel_3 <= sel1_3 & sel0_3;

        --Seletor mux4
    sel0_4 <= sel1_3;
    sel1_4 <= state_even and uins_o.less_than_C;    
    uins.sel_4 <= sel1_4 & sel0_4;

        --Seletor mux5
    sel0_5 <= sel1_4;
    sel1_5 <= state_odd and uins_o.BltA_C;    
    uins.sel_5 <= sel1_5 & sel0_5;

        --Seletor mux6
    sel0_6 <= sel1_5;
    sel1_6 <= state_even and uins_o.less_than_D;    
    uins.sel_6 <= sel1_6 & sel0_6;

        --Seletor mux7
    sel0_7 <= sel1_6;
    sel1_7 <= state_odd and uins_o.BltA_D;    
    uins.sel_7 <= sel1_7 & sel0_7;

        --Seletor mux8
    sel0_8 <= sel1_7;
    sel1_8 <= state_even and uins_o.BltA_E;    
    uins.sel_8 <= sel1_8 & sel0_8;

        --Seletor mux9
    uins.sel_9 <= sel1_8;
    
    

    --Enable registers
    uins.en_0 <= state_S0 or sel_0;
    uins.en_1 <= state_S0 or sel_0 or sel1_1;
    uins.en_2 <= state_S0 or sel1_2 or sel1_1;
    uins.en_3 <= state_S0 or sel1_2 or sel1_3;
    uins.en_4 <= state_S0 or sel1_4 or sel1_3;
    uins.en_5 <= state_S0 or sel1_4 or sel1_5;
    uins.en_6 <= state_S0 or sel1_6 or sel1_5;
    uins.en_7 <= state_S0 or sel1_6 or sel1_7;
    uins.en_8 <= state_S0 or sel1_8 or sel1_7;
    uins.en_9 <= state_S0 or sel1_8;
    
    uins.even <= (not Q0) nand Q1;
    
end structural;
