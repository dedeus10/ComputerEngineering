
    .text
    .globl  boot

########################################
# Inicio programa 
################ PROJETO DE PROCESSADORES ###################
#
#-----Luis Felipe de Deus, Tiago Knorst--------
#
#Objetivo:
########################################
########################################

.eqv	ADD_STACK_POINTER	0x00000700

.eqv	ADD_PORTIO_CONFIG 	0x10000001
.eqv	ADD_PORTIO_ENABLE 	0x10000000
.eqv	ADD_PORTIO_DATA 	0x10000002
.eqv	ADD_PORTIO_IRQ	 	0x10000003

.eqv	ADD_PIC_IRQ_ID 		0x20000000
.eqv	ADD_PIC_INT_ACK 	0x20000001
.eqv 	ADD_PIC_MASK 		0x20000002
.eqv	PIC_MASK		0x00000013	# irq(4), irq(1) e irq(0) habilitados para interrupcao

.eqv	ADD_TX			0x30000000

.eqv	ADD_UART		0x40000000
#.eqv	SPEED_UART		0x00000208	# 9600 bps
.eqv	SPEED_UART		0x0000002b	# 115200 bps

.eqv    ADD_TIMER_DATA		0x50000000
.eqv	ADD_TIMER_RESET		0x50000001

#.eqv    CONST_TIMER		24834		# FPGA	(5ms atualizacao de display) 25000 - 165(tempo de entrar na interrupção
.eqv    CONST_TIMER		1250		# SIMULATION
#.eqv	CONST_SEG		200		# FPGA  (200x timer)
.eqv	CONST_SEG		5		# SIMULATION
.eqv	CONST_DELAY		50		# BUTTON DEBOUNCE  (50x5ms = 250ms)
	
########################################

boot:
	# STACK CONFIG
	li    $sp, ADD_STACK_POINTER
	
	
	# ESR ADDRESS CONFIG
	la    $t0, ExceptionServiceRoutine
	mtc0  $t0, $30
	
	# ISR ADDRESS CONFIG
	la    $t0, InterruptionServiceRoutine
	mtc0  $t0, $31
	
	
	# SPEED UART CONFIG
	li $t1, SPEED_UART
	sw $t1, ADD_UART


	# PORTIO CONFIG
	li    $t1, 0xf000
	sw    $t1, ADD_PORTIO_CONFIG
	li    $t1, 0xffff
	sw    $t1, ADD_PORTIO_ENABLE
	li    $t1, 0x1000
	sw    $t1, ADD_PORTIO_IRQ
	sw    $zero, ADD_PORTIO_DATA

	
	# PIC CONFIG
	li    $t9, PIC_MASK
	sw    $t9, ADD_PIC_MASK
	
	
	
	# INICIALIZA TIMER CONTADOR
	li    $t0, 50
	sw    $t0, ADD_TIMER_DATA
   
   
	j main
	
############################################################
###############            KERNEL            ###############
############################################################

######   ISR   ######

InterruptionServiceRoutine:
	# SALVA CONTEXTO
	addiu $sp, $sp, -112
	sw    $1,    4($sp)
	sw    $2,    8($sp)
	sw    $3,   12($sp)
	sw    $4,   16($sp)
	sw    $5,   20($sp)
	sw    $6,   24($sp)
	sw    $7,   28($sp)
	sw    $8,   32($sp)
	sw    $9,   36($sp)
	sw    $10,  40($sp)
	sw    $11,  44($sp)
	sw    $12,  48($sp)
	sw    $13,  52($sp)
	sw    $14,  56($sp)
	sw    $15,  60($sp)
	sw    $16,  64($sp)
	sw    $17,  68($sp)
	sw    $18,  72($sp)
	sw    $19,  76($sp)
	sw    $20,  80($sp)
	sw    $21,  84($sp)
	sw    $22,  88($sp)
	sw    $23,  92($sp)
	sw    $24,  96($sp)
	sw    $25, 100($sp)
	sw    $28, 104($sp)
	sw    $30, 108($sp)
	sw    $31, 112($sp)
		
		
	# LEITURA DO NUMERO DA INTERRUPCAO
	lw    $s0, ADD_PIC_IRQ_ID	# Leitura do IRQ_ID_ADDR
	sw    $s0, irq_id_addr
	
	sll   $t0, $s0, 2		# End = index * 4
		
	lw    $s2, irq_handlers($t0)
	jalr  $s2
	
	# ENVIO DO ACK APOS TRATAMENTO DA INTERRUPCAO
	lw    $s0, irq_id_addr
	sw    $s0, ADD_PIC_INT_ACK	# Leitura do IRQ_ID_ADDR do PIC
		
		
	# RETOMA CONTEXTO
	lw    $1,    4($sp)
	lw    $2,    8($sp)
	lw    $3,   12($sp)
	lw    $4,   16($sp)
	lw    $5,   20($sp)
	lw    $6,   24($sp)
	lw    $7,   28($sp)
	lw    $8,   32($sp)
	lw    $9,   36($sp)
	lw    $10,  40($sp)
	lw    $11,  44($sp)
	lw    $12,  48($sp)
	lw    $13,  52($sp)
	lw    $14,  56($sp)
	lw    $15,  60($sp)
	lw    $16,  64($sp)
	lw    $17,  68($sp)
	lw    $18,  72($sp)
	lw    $19,  76($sp)
	lw    $20,  80($sp)
	lw    $21,  84($sp)
	lw    $22,  88($sp)
	lw    $23,  92($sp)
	lw    $24,  96($sp)
	lw    $25, 100($sp)
	lw    $28, 104($sp)
	lw    $30, 108($sp)
	lw    $31, 112($sp)
	addiu $sp, $sp, 112
	
	eret


