--------------------------------------------------------------------------
-- Design unit: Sorted Test Bench in Verilog 
-- Description:                                                         --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 19/11/18                                                       --
-- Update: 20/11/18                                                     --
--------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Sorted_stc_tbV is
end Sorted_stc_tbV;

architecture structural of Sorted_stc_tbV is

    component Sorted_stc is
        port(
            clk        : in std_logic := '1';
            rst        : in std_logic;

            --Data Input (Vector)
            v_0             :in std_logic_vector(15 downto 0);
            v_1             :in std_logic_vector(15 downto 0);
            v_2             :in std_logic_vector(15 downto 0);
            v_3             :in std_logic_vector(15 downto 0);
            v_4             :in std_logic_vector(15 downto 0);
            v_5             :in std_logic_vector(15 downto 0);
            v_6             :in std_logic_vector(15 downto 0);
            v_7                 :in std_logic_vector(15 downto 0);
            v_8             :in std_logic_vector(15 downto 0);
            v_9             :in std_logic_vector(15 downto 0);

            R_0             :out std_logic_vector(15 downto 0);
            R_1             :out std_logic_vector(15 downto 0);
            R_2             :out std_logic_vector(15 downto 0);
            R_3             :out std_logic_vector(15 downto 0);
            R_4             :out std_logic_vector(15 downto 0);
            R_5             :out std_logic_vector(15 downto 0);
            R_6             :out std_logic_vector(15 downto 0);
            R_7             :out std_logic_vector(15 downto 0);
            R_8             :out std_logic_vector(15 downto 0);
            R_9             :out std_logic_vector(15 downto 0);

            -- Output
            sorted           : out std_logic
        
        );
        end component;


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
begin
 	

    clk <= not clk after 4.25 ns; -- Best frequency
    rst <= '1', '0' after 2 ns;
    v_0 <= x"000A";
    v_1 <= x"2000";
    v_2 <= x"0303";
    v_3 <= x"0064";
    v_4 <= x"0005";
    v_5 <= x"0016";
    v_6 <= x"00A7";
    v_7 <= x"0908";
    v_8 <= x"0001";
    v_9 <= x"0002";

         

	DUV: Sorted_stc port map(
                clk,
                rst,

                --Data Input (Vector)
                v_0,
                v_1,
                v_2,
                v_3,
                v_4,
                v_5,
                v_6,
                v_7,
                v_8,
                v_9,

                R_0,
                R_1,
                R_2,
                R_3,
                R_4,
                R_5,
                R_6,
                R_7,
                R_8,
                R_9,

            -- Output
                sorted
    
        );
      

end structural;
