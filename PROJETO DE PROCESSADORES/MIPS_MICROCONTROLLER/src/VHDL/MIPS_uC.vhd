-------------------------------------------------------------------------
-- Design unit: MIPS multicycle
-- Description: Control and data paths port map
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_pkg.all;

entity MIPS_uC is
    port ( 
		board_clock, board_reset	: in std_logic;
		reset_bootloader			: in std_logic;
		
		prog : in std_logic_vector(1 downto 0);
		
		port_io : inout std_logic_vector(15 downto 0);
		
		tx	: out std_logic;
		rx	: in std_logic;
		
		led : out std_logic_vector(1 downto 0)
    );
end MIPS_uC;

architecture structural of MIPS_uC is
	
	--Implementation signals
	signal fp1_q, reset, reset_mips, clk_25, clk_50, clk_10, clk_5: std_logic;
	
	signal intr : std_logic;
	signal irq 	: std_logic_vector(15 downto 0);
	
    signal ce_data_mem, ce_data, ce_ins, wr, clk_n, CE_IO: std_logic;
    signal wbe: std_logic_vector(3 downto 0);
    signal instructionAddress, dataAddress, instruction, data_i, data_o : std_logic_vector(31 downto 0);
    
	constant PC_START_ADDRESS : std_logic_vector(31 downto 0) := x"00003000";

	signal data_o_io : std_logic_vector(15 downto 0);
	signal data_o_io_ext, data_i_mips, data_IC_ext : std_logic_vector(31 downto 0);
	
    signal data_IC, irq_ext : std_logic_vector (7 downto 0);
	signal irq_ID           : std_logic_vector (1 downto 0);
	signal ce_IC, rw_IC     : std_logic;

	--Uart Signals	
	signal ready, data_av_tx, ce_pulse, ce_RFD, data_av_rx : std_logic;
	signal ready_ext : std_logic_vector(31 downto 0);
	signal data_out_rx_ext, data_in_reg : std_logic_vector(31 downto 0);
	signal data_out_rx : std_logic_vector(7 downto 0);
		
	-- Bootloader Signals
	signal data_o_boot, boot_address : std_logic_vector(31 downto 0);
	signal ce_bootloader, ready_boot, i_d : std_logic;
	
	signal data_i_mem_dados, data_i_mem_ins : std_logic_vector(31 downto 0);
	signal wr_mem_ins, wr_mem_data : std_logic;
	signal ce_ins_mem : std_logic;
	signal address_mem_inst, address_mem_dados : std_logic_vector(29 downto 0);
	
	signal ce_timer, time_out, rst_timer : std_logic;
	signal data_timer : std_logic_vector(31 downto 0);
	
	
begin

	CLOCK_MANAGER: entity work.ClockManager(xilinx)
		port map (
			clk_100MHz          => board_clock,
			-- Clock out ports
			clk_50MHz           => clk_50,
			clk_25MHz           => clk_25,
			clk_10MHz           => clk_10,
			clk_5MHz            => clk_5
		);
		
	FLIP_FLOP1: entity work.Flip_flop(behavioral)
		port map (
			clock	=> clk_5,
			d		=> board_reset,
			q		=> fp1_q
		);         
	
	FLIP_FLOP2: entity work.Flip_flop(behavioral)
		port map (
			clock	=> clk_5,
			d		=> fp1_q,
			q		=> reset
		);  

    
					  
    MIPS_MULTICYCLE: entity work.MIPS_MultiCycle(structural)
        generic map (
            PC_START_ADDRESS => TO_INTEGER(UNSIGNED(PC_START_ADDRESS))
        )
        port map (
            clock		        => clk_5,
            reset               => reset_mips,     

            --Interrupt Pin interface
            intr				=> intr,

            -- Instruction memory interface
            instructionAddress  => instructionAddress,    
            instruction         => instruction,
            ce_ins              => ce_ins,           
                 
            -- Data memory interface
            dataAddress         => dataAddress,
            data_i              => data_i_mips,
            data_o              => data_o,
            wbe                 => wbe,
            ce_data             => ce_data
        );

    reset_mips <= '1' when reset = '1' or prog(1) = '1' or prog(0) = '1' else '0';

    --Signal do dado de saida do device I/O (dado de 16 bits concatenado com zeros para virar 32)
    data_o_io_ext <= x"0000" & data_o_io;

