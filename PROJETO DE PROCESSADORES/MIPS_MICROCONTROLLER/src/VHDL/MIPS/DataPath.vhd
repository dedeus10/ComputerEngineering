--------------------------------------------------------------------------
-- Design unit: Data path                                               --
-- Description: MIPS data path supporting ADDU, SUBU, AND, OR, LW, SW,  --
--  ADDIU, ORI, SLT, SLTU, BEQ, J, LUI instructions                     --
--------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.MIPS_pkg.all;

entity DataPath is
    generic (
        PC_START_ADDRESS    : integer := 0  -- PC initial value (first instruction address)
    );
    port (  
        clock               : in  std_logic; 
        reset               : in  std_logic; 
        
        -- Instruction memory interface
        instructionAddress  : out std_logic_vector(31 downto 0);  -- Instruction memory address bus
        instruction         : in  std_logic_vector(31 downto 0);  -- Data bus from instruction memory
        
        -- Data memory interface
        dataAddress         : out std_logic_vector(31 downto 0);  -- Data memory address bus
        data_i              : in  std_logic_vector(31 downto 0);  -- Data bus from data memory
        data_o              : out std_logic_vector(31 downto 0);  -- Data bus to data memory
        
        -- Control path interface
        uins                : in  Microinstruction;               -- Control path microinstruction (control signals)
        IR                  : out std_logic_vector(31 downto 0);   -- Instruction register to control path
		overflow			: out std_logic;
		div_zero			: out std_logic
		
    );
end DataPath;


architecture structural of DataPath is

    ----------------------------------------------
    -- Internal nets to interconnect components --
    ----------------------------------------------
    
    -- Registers signals
    signal PC_q, PC_d, MDR_q, MDR_d, IR_q, A_q, B_q: std_logic_vector(31 downto 0);
	signal ALUOut_q: std_logic_vector(63 downto 0);
    signal writePC: std_logic;
	
	signal EPC_q: std_logic_vector(31 downto 0);
    
    -- Register file signals
    signal readData1, readData2, writeData  : std_logic_vector(31 downto 0);
    signal writeRegister                    : std_logic_vector(4 downto 0);
    
    -- ALU signals
    signal ALUOperand1, ALUoperand2 : std_logic_vector(31 downto 0);
	signal result : std_logic_vector(63 downto 0);
    signal zero: std_logic;
	signal flag_n: std_logic;
    signal mux_branch_q: std_logic;
	
    -- Bit extension
    signal signExtended, zeroExtend: std_logic_vector(31 downto 0);

	-- Shift Count
	signal shiftCount: std_logic_vector(31 downto 0);
    
    -- Branch/jump signals
    signal branchOffset, jumpTarget: std_logic_vector(31 downto 0);
    
    ----------------------------------
    -- Instruction register aliases --
    ----------------------------------
    -- Retrieves the rs field from the instruction
    alias rs: std_logic_vector(4 downto 0) is IR_q(25 downto 21);
        
    -- Retrieves the rt field from the instruction
    alias rt: std_logic_vector(4 downto 0) is IR_q(20 downto 16);
        
    -- Retrieves the rd field from the instruction
    alias rd: std_logic_vector(4 downto 0) is IR_q(15 downto 11);

	signal hi_d, hi_q, lo_q, isrAd_q, esrAd_q: std_logic_vector(31 downto 0);
	
	signal cause_d, cause_q : std_logic_vector(31 downto 0);
	