###################################################


Handler_Timer:
	sw    $zero, ADD_TIMER_RESET	# Reseta timer
	li    $t0, CONST_TIMER
	sw    $t0, ADD_TIMER_DATA	# Reinicia contagem
	
	
	lw    $t0, contdelay
	beq   $t0, $zero, NoDelay
	
	addiu $t0, $t0, -1
	sw    $t0, contdelay
NoDelay:

	# DISPLAY CONTROL LOGIC
	lw    $s2, controlswitch
	
	lw    $t0, codificado($s2)
	sw    $t0, ADD_PORTIO_DATA	# Atualiza display
	
	bne   $s2, $zero, SaveControlSwitch
	li    $s2, 16
	
SaveControlSwitch:
	addiu $s2, $s2, -4
	sw    $s2, controlswitch
	
	# INCREMENTO DE SEGUNDO
	lw    $s0, contseg
	addiu $s0, $s0, -1
	bne   $s0, $zero, ReturnTimer
	
	li    $s0, CONST_SEG
	sw    $s0, contseg
	
	
	addiu $sp, $sp, -4
	sw    $ra, 4($sp)
	
	li    $a0, 0
	jal   Incremento
		
	lw    $ra, 4($sp)
	addiu $sp, $sp, 4
	
ReturnTimer:
	sw    $s0, contseg
	
	jr    $ra



# FUNCAO DE INCREMENTO

Incremento:	
	lw    $t0, decimal($a0)
	beq   $t0, 9, Inc_dezena
	
	addiu $t0, $t0, 1		
	sw    $t0, decimal($a0)
	
	sll   $t0, $t0, 2
	lw    $t0, display7seg($t0)
	lw    $t1, control7seg($a0)
	or    $t0, $t0, $t1
	sw    $t0, codificado($a0)
	
	jr    $ra
	
Inc_dezena:
	sw    $zero, decimal($a0)
	
	lw    $t0, display7seg
	lw    $t1, control7seg($a0)
	or    $t0, $t0, $t1
	sw    $t0, codificado($a0)
	
	addiu $a0, $a0, 4
	
	lw    $t0, decimal($a0)
	beq   $t0, 9, Inc_dezena
	
	addiu $t0, $t0, 1		
	sw    $t0, decimal($a0)
	
	sll   $t0, $t0, 2
	lw    $t0, display7seg($t0)
	lw    $t1, control7seg($a0)
	or    $t0, $t0, $t1
	sw    $t0, codificado($a0)
	
	jr    $ra

Zera_dezena:
	sw    $zero, decimal($a0)
	
	lw    $t0, display7seg
	lw    $t1, control7seg($a0)
	or    $t0, $t0, $t1
	sw    $t0, codificado($a0)
	
	jr    $ra


###################################################


Handler_Button:
	lw    $t0, contdelay
	bne   $t0, $zero, ReturnButton
	
	
	addiu $sp, $sp, -4
	sw    $ra, 4($sp)
	
	li    $a0, 8
	jal   Incremento
		
	lw    $ra, 4($sp)
	addiu $sp, $sp, 4
	
	
	li    $t0, CONST_DELAY
	sw    $t0, contdelay
	
ReturnButton:
	jr    $ra


