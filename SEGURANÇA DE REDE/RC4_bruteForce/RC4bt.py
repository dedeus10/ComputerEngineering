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
#-- Design      : RC4 brute force                                              --
#-- File		: RC4bt.py                    	                          	   --
#-- Author      : Luis Felipe de Deus                                          --
#--------------------------------------------------------------------------------
#--                                                                            --
#-- Created     : 26 Aug 2019                                                  --
#-- Update      : 01 Sep 2019                                                  --
#--------------------------------------------------------------------------------
#--                              Overview                                      --
#--                                                                            --
#-- Code executed in python3 (3.6)                                             --
#-- para compilar e executar:                                                  --
#-- "python3 -O RC4bt.py"  -> usa inputs do usuario                            --
#-- "python3 RC4bt.py"     -> usa parametros pre definidos                     --
#-- Usado para verificar: http://rc4.online-domain-tools.com                   --
#--------------------------------------------------------------------------------
#

import numpy as np
import sys
# @brief: Key-scheduling algorithm (KSA) inicia a permutação no array S
# @param:  usr_key -> chave do usuario 
def KSA(usr_key):
    key_length = len(usr_key)
    S = list(range(256))
    j = 0
    for i in range(256):
        j = (j + S[i] + usr_key[i % key_length]) % 256
        S[i], S[j] = S[j], S[i]  
    return S


# @brief: Pseudo-random generation algorithm (PRGA) utilizado para alterar o estado e a saida dos bytes.
# @param: n-> tamanho do texto a ser encriptado. S-> array permutado
def PRGA(S, n):
    i = 0
    j = 0
    key = []

    while(n>0):
        n = n-1
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]
        K = S[(S[i] + S[j]) % 256]
        key.append(K)
    return key

# @brief: converte o texto para hexa 
# @param: s-> plaintext
def preparing_key_array(s):
    return [ord(c) for c in s]

# @brief: Cifra a mensagem (Ou decifra) xor bit a bit
# @param: S-> array permutado , plainText: mensagem, keystream: chave
def encrypt(S, keystream, plainText):
    cipher = keystream ^ plainText
    return cipher


# ---------------------------------- MAIN  ----------------------------------------------------------------------------------

###INPUT DATA
alfabeto = []
alfabeto = ["A","B","C","D","E","F","G","H","I","J","L","M","N","O","P","Q","R","S","T","U","V","X","Z"]

if(__debug__):
    hex_input = '2554868ddd2b52f395caf5b3ef371f5dde89c300b523ef'    
else:
    hex_input = (str(input(('Informe a string hexadecimal sem espaços: '))))

j = 0
dec_msg = []
while(j<len(hex_input)):
    dec_msg.append( int(hex_input[j:j+2], 16))
    j+=2

print("Aluno: Luis Felipe de Deus")
print("-------Starting RC4 algorithm to decipher the message with brute force -----\n")
#sys.exit(0)
for i in alfabeto:
    for j in alfabeto:
        for k in alfabeto:
            for l in alfabeto:
                key_aux = i+j+k+l
              
                usr_key = preparing_key_array(key_aux)
                S = KSA(usr_key)
                keystream = np.array(PRGA(S, len(dec_msg)))
                msg = encrypt(S, keystream, dec_msg)
                msgHex = msg.astype(np.uint8).data.hex()
                print("Genereting Key's: ", key_aux)
                if msgHex[(len(hex_input)-2):len(hex_input)] == "2e":
                    print("\n##### KEY FOUND #######")
                    print("Mensagem decifrada HEX: ", msgHex)
                    print("----------------------")
                    print("Mensagem decifrada e': ",bytes.fromhex(msgHex).decode('utf-8') )
                
                    sys.exit(0)


