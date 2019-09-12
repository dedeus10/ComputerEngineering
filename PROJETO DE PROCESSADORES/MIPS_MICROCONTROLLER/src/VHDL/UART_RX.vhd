------------------------------------------------------------------------------
-- DESIGN UNIT  : UART RX                                                   --
-- DESCRIPTION  : Start bit/8 data bits/Stop bit                            --
--              :                                                           --
-- AUTHOR       : Everton Alceu Carara                                      --
-- CREATED      : May, 2016                                                 --
-- VERSION      : 1.0                                                       --
-- HISTORY      : Version 1.0 - May, 2016 - Everton Alceu Carara            --         
------------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_RX is
    --generic(
      --  RATE_FREQ_BAUD  : integer -- Frequence entering the clk input in Hz / Baud rate (bits per sencond)
        -- Considering clk = 5MHz
        --      9600: RATE_FREQ_BAUD = 520
        --      19200: RATE_FREQ_BAUD = 260
        --      38400: RATE_FREQ_BAUD = 130
        --      57600: RATE_FREQ_BAUD = 86
        --      115200: RATE_FREQ_BAUD = 43
        --      460800: RATE_FREQ_BAUD = 10
        --      921600: RATE_FREQ_BAUD = 5
    --);
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        rx          : in std_logic;
        data_out    : out std_logic_vector(7 downto 0);
        data_av     : out std_logic;
		data_in		: in std_logic_vector(31 downto 0);
		ce_RFD		: in std_logic
    );
end UART_RX;

architecture behavioral of UART_RX is

     signal RATE_FREQ_BAUD  : integer;
     
     --signal clkCounter: integer range 0 to RATE_FREQ_BAUD;
     signal clkCounter: integer range 0 to 520;
     signal bitCounter: integer range 0 to 8;
     signal sampling: std_logic;
         
     type State is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
     signal currentState: State;
     
     signal rx_data: std_logic_vector(7 downto 0);
     
begin

    -- Register RATE FREQUENCY BAUD
    process(clk,rst)
        begin
            if rst = '1' then
                RATE_FREQ_BAUD <= 520;
             elsif rising_edge(clk) then
                if ce_RFD = '1' then
                   RATE_FREQ_BAUD <= TO_INTEGER(UNSIGNED(data_in));
                end if;
             end if;
     end process;


    process(clk,rst)
    begin
        if rst = '1' then
            clkCounter <= 0;
         elsif rising_edge(clk) then
            if currentState /= IDLE then
                if clkCounter = RATE_FREQ_BAUD-1 then
                    clkCounter <= 0;
                else
                    clkCounter <= clkCounter + 1;
                end if;
            else
                clkCounter <= 0;
            end if;
         end if;
    end process;

    data_out <= rx_data;
    
    sampling <= '1' when clkCounter = RATE_FREQ_BAUD/2 else '0';  
    
    process(clk,rst)
    begin
        if rst = '1' then
            bitCounter <= 0;
            rx_data <= (others=>'0');
            currentState <= IDLE;
        
        elsif rising_edge(clk) then
            case currentState is
                when IDLE =>
                    bitCounter <= 0;
                    if rx = '0' then
                        currentState <= START_BIT;
                    else
                        currentState <= IDLE;
                    end if;
                    
                when START_BIT =>
                    if sampling = '1' then
                        currentState <= DATA_BITS;
                    else
                        currentState <= START_BIT;
                    end if;                    
                        
                when DATA_BITS =>
                    if bitCounter = 8 then
                        currentState <= STOP_BIT;
                    elsif sampling = '1' then           
                        rx_data <= rx & rx_data(7 downto 1);
                        bitCounter <= bitCounter + 1;
                        currentState <= DATA_BITS;
                    else
                        currentState <= DATA_BITS;
                    end if;
                    
                when STOP_BIT =>
                    if rx = '1' and sampling = '1' then
                        currentState <= IDLE;
                    else
                        currentState <= STOP_BIT;
                    end if;
                                      
            end case;
        end if;
    end process;
    
    data_av <= sampling when currentState = STOP_BIT else '0';
    
end behavioral;