------------------------------------------------------------------------------
-- Design unit: Control path (FSM implmentation)                            --
-- Description: MIPS control path supporting:

-- ADDU, SUBU, AAND, OOR, SLT, SLTU ,XXOR
--NNOR, SLLL, SRLL, JALR, JR, LUI, BGEZ
--BLTZ, BGTZ, J, JAL, BEQ, BNE, BLEZ
--ADDIU, SLTI, SLTIU, ANDI, ORI, XORI
--SW, LW, ERET, MULTU, DIVU, MFHI ,MFLO
--MTCO, ADDI instructions
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_pkg.all;

entity ControlPath is
    port (  
        clock           : in std_logic;
        reset           : in std_logic;
        instruction     : in std_logic_vector(31 downto 0); -- Instruction stored on instruction register (data path)
        uins            : out microinstruction;				-- Control signals to data path and memory
		intr			: in std_logic;
		overflow		: in std_logic;
		div_zero		: in std_logic
		
    );
end ControlPath;
                   

architecture behavioral of ControlPath is

    -- Alias to identify the instructions based on the 'opcode' and 'funct' fields
    alias  opcode: std_logic_vector(5 downto 0) is instruction(31 downto 26);
    alias  funct: std_logic_vector(5 downto 0) is instruction(5 downto 0);
    
    -- Retrieves the rs field from the instruction
    alias rs: std_logic_vector(4 downto 0) is instruction(25 downto 21);
	
	-- Retrieves the rt field from the instruction
    alias rt: std_logic_vector(4 downto 0) is instruction(20 downto 16);
	
	-- Retrieves the rd field from the instruction
    alias rd: std_logic_vector(4 downto 0) is instruction(15 downto 11);
	--alias BCD_Enable: std_logic is Adresss(31);
    
    -- FSM states
    type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, INVALID_INSTRUCTION);
    signal currentState, nextState: State;
    signal decodedInstruction: Instruction_type;

    --Signal register flag para controle de interrupções
    --signal int_flag_en : std_logic;
    --signal int_flag_d : std_logic_vector(1 downto 0);

    signal int_flag_q : std_logic_vector(1 downto 0);
    signal flag_exception : std_logic_vector(1 downto 0);

    
