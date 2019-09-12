--------------------------------------------------------------------------
-- Design unit: SquareRoot Behaviour                                     --
-- Description: SquareRoot Project Based on the Logisim                 --
-- Author: Luis Felipe de Deus, Federal University of Santa Maria       --
-- Date: 22/10/18                                                       --
-- Update: 01/11/18                                                     --
--------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SquareRoot_beh is
    port ( 
        clk, rst        : in std_logic;
        
        data_in         : in std_logic_vector(15 downto 0);
        root            : out std_logic_vector(7 downto 0);
        ready           : out std_logic
		
    );
end SquareRoot_beh;
                   

architecture behavioral of SquareRoot_beh is
    
    -- FSM states
    type State is (S0, S1, S2, S3);
    signal currentState, nextState: State;

    signal input_number: std_logic_vector(15 downto 0);
    signal square_s: SIGNED(15 downto 0);
    signal root_s: SIGNED(7 downto 0);
    signal go_fw, less_than: std_logic;
    
begin
    
    --------------------
    -- State register --
    --------------------
    STATE_REGISTER: process (clk, rst)
    begin
        if(rst = '1') then
            currentState <= S0;
        elsif rising_edge(clk) then
            currentState <= nextState;
        end if;
    end process;

    
    NEXT_STATE_LOGIC: process(rst, clk, currentState, less_than)
    begin
        case currentState is
            	
			-- INITIALIZE THAT BEGIN
            when S0 =>

            input_number <= data_in;
            root_s <= x"01";
            square_s <= x"0004";
            ready <= '0';

            if (go_fw = '1') then
                nextState <= S1;	
            
            else
                nextState <= S2;
            end if;        
				
            -- INITIALIZE CONSTANTS GO FORWARD
            when S1 => 
            root_s <= x"80";
            square_s <= x"4101";

            nextState <= S2;
    
            -- CALCULATE
            when S2 =>

            if (less_than = '1') then
                nextState <= S3;	
            
            else
                nextState <= S2;
            end if;        

            if((rising_edge(clk)) and (less_than = '0')) then
                square_s <= square_s + (root_s & '0') + x"0001";
                root_s <= root_s + x"01";
            end if;
            

            -- DONE
            when S3 =>
            ready <= '1';
            nextState <= S3;
            	
            when others =>
                nextState <= S0;
				
        end case;
    end process;
    
    ---------------------------------------------
    -- Control signals generation to data path --
    ---------------------------------------------

     go_fw <= input_number(14) or input_number(15);
    less_than <= '1' when input_number < std_logic_vector(square_s) else '0';
    
    root <= std_logic_vector(root_s);
    
end behavioral;