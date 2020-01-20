#!/usr/bin/env python3
#
#--------------------------------------------------------------------------------
#--                                                                            --
#--                 Universidade Federal de Santa Maria                        --
#--                        Centro de Tecnologia                                --
#--                 Curso de Engenharia de Computação                          --
#--                 Santa Maria - Rio Grande do Sul/BR                         --
#--                                                                            --
#--------------------------------------------------------------------------------
#--                                                                            --
#-- Design      : RSA                                                          --
#-- File		: RSA.py                    	                           	   --
#-- Author      : Luis Felipe de Deus                                          --
#--------------------------------------------------------------------------------
#--                                                                            --
#-- Created     : 31 Aug 2019                                                  --
#-- Update      : 03 Sep 2019                                                  --
#--------------------------------------------------------------------------------
#--                              Overview                                      --
#--                                                                            --
#-- Code executed in python3 (3.6)                                             --
#-- para compilar e executar:                                                  --
#-- "python3 -O RSA.py"  -> usa inputs do usuario                              --
#-- "python3 RSA.py"     -> usa parametros pre definidos                       --
#--------------------------------------------------------------------------------
#

from random import randint

#Define o tamanho do numero randomico
TAM = 20

# @brief: Gera numeros randomicos e testa se e' primo
# @param:  void
# @return:  o numero randomico que satisfaz a condicao
def generateRandomPrimeNumber():
    numer_ok = False
    aux = 0
    while(not(numer_ok)):
        aux = randint(0,TAM)
        if(prime(aux)):
            numer_ok = True
    return aux
    
# @brief: Verifica se e' primo  
# @param: n -> numero a ser testado
# @return:  true se for primo, false caso contrario
def prime(n): # check if the number is prime
    if (n <= 1):
        return False
    if (n <= 3):
        return True

    if (n%2 == 0 or n%3 == 0):
        return False

    i = 5
    while(i * i <= n):
        if (n%i == 0 or n%(i+2) == 0):
           return False
        i+=6
    return True

# @brief: funcao mod, simplifica o calculo se a for menor que b
# @param: a -> primeiro numero, b-> segundo numero  
# @return: retorna o resto da divisoa de a e b
def mod(a,b): # mod function
    if(a<b):
        return a
    else:
        c=a%b
        return c

# @brief: funcao mdc, calcula o maior divisior comum
# @param: num1 -> primeiro numero, num2-> segundo numero  
# @return: Retorna o maior divisor de a e b 
def mdc(num1, num2):
    resto = None
    while resto is not 0:
        resto = num1 % num2
        num1  = num2
        num2  = resto

    return num1

# @brief: Gera o atributo "e", deve satisfazer a propriedade mdc(fi(n), e) = 1 
# @param: fi_n -> numero usado no teste da propriedade
# @return: Retorna um numero randomico "e" que satisfaz a propriedade
def generate_E(fi_n):
    while True:
        #Gera numeros aleatorios
        rand_e = randint(0,TAM)
        #Testa a condicao: e<fi_n
        if(rand_e < fi_n):
            #Testa a condicao: mdc(fi(n), e) = 1 
            if(mdc(rand_e,fi_n)==1):
                return rand_e
        
# @brief: Gera o atributo "d", deve satisfazer a propriedade d*e = 1 mod fi(n)
# @param: fi_n -> numero de fi(n), e-> atributo e, usados no teste de propriedade  
# @return:  Retorna um numero randomico "d" que satisfaz a propriedade
def generate_D(fi_n, e):
    resto = None
    while resto is not 1:
        #Gera numeros aleatorios
        rand_d = randint(0, TAM)
        aux = rand_d * e
        resto = aux % fi_n

        #print("RAND:",rand_d,"   RAND*E:",aux,"   PHI(n):",fi_n,"   RESTO:", resto)

    return rand_d

# @brief: Decifra a mensagem usado: M = C^d mod n
# @param: cipher -> mensagem cifrada, Kpr -> Key_private 
# @return: retorna a mensagem decifrada 
def decipher(cipher, Kpr):
    decipher_msg = 0
    aux = (cipher**Kpr[0]) 
    decipher_msg = mod(aux, Kpr[1])
    return decipher_msg
    
   
# @brief: Cifra a mensagem usado: c = M^e mod n
# @param: message -> mensagem original , Kpu -> Key_public
# @return: retorna a mensagem cifrada 
def cipher(message, Kpu):
    cipher_msg = 0
    aux = (message**Kpu[0]) 
    cipher_msg = mod(aux, Kpu[1])
    return cipher_msg
    

# ---------------------------------- MAIN  ----------------------------------------------------------------------------------
originalMessage = (int(input(('Informe a mensagem: '))))

print("-------Starting RSA Algorithm-----")
#Generate random prime numbers P e Q
p = generateRandomPrimeNumber()
q = generateRandomPrimeNumber()
if(__debug__):
    print("****Usando parametros pre-definidos")
    p = 3
    q = 11

print("-> P number is: ", p)
print("-> Q number is: ", q)

#Generate N and Fi(n)
n = p*q
fi_n = (p-1) * (q-1)
#TAM = originalMessage
#Generate the e and d numbers
e = generate_E(fi_n)
if(__debug__):
    e = 7
print("* O numero E gerado e': ", e)

d = generate_D(fi_n, e)
if(__debug__):
    d = 3
print("* O numero D gerado e': ", d)

#Generate Keys
Kpu = []
Kpr = []
Kpu.append(e)
Kpu.append(n)

Kpr.append(d)
Kpr.append(n)

print("A chave publica e': {", Kpu[0],",",Kpu[1],"}")
print("A chave privada e': {", Kpr[0],",",Kpr[1],"}")

print("-------------------------------")
#Cipher the message
cipher_msg = cipher(originalMessage, Kpu)
print("Mensagem cifrada e': ", cipher_msg)

#Decipher the message
decipher_msg = decipher(cipher_msg, Kpr)
print("Mensagem Original decifrada e': ", decipher_msg)