###################################################

			  	  
Handler_RX:
	#Atualiza flag que recebeu o enter
	sw    $zero, k_flag
	
	lw    $t1, ADD_UART		
	#Verifica se foi pressionado enter
	bne   $t1, 0xD, WaitReady
	#Atualiza flag que recebeu o enter
	addiu $s0, $zero, 1
	sw    $s0, k_flag
	
	
	#Adiciona o 0 na string
	addu  $t1, $zero, $zero
	j     armazena_str
	
	
WaitReady:
	lw    $t2, ADD_TX
	beq   $t2, $zero, WaitReady	#Verifica se o TX esta apto a mandar dados
	
	ori   $t1, $t1, 0x00000100	#Anexa o dava_av no byte
	sw    $t1, ADD_TX		#Send byte TX
	andi  $t1, $t1, 0x000000ff	#Pega so o byte sem data_av
	#Armazena String
	
armazena_str:	
	lw    $t3, k_bits		#Carrega em qual byte da string deve por o byte recebido
	lw    $t4, k_word		#Carrega qual é a posição de memoria
	sllv  $t5, $t1, $t3 		#Shifta o dado do RX (T1), no numero de bytes que deve ser armazenado
	
	lw    $t7, k_str($t4)		#Carrega a string na posição do momento
	or    $t7, $t7, $t5		#junta o byte na string
	sw    $t7, k_str($t4)		#grava string
	addiu $t3, $t3, 8		#Incrementa byte
	bne   $t3, 32, verifica_enter	#Se o byte nao for 32 nao precisa zerar
	addu  $t3, $zero, $zero 	#reseta o byte
	addiu $t4, $t4, 4		#Incrementa posição da string
	sw    $t4, k_word		#Atualiza o byte na memoria

verifica_enter:				
	lw    $s0, k_flag	
	beq   $s0, $zero, return	#Se a flag do enter nao esta em 1 retorna normal, se nao reseta os bits e word
	addu  $t3, $zero, $zero		#Reseta controle de bits
	sw    $zero, k_word		#Reseta controle de word
return:	
	sw    $t3, k_bits		#Atualiza o byte na memoria	
	jr    $ra			# Retorno do tratamento da interrupcao





######   ESR   ######

ExceptionServiceRoutine:
	# SALVA CONTEXTO
	addiu $sp, $sp, -104
	sw    $1,    4($sp)
	sw    $4,    8($sp)
	sw    $5,   12($sp)
	sw    $6,   16($sp)
	sw    $7,   20($sp)
	sw    $8,   24($sp)
	sw    $9,   28($sp)
	sw    $10,  32($sp)
	sw    $11,  36($sp)
	sw    $12,  40($sp)
	sw    $13,  44($sp)
	sw    $14,  48($sp)
	sw    $15,  52($sp)
	sw    $16,  56($sp)
	sw    $17,  60($sp)
	sw    $18,  64($sp)
	sw    $19,  68($sp)
	sw    $20,  72($sp)
	sw    $21,  76($sp)
	sw    $22,  80($sp)
	sw    $23,  84($sp)
	sw    $24,  88($sp)
	sw    $25,  92($sp)
	sw    $28,  96($sp)
	sw    $30, 100($sp)
	sw    $31, 104($sp)
		
		
	# LEITURA DO NUMERO DA INTERRUPCAO
	mfc0  $s0, $14			# Leitura do registrador EPC
	addiu $s0, $s0, -4		# Pega endereço da instrucao que gerou excecao
	
	mfc0  $t0, $13			# Leitura do registrador CAUSE
	sll   $t0, $t0, 2		# End = index * 4
		
	lw    $s2, exc_handlers($t0)
	jalr  $s2
		
		
	# RETOMA CONTEXTO
	lw    $1,    4($sp)
	lw    $4,    8($sp)
	lw    $5,   12($sp)
	lw    $6,   16($sp)
	lw    $7,   20($sp)
	lw    $8,   24($sp)
	lw    $9,   28($sp)
	lw    $10,  32($sp)
	lw    $11,  36($sp)
	lw    $12,  40($sp)
	lw    $13,  44($sp)
	lw    $14,  48($sp)
	lw    $15,  52($sp)
	lw    $16,  56($sp)
	lw    $17,  60($sp)
	lw    $18,  64($sp)
	lw    $19,  68($sp)
	lw    $20,  72($sp)
	lw    $21,  76($sp)
	lw    $22,  80($sp)
	lw    $23,  84($sp)
	lw    $24,  88($sp)
	lw    $25,  92($sp)
	lw    $28,  96($sp)
	lw    $30, 100($sp)
	lw    $31, 104($sp)
	addiu $sp, $sp, 104
	
	eret


