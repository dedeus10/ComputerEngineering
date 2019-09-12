-------------------------------------------------------------------------
-- Design unit: MIPS package
-- Description:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package MIPS_pkg is  
        
    -- Instruction_type defines the instructions decodable by the control unit
    type Instruction_type is (ADDU, SUBU, AAND, OOR, SW, LW, ADDIU, ORI, SLT, SLTU, BEQ, J, LUI, BNE, XXOR, XORI, NNOR, ANDI, SLLL, SRLL, SLLV, SRLV, BGEZ, SLTI, SLTIU, BLEZ, JAL, JALR, JR, BLTZ, BGTZ, ERET, MULTU, DIVU, MFHI, MFLO, MTCO, ADDI, ADD, SUB, SYSCALL, MFCO, INVALID_INSTRUCTION);
    
    -- ALU_Operation defines the ALU operations
    type ALU_Operation is (ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_SLT, ALU_SLTU, ALU_LUI, ALU_XOR, ALU_NOR, ALU_SLL, ALU_SRL, ALU_SLTI, ALU_SLTIU, ALU_MUL, ALU_DIV, ALU_MOD, ALU_Bus_A, ALU_Bus_B );
 
    -- Control signals to data path
    type Microinstruction is record
        PCWriteCond : std_logic;
        PCWrite     : std_logic;
        IRWrite     : std_logic;
        PCSource    : std_logic_vector(2 downto 0);
        RegWrite    : std_logic;        
        ALUop       : ALU_Operation;
        ALUSrcB     : std_logic_vector(2 downto 0);        
        ALUSrcA     : std_logic_vector(1 downto 0);
		Overflow	: std_logic;
		Div_zero	: std_logic;
        RegDst      : std_logic_vector(1 downto 0);        
        MemToReg    : std_logic_vector(2 downto 0);
		mux_brcCTRL	: std_logic_vector(2 downto 0);
		EPC_Write	: std_logic;
		hi_en		: std_logic;
		mux_hi		: std_logic;
		lo_en		: std_logic;
		isrAd_en	: std_logic;
		esrAd_en	: std_logic;
		cause_en	: std_logic;
		cause_mux	: std_logic_vector(1 downto 0);
        Instruction : Instruction_type; -- Decoded instruction        
        
        -- Memory control
        ce_ins      : std_logic;        -- Instruction memory chip enable
        ce_data     : std_logic;        -- Data memory chip enable
        MemWrite    : std_logic;        -- Data memory write access      
    end record;
                
end MIPS_pkg;


