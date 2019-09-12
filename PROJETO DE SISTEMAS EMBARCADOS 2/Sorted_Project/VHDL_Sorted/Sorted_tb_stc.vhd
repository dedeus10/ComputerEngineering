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

entity Sorted_tb is
end Sorted_tb;

architecture structural of Sorted_tb is
  
    signal clk   : std_logic := '1';
    signal rst   : std_logic;

    signal v_0 : std_logic_vector(15 downto 0);
    signal v_1 : std_logic_vector(15 downto 0);
    signal v_2 : std_logic_vector(15 downto 0);
    signal v_3 : std_logic_vector(15 downto 0);
    signal v_4 : std_logic_vector(15 downto 0);
    signal v_5 : std_logic_vector(15 downto 0);
    signal v_6 : std_logic_vector(15 downto 0);
    signal v_7 : std_logic_vector(15 downto 0);
    signal v_8 : std_logic_vector(15 downto 0);
    signal v_9 : std_logic_vector(15 downto 0);

    signal R_0 : std_logic_vector(15 downto 0);
    signal R_1 : std_logic_vector(15 downto 0);
    signal R_2 : std_logic_vector(15 downto 0);
    signal R_3 : std_logic_vector(15 downto 0);
    signal R_4 : std_logic_vector(15 downto 0);
    signal R_5 : std_logic_vector(15 downto 0);
    signal R_6 : std_logic_vector(15 downto 0);
    signal R_7 : std_logic_vector(15 downto 0);
    signal R_8 : std_logic_vector(15 downto 0);
    signal R_9 : std_logic_vector(15 downto 0);

    signal sorted   : std_logic;
    
    signal count : SIGNED (7 downto 0);
    
begin
    
    clk <= not clk after 4 ns; -- 100 MHz
    rst <= '1', '0' after 1 ns;

    v_0 <= x"0001";
    v_1 <= x"0002";
    v_2 <= x"0003";
    v_3 <= x"0004";
    v_4 <= x"0005";
    v_5 <= x"0006";
    v_6 <= x"0007";
    v_7 <= x"0008";
    v_8 <= x"0009";
    v_9 <= x"000A";
         

	SORTED_PROC: entity work.Sorted_stc(structural)
		port map (		
			clk             => clk,
            rst             => rst,
            v_0               => v_0,
            v_1               => v_1,
            v_2               => v_2,
            v_3               => v_3,
            v_4               => v_4,
            v_5               => v_5,
            v_6               => v_6,
            v_7               => v_7,
            v_8               => v_8,
            v_9               => v_9,

            R_0               => R_0,
            R_1               => R_1,
            R_2               => R_2,
            R_3               => R_3,
            R_4               => R_4,
            R_5               => R_5,
            R_6               => R_6,
            R_7               => R_7,
            R_8               => R_8,
            R_9               => R_9,
    
            sorted           => sorted
        );
      
    --INSTANCE OF THE COUNTER TO COUNT THE NUMBER OF CYCLES
        process(clk, rst)
        begin
                if(rst = '1') then 
                    count <= x"00";
                elsif (clk = '1' and clk'event)   then
                    count <= count + x"01";
                 end if;   
        end process;

end structural;