InvalidInstructionHandler:
	addiu $sp, $sp, -8
	sw    $ra, 4($sp)
	sw    $s0, 8($sp)
	
	
	# IMPRIME MENSAGEM DE ERRO
	addu  $a0, $s0, $zero		# Hexadecimal lido do registrador cause a ser convertido para string
	jal   IntToHexString

	addu  $a0, $v0, $zero
	jal   PrintString	

	#Printf("Exception: Inv .instruction);
	la    $a0, str_exc_invins
	jal   PrintString
	
	lw    $ra, 4($sp)
	addiu $sp, $sp, 8
	
	jr    $ra


SystemCallHandler:
	sll   $t0, $v0, 2
	
	addiu $sp, $sp, -4
	sw    $ra, 4($sp)
	
	lw    $s2, sys_handlers($t0)
	jalr  $s2
	
	lw    $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr    $ra


OverflowHandler:
	addiu $sp, $sp, -8
	sw    $ra, 4($sp)
	sw    $s0, 8($sp)
	
	
	# IMPRIME MENSAGEM DE ERRO
	addu  $a0, $s0, $zero		# Hexadecimal lido do registrador cause a ser convertido para string
	jal   IntToHexString

	addu  $a0, $v0, $zero
	jal   PrintString	


	# Printf("Excepetion: Overflow");
	la    $a0, str_exc_ovflow
	jal   PrintString
	
	lw    $ra, 4($sp)
	addiu $sp, $sp, 8
	
	jr    $ra


DivisionByZeroHandler:
	addiu $sp, $sp, -8
	sw    $ra, 4($sp)
	sw    $s0, 8($sp)
	
	
	# IMPRIME MENSAGEM DE ERRO
	addu  $a0, $s0, $zero		# Hexadecimal lido do registrador cause a ser convertido para string
	jal   IntToHexString

	addu  $a0, $v0, $zero
	jal   PrintString	


	# Printf ("Exception: Division by zero");
	la    $a0, str_exc_divby0
	jal   PrintString
	
	lw    $ra, 4($sp)
	addiu $sp, $sp, 8
	
	jr    $ra


#######################################
######   BIBLIOTECA DE FUNCOES   ######
#######################################


######## FUNCAO PRINT STRING ########

PrintString:
	lw    $s0, ($a0)
	li    $t0, 0
	
TakeByte:
	srlv  $t1, $s0, $t0
	andi  $t1, $t1, 0x000000ff
	
	beq   $t1, $zero, EndOfTransmission	
	ori   $t1, $t1, 0x00000100

WaitReadyTX:	
	lw    $t2, ADD_TX
	beq   $t2, $zero, WaitReadyTX
	
	sw    $t1, ADD_TX
	
	addiu $t0, $t0, 8
	
	bne   $t0, 32, TakeByte
	
	li    $t0, 0
	addiu $a0, $a0, 4
	lw    $s0, ($a0)
	
	j     TakeByte

EndOfTransmission:
	jr    $ra 




######## FUNCAO INTEGER TO STRING ########

IntegerToString:
	li    $t0, 10
	li    $t2, 0
	li    $t3, 4
	
ConvertIntegerToString:
	sll   $t2, $t2, 8
	divu  $a0, $t0
	mfhi  $t1
	mflo  $a0
	
	addiu $t1, $t1, 48		# Converte inteiro para caractere ASCII
	or    $t2, $t2, $t1
	
	addiu $t3, $t3, -1
	
	beq   $t3, $zero, ReturnIntegerToString		# Retorna se numero > 9999
	bne   $a0, $zero, ConvertIntegerToString
	
ReturnIntegerToString:
	sw    $t2, k_str_int	
	la    $v0, k_str_int
	
	jr    $ra
	



######## FUNCAO INTEGER TO HEXADECIMAL STRING ########

IntToHexString:
	li    $s0, 0x30780000		# ASCII: 0x

	li    $t0, 8
	li    $t1, 28
	li    $t2, 0xf0000000
	li    $t3, 0
	
ConvertIntToHexString:
	and   $t4, $t2, $a0
	srlv  $t4, $t4, $t1
	andi  $t4, $t4, 0x0000000f
	
	addu  $t4, $t4, $t4
	addu  $t4, $t4, $t4
	
	lw    $t5, ascii_hex($t4)
	
	sllv  $t5, $t5, $t0
	or    $s0, $s0, $t5
	
	addiu $t0, $t0, -8
	addiu $t1, $t1, -4
		
	srl   $t2, $t2, 4
	
	slt   $t4, $t1, $zero
	bne   $t4, $zero, ReturnIntToHexString
	bne   $t0, -8, ConvertIntToHexString	
	
	sw    $s0, k_str_int($t3)
	
	li    $s0, 0
    	li    $t0, 24
	addiu $t3, $t3, 4
	
	j     ConvertIntToHexString

