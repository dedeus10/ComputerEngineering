--------------------------------------------------------------------------
-- Design unit: Comparator of 16 bits                                   --
-- Description: Less than and equal than comparator                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity compare_beh is
    port (  
        A           : in  std_logic_vector(15 downto 0);
        B           : in  std_logic_vector(15 downto 0);
        AeqB        : out std_logic;
        AltB        : out std_logic
    );
end compare_beh;


architecture behavioral of compare_beh is
begin
    
    AltB <= '1' when (A < B) else '0';
    AeqB <= '1' when (A = B) else '0';
    
end behavioral;
