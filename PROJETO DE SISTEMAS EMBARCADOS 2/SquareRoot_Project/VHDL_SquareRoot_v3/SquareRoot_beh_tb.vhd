--------------------------------------------------------------------------
-- Design unit: SquareRoot Test Bench
-- Description:                                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 30/10/18                                                       --
-- Update: 31/10/18                                                     --
--------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SquareRoot_beh_tb is
end SquareRoot_beh_tb;

architecture structural of SquareRoot_beh_tb is
  
    signal clock   : std_logic := '1';
    signal reset   : std_logic;
    signal data_in : std_logic_vector(15 downto 0);
    signal root    : std_logic_vector(7 downto 0);
    signal ready   : std_logic;
    
    signal count : SIGNED (7 downto 0);
    
begin
    
    clock <= not clock after 10 ns; -- 100 MHz
    reset <= '1', '0' after 200 ns;
    data_in <= x"0089";
         

	SQUARE_ROOT_BEH: entity work.SquareRoot_beh(behavioral)
		port map (		
			clk             => clock,
            rst             => reset,
            data_in         => data_in,
            root            => root,
            ready           => ready
        );
      
    --INSTANCE OF THE COUNTER TO COUNT THE NUMBER OF CYCLES
        process(clock)
        begin
                if(reset = '1') then 
                    count <= x"00";
                elsif (clock = '1' and clock'event)   then
                    count <= count + x"01";
                 end if;   
        end process;

end structural;