ReturnIntToHexString:
	sw    $s0, k_str_int($t3)
    	la    $v0, k_str_int
    	
    	jr    $ra

    	
#####################FUNÇÃO READ#######################

Read:
	lw    $t1, k_flag
	beq   $t1, $zero, return_zero
	
	sw    $zero, k_flag		#Reseta flag
	addu  $t6, $zero, $zero		
	addu  $s0, $zero, $zero
	addu  $s1, $zero, $zero
	
	

	addu  $t0, $a0, $zero		#Carrega endereço em t0
	addiu $a1, $a1, 1		# Libera espaco para 0 ao final da string
	
copy_start:	
	lw    $t1, k_str($s1)
	
	#Separa os bytes
	andi  $t2, $t1, 0x000000ff
	andi  $t3, $t1, 0x0000ff00
	andi  $t4, $t1, 0x00ff0000
	andi  $t5, $t1, 0xff000000
	
copy_word:
	beq   $t2, $zero, copy_done
	or    $t6, $t6, $t2		#Junta o primeiro byte
	addiu $s0, $s0, 1		#Incrementa numero de caracteres copiados
	beq   $s0, $a1, copy_done	#Verifica se ja terminou a copia
	
	beq   $t3, $zero, copy_done
	or    $t6, $t6, $t3		#Junta o segundo byte
	addiu $s0, $s0, 1		#Incrementa numero de caracteres copiados
	beq   $s0, $a1, copy_done	#Verifica se ja terminou a copia
	
	beq   $t4, $zero, copy_done
	or    $t6, $t6, $t4		#Junta o terceiro byte
	addiu $s0, $s0, 1		#Incrementa numero de caracteres copiados
	beq   $s0, $a1, copy_done	#Verifica se ja terminou a copia
	
	beq   $t5, $zero, copy_done
	or    $t6, $t6, $t5		#Junta o quarto byte
	addiu $s0, $s0, 1		#Incrementa numero de caracteres copiados
	beq   $s0, $a1, copy_done	#Verifica se ja terminou a copia
	
	sw    $t6, ($t0)		#Grava em na variavel informada em a0
	
	sw    $zero, k_str($s1)		#zera essa word da string
	addu  $t6, $zero, $zero		#Zera a word que ja foi copiada
	
	addiu $t0, $t0, 4		#Incrementa para gravar no proximo espaço de memoria
	addiu $s1, $s1, 4		#Incrementa para pegar a proxima word
	
	j     copy_start
	
copy_done:
	sw    $t6, ($t0)		#Grava na memoria
	sw    $zero, k_str($s1)		#zera essa word da string
	addu  $v0, $s0, $zero		#Retorna o numero de caracteres copiados
	
	jr   $ra			#Return
	
return_zero:
	addu $v0, $zero, $zero		#Retorna zero
	jr   $ra			#Return



######## FUNCAO STRING TO INTEGER ########


StringToInteger:
	addu  $s0, $a0, $zero
	li    $s1, 0
	
	li    $t1, -8
	li    $t3, 10
	li    $t4, 32
	
loop_strtoint:
	addiu $t1, $t1, 8
	
	srlv  $t5, $s0, $t1
	andi  $t5, $t5, 0xff
	addiu $t2, $t5, -48		# Converte ASCII para inteiro
	
	beq   $t1, $t4, end_strtoint
	beq   $t5, $zero, end_strtoint
	
	multu $s1, $t3
	mflo  $s1
	addu  $s1, $s1, $t2
	
	j     loop_strtoint

end_strtoint:
	addu  $v0, $s1, $zero
	
	jr    $ra


############################################################
###############        FIM DO KERNEL         ###############
############################################################


############################### FUNÇÃO Inverte String ################################

InverteString:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	addiu $sp, $sp, -12
	sw    $a0,  4($sp)
	sw    $ra,  8($sp)

	# Printf("String Invertida: ")
	la    $a0, str_invert
	li    $v0, 0			# PRINT STRING
	syscall	
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	
	lw    $s0, read_return
	li    $s2, 0
	srl   $t0, $s0, 2
	sll   $t0, $t0, 2
	
	li    $t1, 0
	li    $t2, 0
	li    $t4, 0
	li    $t5, 0
	
