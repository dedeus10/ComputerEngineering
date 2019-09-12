-------------------------------------------------------------------------
-- Design unit: MIPS multicycle
-- Description: Control and data paths port map
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
use work.Util_pkg.all;


entity System_tb is
end System_tb;

architecture structural of System_tb is
  
    signal clock : std_logic := '1';
    signal clock_tx : std_logic := '1';
    signal reset : std_logic;
    signal rx    : std_logic;
    signal tx    : std_logic;
    signal port_io : std_logic_vector(15 downto 0);
	
    signal reset_bootloader : std_logic;
	signal prog	: std_logic_vector(1 downto 0);

    signal data_av_tx   : std_logic;
    signal data_in_tx   : std_logic_vector(7 downto 0);
    signal index        : integer;
    signal tx_ready     : std_logic;
    signal tx_out       : std_logic;


    signal data_av_rx   : std_logic;
    signal data_out_rx   : std_logic_vector(7 downto 0);
	
	
    type State is (S0, S1, S2);
        signal currentState: State;
	
	constant SIZE           : integer := 20;      --numero de linhas do arquivo_tx.txt
   
    type byteVec is array (0 to 4*SIZE-1) of std_logic_vector(7 downto 0);
   
   
   impure function PROGRAMLoad (imageFileName : in string) return byteVec is
        FILE imageFile : text open READ_MODE is imageFileName;
        variable fileLine : line;
        variable BinArray : byteVec;
        variable data_str : bit; --string(1 to 2);
		  variable bin : std_logic_vector(7 downto 0);
    begin   
        for i in 1 to SIZE loop
            readline (imageFile, fileLine);
            for j in 1 to 4 loop
					 for k in 7 downto 0 loop
						  read (fileLine, data_str);
						  bin(k) := to_stdulogic(data_str);
				    end loop;
                BinArray((i*4)-j) := bin; --StringToStdLogicVector(data_str);
            end loop; 
        end loop;
        return BinArray;
    end function;
     
    signal TXArray   : byteVec := PROGRAMLoad("arquivo_tx.txt");

begin
	
    clock <= not clock after 5 ns; -- 100 MHz
    clock_tx <= not clock_tx after 100 ns; -- 5 MHz
    reset <= '1', '0' after 200 ns; 
    
    port_io(12) <= '0', '1' after 3100 us, '0' after 4000 us;
	--port_io(12) <= '0';
         
	MIPS_MICROCONTROLLER: entity work.mips_uC(structural)
		port map (		
			board_clock      => clock,
            board_reset      => reset,
			port_io			 => port_io,
			reset_bootloader => reset_bootloader,
			prog			 => prog,
            tx               => tx,
            rx               => rx
		);
		rx <= tx_out;
		
        
	UART_TX0: entity work.UART_T0(Behavioral)
        generic map (
            --RATE_FREQ_BAUD     => 520		-- 5 MHz/9600
			RATE_FREQ_BAUD     => 43		-- 5 MHz/115200			
        )
        port map (
            clk         => clock_tx,
			rst         => reset,
			
			tx			=> tx_out,
			data_in   	=> data_in_tx,
			data_av    	=> data_av_tx,
			ready		=> tx_ready
        );
		
        
	UART_R0: entity work.UART_R0(behavioral)
        generic map (
            --RATE_FREQ_BAUD     => 520		-- 5 MHz/9600
			RATE_FREQ_BAUD     => 43		-- 5 MHz/115200			
        )
        port map (
		
            clk         => clock_tx,
			rst         => reset,
			
			rx			=> tx_out,
			data_out   	=> data_out_rx,
			data_av    	=> data_av_rx
			
			
        );
	
    
	process(clock_tx,reset)
    begin
        if reset = '1' then
			index <= 0;
            currentState <= S0;
        
        elsif rising_edge(clock_tx) then
            case currentState is
                when S0 =>
                    if tx_ready = '1' then
						 data_in_tx <= TXArray(index);
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;
                    
                when S1 =>
						data_av_tx <= '1';
						index <= index + 1;
                        currentState <= S2;
						
                 when S2 =>
						data_av_tx <= '0';
                        currentState <= S0;    
                
                                      
            end case;
        end if;
    end process;

end structural;