begin


    -- PC_q register
    PROGRAM_COUNTER: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => writePC, 
            d           => PC_d, 
            q           => PC_q
        );
     
    -- Write PC logic
    writePC <= (mux_branch_q and uins.PCWriteCond) or uins.PCWrite;
        
    -- Instruction memory is addressed by the PC register
    instructionAddress <= PC_q;
     
    -- Multiplexer at PC input
    MUX_PC: PC_d <= result(31 downto 0) when uins.PCSource = "000" else   -- PC++
                    ALUOut_q (31 downto 0) when uins.PCSource = "001" else -- Branch
					EPC_q when uins.PCSource = "011" else -- ERET return
					isrAd_q when uins.PCSource = "100" else -- Inicio interrupt
					esrAd_q when uins.PCSource = "101" else -- Inicio Exceção
                    jumpTarget; -- Jump
     
     
     -- Instruction register
     INSTRUCTION_REGISTER: entity work.Register_n_bits(behavioral)
        generic map (
            LENGTH      => 32
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => uins.IRWrite, 
            d           => instruction, -- Data coming from instruction memory
            q           => IR_q
        );
    
    -- Connects the instruction register to control path for instruction decoding
    IR <= IR_q;
    
    
    
    
    -- Stores data coming from the data memory on load instructions
    MEMORY_DATA_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => data_i, -- Data coming from data memory
            q           => MDR_q
        );
       
       
       

       
    -- Registers File
    REGISTER_FILE: entity work.RegisterFile(structural)
        port map (
            clock           => clock,
            reset           => reset,            
            write           => uins.RegWrite,            
            readRegister1   => rs,    
            readRegister2   => rt,
            writeRegister   => writeRegister,
            writeData       => writeData,          
            readData1       => readData1,        
            readData2       => readData2
        );
        
    -- Multiplexers at register file inputs
    -- Selects the instruction field witch contains the register to be written 
    MUX_WRITE_REGISTER: writeRegister <= rt when uins.regDst = "00" else
										 "11111" when uins.regDst = "10"	--ra (reg 31)
										 else rd;
    
    -- Selects the data source to be written to register file (MDR or ALUout)
    MUX_WRITE_DATA: writeData <= ALUOut_q(31 downto 0) when uins.memToReg = "000" else
								 PC_q when uins.memToReg = "010" else
								 hi_q when uins.memToReg = "011" else
								 lo_q when uins.memToReg = "100" else
								 cause_q when uins.memToReg = "101" else
                                 EPC_q when uins.memToReg = "110" else
								 MDR_q;  
        
       
    -- Register at register file readData1 output
    A_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => readData1, 
            q           => A_q
        );
	   
	   
       
    -- Register at register file readData2 output  
    B_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => readData2, 
            q           => B_q
        );
       
	   
       
	   -- Register hi for mul div 
    HI_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.hi_en, 
            d           => hi_d, 
            q           => hi_q
        );
       
    hi_d <= ALUOut_q(31 downto 0) when uins.mux_hi = '1' else ALUOut_q(63 downto 32);
	   
       
       
	   -- Register lo for mul div 
    LO_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.lo_en, 
            d           => ALUOut_q(31 downto 0), 
            q           => lo_q
        );
	   
       
    
	   -- Register EPC for interrupt
    EPC_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.EPC_Write, 
            d           => ALUOut_q(31 downto 0),
            q           => EPC_q
        );


        
	   -- Register ISR AD guarda endereço da sub-rotina de interupção
    ISR_AD_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.isrAd_en, 
            d           => ALUOut_q(31 downto 0), 
            q           => isrAd_q
        );
	   
       
       
	      -- Register ESR AD guarda endereço da sub-rotina de exceção
    ESR_AD_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.esrAd_en, 
            d           => ALUOut_q(31 downto 0), 
            q           => esrAd_q
        );
	   
       
       
	         -- Register CAUSE guarda endereço da sub-rotina de exceção
    CAUSE_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 32
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => uins.cause_en, 
            d           => cause_d, 
            q           => cause_q
        );
	   
    cause_d <= x"00000001" when uins.cause_mux = "00" else 
               x"00000008" when uins.cause_mux = "01" else
               x"0000000c" when uins.cause_mux = "10" else
               x"0000000f";
	   
		
        
        
        
    -- Data to be written on data memory when executing store came from register B
    data_o <= B_q;
       
       
    -- Sign extends the instruction register low word (15:0)
    SIGN_EXTEND: signExtended <= x"FFFF" & IR_q(15 downto 0) when IR_q(15) = '1' else -- usa os bits (15 downto 0) da instruo
                                 x"0000" & IR_q(15 downto 0);
  
    ZERO_EXTEND: zeroExtend <= x"0000" & IR_q(15 downto 0);
    
    -- Converts the branch offset from words to bytes (multiply by 4) in order to add with PC_q
    SHIFT_LEFT_2: branchOffset <= signExtended(29 downto 0) & "00";
    
    -- Generates the jump target address
    JUMP_ADDRESS: jumpTarget <= PC_q(31 downto 28) & IR_q(25 downto 0) & "00";
	
	-- Shift Count
	SHIFT_COUNT: shiftCount <= x"000000" & "000" & IR_q(10 downto 6);

       
       
    -- Arithmetic/Logic Unit
    ALU: entity work.ALU(behavioral)
        port map (
            operand1    => ALUOperand1,
            operand2    => ALUoperand2,
            result      => result,
            zero        => zero,
			flag_n      => flag_n,
            operation   => uins.ALUop,
			overflow	=> overflow,
			div_zero	=> div_zero
        );   
    
		
    -- Multiplexers at ALU inputs
    MUX_ALU1: ALUOperand1 <= PC_q 		  when uins.ALUSrcA = "00" else -- PC++
							 shiftCount   when uins.ALUSrcA = "10" else -- SLL, SRL
							 A_q;
    
    MUX_ALU2: ALUoperand2 <= B_q 		  when uins.ALUSrcB = "000" else   
                             x"00000004"  when uins.ALUSrcB = "001" else -- constant 4
                             signExtended when uins.ALUSrcB = "010" else -- Instruction low word (15:0) sign extended
                             zeroExtend   when uins.ALUSrcB = "100" else -- Instruction low word (15:0) zero extended
							 x"00000000"  when uins.ALUSrcB = "101" else -- BGEZ
                             branchOffset; 
    
    -- Register at the ALU result output
    ALUOut_REGISTER: entity work.Register_n_bits(behavioral)
        generic map(
            LENGTH      => 64
        )
        port map(
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => result, 
            q           => ALUOut_q
        );
       
    -- The ALUOut register address the data memory
    dataAddress <= ALUOut_q(31 downto 0);
           
	MUX_branch: mux_branch_q <= zero when uins.mux_brcCTRL = "000" else
								(not zero) when uins.mux_brcCTRL = "001" else
								(not flag_n) when uins.mux_brcCTRL = "010" else
								flag_n when uins.mux_brcCTRL  = "011" else
								(zero or flag_n) when uins.mux_brcCTRL = "100" else
								((not zero) and (not flag_n)) when uins.mux_brcCTRL = "101" else
								'0';

end structural;