LoopInversao:
	lw    $s1, buffer($t0)
	sllv  $t3, $s1, $t1
	srl   $t3, $t3, 24
	
	
	beq   $t3, $zero, Nao_Salva
	
	sllv  $t3, $t3, $t4
	or    $s2, $s2, $t3
	addiu $t4, $t4, 8
	
	bne   $t4, 32, Nao_Salva
	
	sw    $s2, str_aux($t5)
	li    $s2, 0
	
	
	li    $t4, 0
	addiu $t5, $t5, 4
	
Nao_Salva:
	addiu $t1, $t1, 8
	bne   $t1, 32, LoopInversao
	
	li    $t1, 0
	addiu $t2, $t2, 4
	addiu $t0, $t0, -4
	bne   $t0, -4, LoopInversao
	
	beq   $s2, $zero, end
	sw    $s2, str_aux($t5)
	
end:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	la    $a0, str_aux
	li    $v0, 0			# PRINT STRING
	
	syscall
	
	# Printf("\n\r")
	la    $a0, str_nextline
	li    $v0, 0			# PRINT STRING
	syscall	
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	
	jr   $ra

############################# FIM FUNÇÃO String Invertida ################################

############################### FUNÇÃO Leitura do Teclado ################################		

keyboard_read:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	addiu $sp, $sp, -12
	sw    $a0,  4($sp)
	sw    $ra,  8($sp)

	# Printf("Informe a String")
	la    $a0, str_entry
	li    $v0, 0			# PRINT STRING
	syscall	

	lw    $a0,  4($sp)
	lw    $ra,  8($sp)
	addiu $sp, $sp, 8
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	
	
Wait_Read1:							
	la    $a0, buffer		# Parametro Endereço de buffer
	lw    $a1, size			# Parametro valor de size
	li    $v0, 3			# READ
		
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	syscall
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	beq   $v0, $zero, Wait_Read1
	
	sw    $v0, read_return
	
	jr   $ra

#############################FIM FUNÇÃO Leitura do Teclado################################

#############################FUNÇÃO Pega Numero de Elementos##############################
NUM_elements:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK		# MASCARA INTERRUPCOES
	
	addiu $sp, $sp, -8
	sw    $a0, 4($sp)
	sw    $ra, 8($sp)	

	# Printf("Num. Elementos")
	la    $a0, str_numelem
	li    $v0, 0			# PRINT STRING
	syscall	
		
	lw    $a0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 8
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	
Wait_Read2:	
	la    $a0, n_elements		# Parametro Endereço de n_elements
	li    $a1, 4			# Parametro valor de size (apenas uma word)
	li    $v0, 3			# READ
	
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	syscall
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	beq   $v0, $zero, Wait_Read2
	
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	lw    $a0, n_elements		# Carrega string do array para converter os bytes para inteiros
	li    $v0, 4			# STRING TO INTEGER
	
	syscall
	
	sw    $v0, n_elements

	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	addu  $v0, $zero, $zero		#Reset no v0
	jr    $ra
#############################FIM FUNÇÃO Pega Numero de Elementos###########################
	
#############################FUNÇÃO Pega Ordenação#########################################	
Order_bl:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	addiu $sp, $sp, -8
	sw    $a0, 4($sp)
	sw    $ra, 8($sp)

	# Printf("Ordenacao:")
	la    $a0, str_ordenation
	li    $v0, 0			# PRINT STRING
	syscall	
		
	lw    $a0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 8
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	

Wait_Read3:
	la    $t0, order
	addu  $a0, $t0, $zero		# Parametro Endereço de n_elements
	
	addiu $a1, $zero, 1		# Parametro valor de size (apenas uma word)
	li    $v0, 3			# READ
	
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	syscall
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	beq   $v0, $zero, Wait_Read3
	
	lw    $t0, order
	addiu $t0, $t0, -48		# Converte ASCII para inteiro
	sw    $t0, order
	
	addu  $v0, $zero, $zero		#Reset no v0
	jr    $ra
#############################FIM - FUNÇÃO Pega Ordenação######################################
	
