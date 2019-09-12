-------------------------------------------------------------------------
-- Design unit: Bootloader
-- Description: Faz o bootloader das memorias de dados e de instruções via terminal.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 


entity Bootloader is
    port (  
        clk 	      	  : in std_logic;
        rst	    		  : in std_logic; 
        ce      	      : in std_logic;
		i_d				  : in std_logic;
		data_av   	      : in std_logic;
		ready			  : out std_logic;
        data_in           : in  std_logic_vector (7 downto 0);
        data_out          : out std_logic_vector (31 downto 0);
		address			  : out std_logic_vector (31 downto 0)
    );
end Bootloader;


architecture behavioral of Bootloader is

type State is (S0, S1, S2, S3, S4);
     signal currentState: State;

signal data_in_1_byte: std_logic_vector(7 downto 0);	 
signal data_in_2_byte: std_logic_vector(15 downto 0);	 
signal data_in_3_byte: std_logic_vector(23 downto 0);

signal mem_address :std_logic_vector(31 downto 0);

begin

    process(clk,rst)
    begin
        if rst = '1' then
            data_out <= (others=>'0');
			ready <= '0';
            
			if i_d = '0' then
				mem_address <= x"00003000";
				--address <= mem_address;
			else
				mem_address <= x"00000000";
				--address <= mem_address;
			end if;
			
            currentState <= S0;
        
        elsif rising_edge(clk) then
            case currentState is
                when S0 =>
                    if ce = '1' then
						if data_av = '1' then
							ready <= '0';
							data_in_1_byte <= data_in;
							currentState <= S1;
						else
							currentState <= S0;
						end if;
					end if;
                    
                when S1 =>
					if ce = '1' then
						if data_av = '1' then
							data_in_2_byte <= data_in & data_in_1_byte;
							currentState <= S2;
						else
							currentState <= S1;
						end if;
					end if;	
                        
                when S2 =>
					if ce = '1' then
						if data_av = '1' then
							data_in_3_byte <= data_in & data_in_2_byte;
							currentState <= S3;
						else
							currentState <= S2;
						end if;
					end if;	
                    
                when S3 =>
					if ce = '1' then
						if data_av = '1' then
							data_out <= data_in & data_in_3_byte;
							ready <= '1';
							address <= mem_address;
							currentState <= S4;
						else
							currentState <= S3;
						end if;
					end if;	
					
				when S4 =>	--State done
					if ce = '1' then
						ready <= '0';
						mem_address <= STD_LOGIC_VECTOR (UNSIGNED(mem_address) + 4) ;
						currentState <= S0;
					end if;	
                                      
            end case;
        end if;
    end process;
	
        
end behavioral;
