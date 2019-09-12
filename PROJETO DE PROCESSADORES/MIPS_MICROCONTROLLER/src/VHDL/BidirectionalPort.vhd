library IEEE;
use IEEE.std_logic_1164.all;

entity BidirectionalPort  is
    generic (
        DATA_WIDTH          : integer;    -- Port width in bits
        PORT_DATA_ADDR      : std_logic_vector(1 downto 0);     -- NÃO ALTERAR!
        PORT_CONFIG_ADDR    : std_logic_vector(1 downto 0);     -- NÃO ALTERAR! 
        PORT_ENABLE_ADDR    : std_logic_vector(1 downto 0);      -- NÃO ALTERAR!
		IRQ_ENABLE_ADDR	    : std_logic_vector(1 downto 0)      -- NÃO ALTERAR!
    );
    port (  
        clk         : in std_logic;
        rst         : in std_logic; 
        
		irq			: out std_logic_vector(15 downto 0);
		
        -- Processor interface
        data_i      : in std_logic_vector (DATA_WIDTH-1 downto 0);
        data_o      : out std_logic_vector (DATA_WIDTH-1 downto 0);
        address     : in std_logic_vector (1 downto 0);     -- NÃO ALTERAR!
        rw          : in std_logic; -- 0: read; 1: write
        ce          : in std_logic;
		
        -- External interface
        port_io     : inout std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end BidirectionalPort ;


architecture Behavioral of BidirectionalPort  is

signal PE_q, PC_q, PD_q, PD_d, SE1_q, SE2_q, Sinal_io, IRQ_q, PD_en : std_logic_vector (15 downto 0);
signal PE_en, PC_en, IRQ_en : std_logic;



begin
	
--Signal de enable para o register, somente quando for o endere�o dele e o chip enable tiver em 1			
	PE_en <= (not (address(1))) and (not(address(0))) and ce;
	
-- Port Enable register
    PORT_ENABLE: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => PE_en, 
            d           => data_i, 
            q           => PE_q
        );

--Signal de enable para o register, somente quando for o endere�o dele e o chip enable tiver em 1		
PC_en <= (not(address(1))) and address(0) and ce;

-- Port Config register
    PORT_CONFIG: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => PC_en, 
            d           => data_i, 
            q           => PC_q
        );	
	
	
    --Signal de enable para o register, somente quando for o endere�o dele e o chip enable tiver em 1		
    --PD_en <= (address(1)) and (not(address(0))) and ce;	
    --PD_en <= ( (address(1)) and (not(address(0))) and ce) or (port_io(15) or port_io(14) or port_io(13) or port_io(12));	


    ENABLE_PORT_DATA: for i in 0 to 15 generate
        PD_en(i) <= ((address(1) and (not(address(0))) and ce) xor PC_q(i));
    end generate;


-- Port Data register
    PORT_DATA: entity work.Register_n_bits_mult_ces(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => PD_en,
            d           => PD_d, 
            q           => PD_q
        );		

		
    --Signal de enable para o register, somente quando for o endere诠dele e o chip enable tiver em 1		
    IRQ_en <= (address(1)) and (address(0)) and ce;	
		
    -- IRQ Enable Register
    IRQ_ENABLE: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => IRQ_en, 
            d           => data_i,  
            q           => IRQ_q
        );				

		
    -- Sinc Ext register 1
    SINC_EXT1: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => '1', 
            d           => port_io, 
            q           => SE1_q
        );		
		
    -- Sinc Ext register 2
    SINC_EXT2: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 16
        )
        port map (
            clock       => clk,
            reset       => rst,
            ce          => '1', 
            d           => SE1_q,  
            q           => SE2_q
        );		
		
		

    --Mux Data Out que vai Para o MIPS (Data In)		
    MUX_DATAOUT: data_o <=  PE_q when address = "00" else 
                            PC_q when address = "01" else 
                            PD_q when address = "10" else 
                            IRQ_q;


    --Tratamento do MUX Data
    MUX_DATA: for i in 0 to 15 generate
        PD_d(i)<= data_i(i) when Sinal_io(i) = '1' else SE2_q(i);
    end generate;


    --Tratamento do Sinal do MUX e do Tri State (Saida da AND)
    SIGNAL_MUX_TS: for i in 0 to 15 generate
        Sinal_io(i) <= (not (PC_q(i))) and PE_q(i);
    end generate;


    -- Tratamento efetivo da porta
    PORTA_IO: for i in 0 to 15 generate
        port_io(i) <=  PD_q(i) when Sinal_io(i) = '1' else 'Z';
    end generate;
            
    -- Tratamento da interrupção bit a bit
    IRQ_AND: for i in 0 to 15 generate
        irq(i) <=  IRQ_q(i) and PE_q(i) and PC_q(i) and PD_q(i);
    end generate;
				
		
end Behavioral;