#############################FUNÇÃO Pega Elementos do Array####################################	
Array_elements:
	la    $s5, array
	lw    $s7, n_elements
	addu  $s6, $zero, $zero
	 
 for:	
 	#PRINT NA TELA
 	#Array[i]:
 	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	addiu $sp, $sp, -8
	sw    $a0, 4($sp)
	sw    $ra, 8($sp)

	# Printf("Array[")
	la    $a0, str_arrayelem1
	li    $v0, 0			# PRINT STRING
	syscall
	
	# str_aux = IntegerToString(array[i]);
	addu  $a0, $s6, $zero		# Passa inteiro a ser convertido por parametro
	li    $v0, 1			# INTEGER TO STRING
	syscall
    	
    	# PrintString(str_aux);
	addu  $a0, $v0, $zero		# Parametro para PrintString: endereco retornado de IntegerToString
	li    $v0, 0			# PRINT STRING
	syscall
	
	# Printf("]: ")
	la    $a0, str_arrayelem2
	li    $v0, 0			# PRINT STRING
	syscall
		
	lw    $a0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 8
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
   while_read_zero:
	addu  $a0, $s5, $zero		# Parametro Endereço de n_elements
	addiu $a1, $zero, 4		# Parametro valor de size (apenas uma word)
	li    $v0, 3			# READ
	
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	syscall
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK

		
	beq   $v0, $zero, while_read_zero
	
	
	
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	lw    $a0, ($s5)		# Carrega string do array para converter os bytes para inteiros
	li    $v0, 4			# STRING TO INTEGER
	
	syscall
	
	sw    $v0, ($s5)

	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	
	addiu $s6, $s6, 1		#Incrmeenta contador de numeros para pedir ao user
	addiu $s5, $s5, 4		#Incrmeenta endereço do array
	bne   $s7, $s6, for		#Verifica se ja chegou a n_elements		
	
array_done:	
	addu  $v0, $zero, $zero		#Reset no v0
	jr    $ra
	
#############################FIM FUNÇÃO Pega Elementos do Array####################################		
	
	
######## FUNCAO IMPRIME ARRAY ########
	
ImprimeArray:
	li    $t0, 0
	lw    $t1, n_elements
	sll   $t1, $t1, 2

ConverteEnvia:
	# Salva contexto
	addiu $sp, $sp, -16
	sw    $t0,  4($sp)
	sw    $t1,  8($sp)
	sw    $a0, 12($sp)
	sw    $ra, 16($sp)

		
	# PrintString(" ")
	li    $t1, 0x0020		# ASCII: [SPACE]
	sw    $t1, str_aux		# Parametro para PrintString: endereï¿½o contendo o espaco
	
	la    $a0, str_aux
	li    $v0, 0			# PRINT STRING
	syscall
	
	# str_aux = IntegerToString(array[i]);
	lw    $a0, array($t0)		# Passa inteiro a ser convertido por parametro
	li    $v0, 1			# INTEGER TO STRING
	syscall
    	
    	# PrintString(str_aux);
	addu  $a0, $v0, $zero		# Parametro para PrintString: endereco retornado de IntegerToString
	li    $v0, 0			# PRINT STRING
	syscall


        # Retoma contexto
	lw    $t0,  4($sp)
	lw    $t1,  8($sp)
	lw    $a0, 12($sp)
	lw    $ra, 16($sp)
	addiu $sp, $sp, 16
    
    
    	addiu $t0, $t0, 4
	bne   $t0, $t1, ConverteEnvia
    
    
	jr    $ra	

######## FUNCAO BUBBLE SORT ########

BubbleSort:
	# PIC CONFIG
	sw    $zero, ADD_PIC_MASK	# MASCARA INTERRUPCOES
	
	# IMPRIME ARRAY INICIAL
	addiu $sp, $sp, -8
	sw    $a0, 4($sp)
	sw    $ra, 8($sp)
	
	# Printf("Array inicial:")
	la    $a0, str_arrayini
	li    $v0, 0			# PRINT STRING
	syscall

	jal   ImprimeArray
	
	lw    $a0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 8
	
ordenation:
    	# Inicializa contadores
    	li    $t5, 1			# t5 = constant 1
    	li    $t8, 1			# t8 = 1: swap performed
    
while:
	beq   $t8, $zero, end_ordenation # Verifies if a swap has ocurred
	la    $t0, array		# t0 points the first array element
	la    $t6, n_elements		# 
	lw    $t6, 0($t6)		# t6 <- size    
	addiu $t8, $zero, 0		# swap <- 0
    
loop:
	beq   $a0, $zero, loadsDescending
	
loadsAscending:
	lw    $t1, 0($t0)		# t1 <- array[i]
	lw    $t2, 4($t0)		# t2 <- array[i+1]
	j     loaded
	
loadsDescending:
	lw    $t2, 0($t0)		# t1 <- array[i]
	lw    $t1, 4($t0)		# t2 <- array[i+1]

loaded:
	slt   $t7, $t2, $t1		# array[i+1] < array[i] ?
	beq   $t7, $t5, swap		# Branch if array[i+1] < array[i]

continue:
	addiu $t0, $t0, 4		# t0 points the next element
	addiu $t6, $t6, -1		# size--
	beq   $t6, $t5, while		# Verifies if all elements were compared
	j     loop    