--Interface da entrada de dados do MIPS, que recebe ora o dado da memoria ora o dado de I/O
    data_i_mips <= data_i          when dataAddress (31 downto 28) = "0000" else
                   data_o_io_ext   when dataAddress (31 downto 28) = "0001" else
                   data_IC_ext     when dataAddress (31 downto 28) = "0010" else
                   data_out_rx_ext when dataAddress (31 downto 28) = "0100" else
                   data_timer      when dataAddress (31 downto 28) = "0101" else
                   ready_ext;
	
	
    
	clk_n <= not clk_5;
	 
	INSTRUCTION_MEMORY: entity work.Memory(BlockRAM)
        generic map (
            SIZE            => 726,             -- Memory depth
            --SIZE            => 1024,            -- Tamanho para sintese
            imageFileName   => "instrucoes.txt",
            OFFSET          => UNSIGNED(PC_START_ADDRESS)
        )
        port map (
            clock           => clk_n,
            reset			=> board_reset,
            ce              => ce_ins_mem,
            wr              => wr_mem_ins,
            address         => address_mem_inst, -- Converts byte address to word address  
            data_i          => data_i_mem_ins,
            data_o          => instruction
        );
    
    --Signals da memoria de instrucoes
    address_mem_inst <= boot_address(31 downto 2) when ce_bootloader = '1' else
                        instructionAddress(31 downto 2);

    wr_mem_ins <= (not prog(1) and prog(0)) and ready_boot;	    --Signal que controla escrita na memoria de instrucoes
    ce_ins_mem <= wr_mem_ins when ce_bootloader = '1' else ce_ins;

    data_i_mem_ins <= data_o_boot when wr_mem_ins = '1' else data_o; --Mem_Inst <= Dados do RX qnd switch's = 10 se nao recebe do MIPS
                      
		    
   
    DATA_MEMORY: entity work.Memory(BlockRAM)
        generic map (
            SIZE            => 1024,             -- Memory depth
            imageFileName   => "dados.txt",
            OFFSET          => x"00000000"		-- Data start address on MARS
        )
        port map (
            clock           => clk_n,
            reset           => board_reset,
            ce              => ce_data_mem,
            wr              => wr_mem_data,
            address         => address_mem_dados, -- Converts byte address to word address     
            data_i          => data_i_mem_dados,
            data_o          => data_i
        );
        
    --Signals da memoria de dados 
    wr <= wbe(3) and wbe(2) and wbe(1) and wbe(0);
    
    address_mem_dados <= boot_address(31 downto 2) when ce_bootloader = '1' else
                          dataAddress(31 downto 2);
    
    wr_mem_data <= wr or (i_d and ready_boot);			--Signal que controla escrita na memoria de instrucoes
    ce_data_mem <=  ((not dataAddress(31)) and (not dataAddress(30)) and (not dataAddress(29))and (not dataAddress(28)) and ce_data) or (i_d and ready_boot);
    
	
    data_i_mem_dados <= data_o_boot when ce_bootloader = '1' else  --Mem_Dados <= Dados do RX qnd switch's = 01 se nao recebe do MIPS
                        data_o;
		
    IO_PORT: entity work.BidirectionalPort(Behavioral)
        generic map (
            DATA_WIDTH          => 16,
            PORT_DATA_ADDR      => "10",
            PORT_CONFIG_ADDR    => "01",
            PORT_ENABLE_ADDR    => "00",
            IRQ_ENABLE_ADDR     => "11"
        )
        port map (
            clk          => clk_5,
            rst			 => reset,
            
            irq			 => irq,
            
            data_i		 => data_o(15 downto 0),
            data_o		 => data_o_io,
            address		 => dataAddress(1 downto 0),
            rw			 => wr,
            ce           => CE_IO,
            
            port_io      => port_io
        );
    
    --Chip Enable do device I/O 
    CE_IO <= not(dataAddress(31)) and not(dataAddress(30)) and not(dataAddress(29)) and dataAddress(28) and wr;		
		
    INTERRUPT_CONTROLLER: entity work.InterruptController(Behavioral)
        generic map (
            IRQ_ID_ADDR     => "00",
            INT_ACK_ADDR    => "01",
            MASK_ADDR       => "10"
        )
        port map (
            clk         => clk_5,
            rst         => reset, 

            data        => data_IC,
            address     => dataAddress(1 downto 0),
            rw          => wr,
            ce          => ce_IC,
            intr        => intr,
            irq         => irq_ext
        );
        
    -- Bits de interrupcao para o PIC
    irq_ext <= irq(15 downto 12) & "00" & data_av_rx & time_out; 

    -- Chip Enable do PIC
    ce_IC <= '1' when dataAddress(31 downto 28) = "0010" and ce_data = '1' else '0';

    -- Extende o signal para entrar no barramento data_i do MIPS
    data_IC_ext  <= x"000000" & data_IC;

    -- Barramento de dados do PIC
    data_IC <= data_o(7 downto 0) when wr = '1' and ce_IC = '1' else (others=>'Z');
		
        
        
    UART_TX0: entity work.UART_TX(Behavioral)
        port map (
            clk         => clk_5,
            rst         => reset,

            tx			=> tx,
            data_in   	=> data_o(7 downto 0),
            data_av    	=> data_av_tx,
            ready		=> ready,
            data_in_reg	=> data_o(31 downto 0),
            ce_RFD		=> ce_RFD
        );

    --Signals TX
    ready_ext <= "0000000000000000000000000000000" & ready;
    
    PULSE_DATA: entity work.Pulse(Behavioral)
        port map (
            clock       => clk_5,
            ce			=> ce_pulse,
            d           => data_o(8),
            q           => data_av_tx
        );
    
    --Signals PULSE
    ce_pulse <= not(dataAddress(31)) and not(dataAddress(30)) and (dataAddress(29)) and dataAddress(28) and wr; -- 1 quando adress 0011 e for sw


    UART_RX0: entity work.UART_RX(Behavioral)
        port map (
            clk         => clk_5,
            rst         => reset,

            rx			=> rx,

            data_out   	=> data_out_rx,
            data_av    	=> data_av_rx,
            data_in		=> data_o(31 downto 0),
            ce_RFD		=> ce_RFD
        );
    
    --Signals RX
    ce_RFD <= not(dataAddress(31)) and (dataAddress(30)) and not((dataAddress(29))) and not(dataAddress(28)) and wr;
        
    data_out_rx_ext <= x"000000" & data_out_rx;
		
        
        
    BOOTLOADER: entity work.Bootloader(Behavioral)
        port map (
            clk             => clk_5,
            rst             => reset_bootloader,
            ce              => ce_bootloader,
            i_d             => i_d,
            data_av         => data_av_rx,
            ready           => ready_boot,
            data_in         => data_out_rx,
            data_out        => data_o_boot,
            address         => boot_address
        );
	
    ce_bootloader <= prog(1) xor prog(0);
    i_d <= prog(1) and (not prog(0));
    led(0) <= '1' when boot_address = x"00003000" else '0';
    led(1) <= '1' when boot_address = x"00000000" else '0';
    
    
    TIMER: entity work.Timer(Behavioral)
        generic map (
            DATA_WIDTH      => 32
        )
        port map (
            clk             => clk_5,
            rst             => rst_timer,
            data            => data_timer,
            rw              => wr,
            ce              => ce_timer,
            time_out        => time_out
        );
    
    -- Barramento de dados do PIC
    data_timer <= data_o when wr = '1' and ce_timer = '1' else (others=>'Z');
    ce_timer  <= '1' when dataAddress(31 downto 28) = "0101" and dataAddress(1 downto 0) = "00" else '0';
    rst_timer <= '1' when dataAddress(31 downto 28) = "0101" and dataAddress(1 downto 0) = "01" else reset;
    
end structural;
