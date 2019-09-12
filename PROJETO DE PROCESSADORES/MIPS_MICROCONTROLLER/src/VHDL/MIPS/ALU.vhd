-------------------------------------------------------------------------
-- Design unit: ALU
-- Description: Logic and Arithmetic Unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all; 
use work.MIPS_pkg.all;

entity ALU is
    port( 
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(63 downto 0);
        zero        : out std_logic;
		flag_n      : out std_logic;
        overflow    : out std_logic;
		div_zero 	: out std_logic;
        operation   : in ALU_Operation
    );
end ALU;

architecture behavioral of ALU is
    signal op1, op2, temp: SIGNED(31 downto 0);
	signal res_mul: SIGNED(63 downto 0);
begin

    op1 <= SIGNED(operand1);
    op2 <= SIGNED(operand2);
    
    result <= STD_LOGIC_VECTOR(res_mul) when operation = ALU_MUL else -- Instructions: MULTU
              (x"00000000" & STD_LOGIC_VECTOR(temp)); 
        
    temp <= op1 - op2       when operation = ALU_SUB else -- Instructions: SUBU, BEQ, BNE
            op1 and op2     when operation = ALU_AND else -- Instructions: AND, ANDI
            op1 or op2      when operation = ALU_OR  else -- Instructions: OR, ORI
			op1 xor op2		when operation = ALU_XOR else -- Instructions: XOR, XORI
			op1 nor op2		when operation = ALU_NOR else -- Instructions: NOR
			Shift_Left(op2, (TO_INTEGER(UNSIGNED(op1))))  when operation = ALU_SLL else -- Instructions: SLL
			Shift_Right(op2, (TO_INTEGER(UNSIGNED(op1)))) when operation = ALU_SRL else -- Instructions: SRL
            x"00000001"     when (operation = ALU_SLT and op1 < op2) or (operation = ALU_SLTU and UNSIGNED(op1) < UNSIGNED(op2)) or (operation = ALU_SLTI and op1 < op2) or (operation = ALU_SLTIU and UNSIGNED(op1) < UNSIGNED(op2))else -- Instructions: SLT, SLTU, SLTI, SLTIU(true)
            x"00000000"     when (operation = ALU_SLT and not(op1 < op2)) or (operation = ALU_SLTU and not(UNSIGNED(op1) < UNSIGNED(op2))) or (operation = ALU_SLTI and not(op1 < op2)) or (operation = ALU_SLTIU and not(UNSIGNED(op1) < UNSIGNED(op2))) else -- Instructions: SLT, SLTU, SLTI, SLTIU (false)
            op2(15 downto 0) & x"0000" when operation = ALU_LUI else -- Instructions: LUI
			op1 when operation = ALU_Bus_A else -- Instructions: BGEZ | BLEZ | BLTZ | BGTZ 
			op2 when operation = ALU_Bus_B else -- Instructions: MTCO
			op1 / op2		when operation = ALU_DIV and (op2 /= x"00000000") else -- Instructions: DIVU
			op1 mod op2		when operation = ALU_MOD and (op2 /= x"00000000") else -- Instructions: DIVU
            op1 + op2;  -- Instructions: ADDU, ADDIU, LW, SW and PC++
    
    res_mul <= op1 * op2;

    -- Generates the zero flag
    zero <= '1' when temp = 0 else '0';
	
	--Generate the negative flag
	flag_n <= '1' when temp < 0 else '0';
    
	overflow <= '1' when ((temp(31) = '1' and op1(31) = '0' and op2(31) = '0' and operation = ALU_ADD) or	--Esperado positivo 
						  (temp(31) = '0' and op1(31) = '1' and op2(31) = '1' and operation = ALU_ADD) or	--Esperado negativo
						  (temp(31) = '1' and op1(31) = '0' and op2(31) = '1' and operation = ALU_SUB) or	--Esperado positivo
						  (temp(31) = '0' and op1(31) = '1' and op2(31) = '0' and operation = ALU_SUB)) else '0';		--Esperado negativo
						  
	div_zero <= '1' when (op2 = x"00000000"  and (operation = ALU_DIV or operation = ALU_MOD)) else '0';
    
end behavioral;