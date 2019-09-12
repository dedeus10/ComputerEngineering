.text
.globl  boot
.globl  main

# INICIO DO KERNEL

boot:
	# ESR ADDRESS CONFIG
	la    $t0, ExceptionServiceRoutine
	mtc0  $t0, $30			# Move endere�o de mem�ria do tratamento da ESR para o registrador da ISR c0[30]
   
	j main

ExceptionServiceRoutine:
	#  [...]  TRATAMENTO DAS EXCE��ES E SYSCALLS
	eret

# FIM DO KERNEL
	

main:
	# PRINT STRING
	la    $a0, string		# Par�metro da fun��o = endere�o da string
	li    $v0, 0			# Par�metro para selecionar a fun��o PrintString
	syscall


	# INTEGER TO STRING
	lw    $a0, integer		# Par�metro da fun��o = inteiro a ser convertido
	li    $v0, 1			# Par�metro para selecionar a fun��o IntegerToString
	syscall
	
	
	# INTEGER TO HEXADECIMAL STRING
	lw    $a0, integer		# Par�metro da fun��o = inteiro a ser convertido
	li    $v0, 2			# Par�metro para selecionar a fun��o IntToHexString
	syscall
	
	
	# READ
while_read_zero:
	la    $a0, string		# Par�metro 1 da fun��o = endere�o da string
	li    $a1, 6			# Par�metro 2 da fun��o = tamanho da string
	li    $v0, 3			# Par�metro para selecionar a fun��o Read
	syscall
	
	beq   $v0, $zero, while_read_zero
	
	
	# STRING TO INTEGER
	lw    $a0, string		# Par�metro da fun��o = endere�o da string
	li    $v0, 4			# Par�metro para selecionar a fun��o StringToInteger
	
	syscall
	
	
	j main
		


.data
	integer:	.word 	5
	string:		.asciiz "teste"