begin
    -- Instruction decode
    decodedInstruction <=   ADD	    when opcode = "000000" and funct = "100000" else
							ADDU    when opcode = "000000" and funct = "100001" else
							SUB	    when opcode = "000000" and funct = "100010" else
                            SUBU    when opcode = "000000" and funct = "100011" else
                            AAND    when opcode = "000000" and funct = "100100" else
                            OOR     when opcode = "000000" and funct = "100101" else
                            SLT     when opcode = "000000" and funct = "101010" else
                            SLTU    when opcode = "000000" and funct = "101011" else
							XXOR	when opcode = "000000" and funct = "100110" else
							NNOR	when opcode = "000000" and funct = "100111" else
							SLLL	when opcode = "000000" and funct = "000000" else
                            SLLV    when opcode = "000000" and funct = "000100" else
							SRLL	when opcode = "000000" and funct = "000010" else
                            SRLV    when opcode = "000000" and funct = "000110" else
							JALR	when opcode = "000000" and funct = "001001" else
							JR		when opcode = "000000" and funct = "001000" else
							LUI     when opcode = "001111" and rs = "00000" else
							BGEZ	when opcode = "000001" and rt = "00001" else
							BLTZ	when opcode = "000001" and rt = "00000" else
							BGTZ	when opcode = "000111" and rt = "00000" else
							J       when opcode = "000010" else
							JAL		when opcode = "000011" else
							BEQ     when opcode = "000100" else
							BNE		when opcode = "000101" else
							BLEZ	when opcode = "000110" else
							ADDIU   when opcode = "001001" else
							SLTI	when opcode = "001010" else
							SLTIU	when opcode = "001011" else
							ANDI	when opcode = "001100" else
							ORI     when opcode = "001101" else
							XORI	when opcode = "001110" else
                            SW      when opcode = "101011" else
                            LW      when opcode = "100011" else
							ERET	when opcode = "010000" and funct = "011000" else
							MULTU	when opcode = "000000" and funct = "011001" else
							DIVU	when opcode = "000000" and funct = "011011" else
							MFHI	when opcode = "000000" and funct = "010000" else
							MFLO	when opcode = "000000" and funct = "010010" else
							MTCO	when opcode = "010000" and rs 	 = "00100"  else
							MFCO	when opcode = "010000" and rs 	 = "00000" else
							ADDI	when opcode = "001000" else
							SYSCALL	when opcode = "000000" and funct = "001100" else
                            INVALID_INSTRUCTION ;    -- Invalid or not implemented instruction         
      
    uins.Instruction <= decodedInstruction;
    
    --------------------
    -- State register --
    --------------------
    STATE_REGISTER: process (clock, reset)
    begin
        if(reset = '1') then
            currentState <= S0;
        elsif rising_edge(clock) then
            currentState <= nextState;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Next State Logic                                                   --
    --      The next state depends on currentState and decodedInstruction --
    ------------------------------------------------------------------------
    --NEXT_STATE_LOGIC: process(currentState, decodedInstruction)
    --NEXT_STATE_LOGIC: process(currentState, decodedInstruction,  intr, int_flag_q, div_zero, overflow)
    NEXT_STATE_LOGIC: process(currentState, decodedInstruction,  intr, div_zero, overflow)
    begin
        case currentState is
            	
			-- Instruction fetch and PC++ 
            when S0 =>
				if (intr = '1' and  int_flag_q = "00") then
				--if (intr = '1') then
					nextState <= S22;	
					--int_flag_en <= '1';
					--int_flag_d <= "01";
                
				else
					nextState <= S1;
                    
                    -- Delay after interruption
                    --if (int_flag_q = "10") then
                        --int_flag_en <= '1';
						--int_flag_d <= "11";
                    --elsif (int_flag_q = "11") then
                        --int_flag_en <= '1';
						--int_flag_d <= "00";
                    --end if;
                    
				end if;
				
            -- Instruction decode, register file reading and branch target computation
            when S1 => 
                case decodedInstruction is  -- NextState depends on the decodedInstruction
                    when LW | SW =>
                        nextState <= S2;
                    
                    -- R-Type
                    when ADDU | AAND | OOR | SUBU | SLT | SLTU | XXOR | NNOR | MULTU | DIVU | MTCO | SLLV | SRLV | SUB | ADD  => 
                        nextState <= S6;
                    
					--Move to rd  (HI or LO )
					when MFHI | MFLO =>
						nextState <= S7;
					
                    -- I-Type (logic/arithmetic)
                    when ADDI |ADDIU | LUI => 
                        nextState <= S10;
                    
                    when ORI | XORI | ANDI  =>
                        nextState <= S11;
                    
                    when BEQ =>
                        nextState <= S8;
                    
                    when J =>
                        nextState <= S9;
						
					when BNE =>
						nextState <= S12;
						
					when BGEZ =>
						nextState <= S13;					
					
					when SLLL | SRLL =>
						nextstate <= S14;
						
					when SLTI | SLTIU =>
						nextstate <= S15;
						
					when BLEZ =>
						nextState <= S16;
						
					when BLTZ =>
						nextState <= S20;
					
					when BGTZ =>
						nextState <= S21;					
						
					when JALR =>
						nextState <= S17;
					
					when JAL =>
						nextState <= S18;
					
					when JR =>
						nextState <= S19;
						
					when ERET =>
						nextState <= S24;
						
					when SYSCALL =>
						nextState <= S29;	
						
					when MFCO =>
						nextState <= S30;
						
                    when others =>
                        --nextState <= INVALID_INSTRUCTION;
						nextState <= S29;
                end case;
            
            -- Load/store: memory address computation
            when S2 =>
                if decodedInstruction = LW then
                    nextState <= S3;
                else
                    nextState <= S5;
                end if;
            
            -- Load: Memory read
            when S3 =>
                nextState <= S4;            
            
            -- Logic/Arithmetic instructions execution
            when S6 | S10 | S11 | S14 | S15 =>
				if decodedInstruction =  MULTU then
					nextState <= S25;
				elsif decodedInstruction = DIVU then
					if (div_zero = '1') then
						nextState <= S29;
					else		
						nextState <= S26;	
					end if;
				elsif decodedInstruction = MTCO then
					nextState <= S28;
				else
					nextState <= S7;
				end if;	
			
            when S7 =>
                if ((decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB) and overflow = '1') then
					nextState <= S29;
                else
                    nextState <= S0;
                end if;
            
            when S17 =>
				nextState <= S19;
				
			when S18 =>
				nextState <= S9;
				
			when S22 =>
				nextState <= S23;
				
			when S24 =>
				nextState <= S0;	
				--int_flag_en <= '1';
                --int_flag_d <= "10";
				
			when S26 =>
				--nextState <= S27;	
                if (div_zero = '1') then
                    nextState <= S29;
                else		
                    nextState <= S27;
                end if;
                 
					
			when S29 =>
				nextState <= S31;		
            --when INVALID_INSTRUCTION =>
                --nextState <= INVALID_INSTRUCTION;
				
            when others =>
                nextState <= S0;
				--int_flag_en <= '0';
        end case;
    end process;
    
    ---------------------------------------------
    -- Control signals generation to data path --
    ---------------------------------------------
    
    -- Register file multiplexers
    uins.MemToReg <=   "001" when decodedInstruction = LW else -- RegisterFile.WriteData <- MDR
					   "010" when currentState = S18 or currentState = S17 else  -- JAL | JALR
					   "011" when decodedInstruction = MFHI and currentState = S7 else	-- MFHI
					   "100" when decodedInstruction = MFLO and currentState = S7 else	-- MFLO
					   "101" when currentState = S30 and rd = "01101" else	-- MFCO $reg, $13 (cause)
                       "110" when currentState = S30 and rd = "01110" else  -- MFCO $reg, $14 (EPC)
                       "000"; -- RegisterFile.WriteData <- ALUOut
                        
    uins.RegDst <=  "00" when decodedInstruction = ADDIU or 
                              decodedInstruction = ADDI or 
                              decodedInstruction = LUI or 
                              decodedInstruction = ORI or 
                              decodedInstruction = XORI or 
                              decodedInstruction = ANDI or 
                              decodedInstruction = SLTI or 
                              decodedInstruction = SLTIU or 
                              decodedInstruction = LW or
                              decodedInstruction = MFCO else  -- RegisterFile.WriteRegister <- rt
					"10" when currentState = S18 else -- JAL
                    "01"; -- RegisterFile.WriteRegister <- rd
    
    -- ALU multiplexers
    uins.ALUSrcB <= "001" when currentState = S0 or currentState = S22 else -- PC++ | Interruption
                    "011" when currentState = S1 else -- Branch address computation
                    "010" when currentState = S2 or currentState = S10 or (currentState = S7 and decodedInstruction = ADDI) else  -- Memory address computation or I-Type logic/arithmetic with sign extension               
                    "100" when currentState = S11 or currentState = S15 else -- I-Type logic/arithmetic with zero extension
					"101" when currentState = S13 or currentState = S16 else -- BGEZ or BLEZ
                    "000"; -- Register B (R-Type, BEQ, BNE, SLL, SRL)
    
    uins.ALUSrcA <= "00" when currentState = S0 or currentState = S1 or currentState = S22 or currentState = S29 else -- PC++ and branch address computation and Save PC in IRQ
					"10" when currentState = S14 else -- SLL, SRL
                    "01";
                    
    -- PC multiplexer
    uins.PCSource <= "001" when currentState = S8 or currentState = S12 or currentState = S13 or currentState = S16 or currentState = S20 or currentState = S21 else -- ALUOut (BEQ,BNE, BGEZ, BLEZ, BLTZ, BGTZ)
                     "010" when currentState = S9 else -- Jump address (J)
					 "011" when currentState = S24 else -- PC <= EPC (Retorno sub rotina - Funo ERET)
					 "100" when currentState = S23 else -- PC <= constante do endereo do inicio codigo interruption
					 "101" when currentState = S29 else -- PC <= constante do endereo do inicio codigo exceção
                     "000"; -- ALU result output (PC++) 
   
    -- ALU control    
    uins.ALUOp <= ALU_SUB	when currentState = S22 else --  EPC = PC - 4, Interruption (execucao prioritaria)
                  ALU_Bus_A	when currentState = S29 else --  EPC = PC,     Exception    (execucao prioritaria)
				  ALU_ADD   when currentState = S0 or currentState = S1  or decodedInstruction = ADD or decodedInstruction = ADDU or decodedInstruction = ADDIU or decodedInstruction = ADDI or decodedInstruction = LW or decodedInstruction = SW  else
                  ALU_AND   when decodedInstruction = AAND or decodedInstruction = ANDI else -- AND, ANDI
                  ALU_OR    when decodedInstruction = OOR  or decodedInstruction = ORI  else -- OR, ORI
				  ALU_XOR	when decodedInstruction = XXOR or decodedInstruction = XORI else -- XOR
				  ALU_NOR	when decodedInstruction = NNOR else -- NORqu
				  ALU_SLL	when decodedInstruction = SLLL or decodedInstruction = SLLV else -- SLL
				  ALU_SRL	when decodedInstruction = SRLL or decodedInstruction = SRLV else -- SRL
                  ALU_SLT   when decodedInstruction = SLT  else -- SLT
                  ALU_SLTU  when decodedInstruction = SLTU else -- SLTU
				  ALU_SLTI  when decodedInstruction = SLTI else -- SLTI
				  ALU_SLTIU  when decodedInstruction = SLTIU else -- SLTIU
                  ALU_LUI   when decodedInstruction = LUI  else -- LUI
				  ALU_MUL   when decodedInstruction = MULTU  else -- MUL
				  ALU_MOD   when  currentState = S26 else -- DIVU
				  ALU_DIV   when decodedInstruction = DIVU  else -- DIVU
				  ALU_Bus_A	when decodedInstruction = BGEZ or decodedInstruction = BLEZ or currentState = S19 or currentState = S20 or currentState = S21 else --- or currentState = S22 else --  BGEZ | BLEZ | BLTZ | BGTZ
				  ALU_Bus_B	when decodedInstruction = MTCO else
                  ALU_SUB;  -- SUBU, BEQ, 
    
    
    
    -- Registers write control
    uins.PCWriteCond <= '1' when currentState = S8 or currentState = S12 or currentState = S13 or currentState = S16 or currentState = S20 or currentState = S21 else '0'; -- BEQ , BNE, BGTZ
    uins.PCWrite <= '1'     when currentState = S0 or currentState = S9 or currentState = S19 or currentState = S23 or currentState = S24 or currentState = S29 else '0'; -- PC++, J , JAL, JALR, Interruption
    uins.IRWrite <= '1'     when currentState = S0 else '0'; -- Instruction fetch
    uins.RegWrite <= '1'    when currentState = S4 or
                                (currentState = S7 and decodedInstruction /= ADD and decodedInstruction /= ADDI and decodedInstruction /= SUB) or  
                                (currentState = S7 and ((decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction /= SUB) and overflow = '0')) or     -- Aborta write back em caso de overflow
                                 currentState = S18 or 
                                 currentState = S17 or
                                 currentState = S30 else '0'; -- Load, Logic/Arithmetic, MFCO
    
    -- Data memory write control
    uins.MemWrite <= '1' when currentState = S5 else '0'; -- Store
    uins.ce_data <= '1' when (currentState = S3 or currentState = S5)  else '0';   -- Load/Store
    
    -- Instruction memory read control
    uins.ce_ins <= '1' when currentState = S0 else '0';  -- Instruction fetch
	
	uins.mux_brcCTRL <= "000" when currentState = S8 else		--Zero
						"001" when currentState = S12 else 		--Not Zero
						"010" when currentState = S13 else		--Not Flag_N
						"011" when currentState = S20 else		--Flag_N
						"100" when currentState = S16 else		--Zero or Flag_N
						"101" when currentState = S21 else		-- Not Zero and Not Flag_N
						"111";
						
    uins.EPC_Write <= '1' when currentState = S23 or currentState = S31 else '0';		--Habilita regitrador EPC quando necessario 						
	
    uins.hi_en <= '1' when currentState = S25 or currentState = S27 else '0';
	uins.lo_en <= '1' when currentState = S25 or ((currentState = S26) and div_zero = '0') else '0';
	uins.mux_hi <= '1' when currentState = S27 else '0';
	
	uins.isrAd_en <= '1' when currentState = S28 and rd = "11111" else '0';		--No estado de interrupção ou exceção e Reg 31
	uins.esrAd_en <= '1' when currentState = S28 and rd = "11110" else '0';		--No estado de interrupção ou exceção e Reg 30
	
	uins.cause_mux <= "00" when currentState = S29 and flag_exception = "00" else	-- INVALID_INSTRUCTION
					  "01" when currentState = S29 and flag_exception = "01" else -- Syscall
					  "10" when currentState = S29 and flag_exception = "10" else -- Overflow
					  "11";                                                 -- Division by zero
					  
					  
	uins.cause_en <= '1' when currentState = S29 else '0';
    
    -- Exception Flag register
	process(clock, reset)
    begin
        if reset = '1' then
            flag_exception <= "00";        
        
        elsif rising_edge(clock) then
            if(decodedInstruction = SYSCALL) then
                flag_exception <= "01"; 

            elsif ((decodedInstruction = ADD or decodedInstruction = ADDI or decodedInstruction = SUB) and overflow = '1') then
                flag_exception <= "10"; 

            elsif (decodedInstruction = DIVU and div_zero = '1') then
                flag_exception <= "11"; 

            elsif(decodedInstruction = INVALID_INSTRUCTION) then
                flag_exception <= "00"; 
            end if;	
        end if;
    end process;
	
    
    -- Interruption Flag register
    process(clock, reset)
    begin
        if reset = '1' then
            int_flag_q <= "00";        

        elsif rising_edge(clock) then
            if currentState = S22 then
                int_flag_q <= "01";
                
            elsif currentState = S24 then
                int_flag_q <= "10";
            
            -- Delay after interruption
            elsif int_flag_q = "10" then
                int_flag_q <= "11";
                
            elsif int_flag_q = "11" then
                int_flag_q <= "00";
            end if;
        end if;
    end process;
	
	-- Interruption Flag register
    --INT_FLAG: entity work.Register_n_bits(behavioral)
        --generic map (
            --LENGTH      => 2,
            --INIT_VALUE  => 2
        --)
        --port map (
            --clock       => clock,
            --reset       => reset,
            --ce          => int_flag_en, 
            --d           => int_flag_d, 
            --q           => int_flag_q
        --);
	
end behavioral;
