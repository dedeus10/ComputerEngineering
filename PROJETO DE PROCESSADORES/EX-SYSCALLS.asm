.text
.globl  boot
.globl  main

# INICIO DO KERNEL

boot:
	# ESR ADDRESS CONFIG
	la    $t0, ExceptionServiceRoutine
	mtc0  $t0, $30			# Move endereço de memória do tratamento da ESR para o registrador da ISR c0[30]
   
	j main

ExceptionServiceRoutine:
	#  [...]  TRATAMENTO DAS EXCEÇÕES E SYSCALLS
	eret

# FIM DO KERNEL
	

main:
	# PRINT STRING
	la    $a0, string		# Parâmetro da função = endereço da string
	li    $v0, 0			# Parâmetro para selecionar a função PrintString
	syscall


	# INTEGER TO STRING
	lw    $a0, integer		# Parâmetro da função = inteiro a ser convertido
	li    $v0, 1			# Parâmetro para selecionar a função IntegerToString
	syscall
	
	
	# INTEGER TO HEXADECIMAL STRING
	lw    $a0, integer		# Parâmetro da função = inteiro a ser convertido
	li    $v0, 2			# Parâmetro para selecionar a função IntToHexString
	syscall
	
	
	# READ
while_read_zero:
	la    $a0, string		# Parâmetro 1 da função = endereço da string
	li    $a1, 6			# Parâmetro 2 da função = tamanho da string
	li    $v0, 3			# Parâmetro para selecionar a função Read
	syscall
	
	beq   $v0, $zero, while_read_zero
	
	
	# STRING TO INTEGER
	lw    $a0, string		# Parâmetro da função = endereço da string
	li    $v0, 4			# Parâmetro para selecionar a função StringToInteger
	
	syscall
	
	
	j main
		


.data
	integer:	.word 	5
	string:		.asciiz "teste"