# Swaps array[i] and array[i+1]
swap:
	beq   $a0, $zero, savesDescending

savesAscending:
	sw    $t1, 4($t0)
	sw    $t2, 0($t0)
	j     saved
	
savesDescending:	
	sw    $t2, 4($t0)
	sw    $t1, 0($t0)
	
saved:
	addiu $t8, $zero, 1		# Indicates a swap
	j     continue


end_ordenation:
	addiu $sp, $sp, -8
	sw    $a0, 4($sp)
	sw    $ra, 8($sp)

	# Printf("Array Ordenado")
	la    $a0, str_arrayord
	li    $v0, 0			# PRINT STRING
	syscall

	jal   ImprimeArray
	
	# Printf("\n\r")
	la    $a0, str_nextline
	li    $v0, 0			# PRINT STRING
	syscall
	
	# Printf("\n\r")
	la    $a0, str_nextline
	li    $v0, 0			# PRINT STRING
	syscall		
		
	lw    $a0, 4($sp)
	lw    $ra, 8($sp)
	addiu $sp, $sp, 8
	
	# PIC CONFIG
	li    $t9, PIC_MASK		# HABILITA INTERRUPCOES
	sw    $t9, ADD_PIC_MASK
	
	jr    $ra
	
############################FIM BUBBLE SORT##################################


############################FUNÇÃO PRINCIPAL##################################
main:
	lw    $t0, size
	
Inicializa_buffer:
	addiu $t0, $t0, -4
	sw    $zero, buffer($t0)
	bne   $t0, $zero, Inicializa_buffer
	
	
	#Chamadas de Funções
	jal   keyboard_read
	#jal   InverteString
	jal   NUM_elements
	jal   Array_elements
	jal   Order_bl
	
	lw    $a0, order
	jal   BubbleSort
	
	
	j main
		

########################################
# ï¿½rea de dados
########################################
.data
	# COUNTER DATA
	display7seg:	.word 0x00000003 0x0000009f 0x00000025 0x0000000d 0x00000099 0x00000049 0x00000041 0x0000001f 0x00000001 0x00000009
	control7seg:	.word 0x00000e00 0x00000d00 0x00000b00 0x00000700
	controlswitch:	.word 0
	contseg:	.word CONST_SEG
	contdelay:	.word 0

	decimal:	.word 0x00000000 0x00000000 0x00000000 0x00000000
	codificado:	.word 0x00000e03 0x00000d03 0x00000b03 0x00000703
	
	
	# USER DATA
	size:		.word 80
	buffer:		.space 80
	n_elements:	.word 0
	order:		.word 0
	read_return:	.word 0
	str_aux:	.space 80
	array:		.space 80
	
	
	# Strings
	str_entry:	.asciiz "Informe a String: "
	.align 2
	str_invert:	.asciiz "\n\rString Invertida: "
	.align 2
	str_numelem:	.asciiz "\n\rNumero de Elementos: "
	.align 2
	str_ordenation:	.asciiz "\n\rOrdenacao (0=Decr / 1=Cres): "
	.align 2
	str_arrayelem1:	.asciiz "\n\rArray["
	.align 2
	str_arrayelem2:	.asciiz "]: "
	.align 2
	str_arrayord:	.asciiz "\n\rArray Ordenado:"
	.align 2
	str_arrayini:	.asciiz "\n\rArray Inicial:"
	.align 2
	str_nextline:	.asciiz "\n\r"
	.align 2
	
	
	
	
	
	# KERNEL DATA
	k_str:		.space 80
	k_flag:		.word 0
	k_word:		.word 0
	k_bits:		.word 0
	
	k_str_int:	.space 16
	
	
	str_exc_invins:	.asciiz "\n\rException: Inv. Instruction"
	.align 2
	str_exc_ovflow:	.asciiz "\n\rException: Overflow"
	.align 2
	str_exc_divby0:	.asciiz "\n\rException: Division by zero"
	.align 2
	
	
	ascii_hex:	.word 48 49 50 51 52 53 54 55 56 57 97 98 99 100 101 102

	irq_id_addr:	.word 0
	
	#Jump Tables
	irq_handlers:	.word Handler_Timer Handler_RX 0 0 Handler_Button 0 0 0
	exc_handlers:	.word 0 InvalidInstructionHandler 0 0 0 0 0 0 SystemCallHandler 0 0 0 OverflowHandler 0 0 DivisionByZeroHandler
	sys_handlers:	.word PrintString IntegerToString IntToHexString Read StringToInteger
	
##################################################
#End of Program
