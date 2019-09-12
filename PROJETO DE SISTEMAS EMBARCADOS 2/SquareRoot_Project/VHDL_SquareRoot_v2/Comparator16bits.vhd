--------------------------------------------------------------------------
-- Design unit: Comparator                                              --
-- Description: Comparator 16 bits with output less than and equal      --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 03/09/18                                                       --
-- Update: 04/09/18                                                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Comparator16bits is
    port (  
        A           : in  std_logic_vector(15 downto 0);
        B           : in  std_logic_vector(15 downto 0); 
        AeqB        : out std_logic;
        AltB        : out std_logic
    );
end Comparator16bits;


architecture structural of Comparator16bits is

    signal AeqBtemp : std_logic_vector(15 downto 0);
    signal AltBtemp : std_logic_vector(15 downto 0);

begin
    
    AeqBtemp(15) <= (A(15) xnor B(15)) and '1';
    AltBtemp(15) <= (not(A(15))) and B(15)  and '1';
    
    COMPARATORS: for i in 14 downto 0 generate
        AeqBtemp(i) <= (A(i) xnor B(i)) and AeqBtemp(i+1);
        AltBtemp(i) <= (not(A(i))) and B(i) and AeqBtemp(i+1);
    end generate;
    
    
    AeqB <= AeqBtemp(0);
    
    AltB <= AltBtemp(15) or AltBtemp(14) or AltBtemp(13) or AltBtemp(12) or
            AltBtemp(11) or AltBtemp(10) or AltBtemp(9) or AltBtemp(8) or
            AltBtemp(7) or AltBtemp(6) or AltBtemp(5) or AltBtemp(4) or
            AltBtemp(3) or AltBtemp(2) or AltBtemp(1) or AltBtemp(0);
    
        
end structural;