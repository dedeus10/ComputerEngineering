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
#-- Design      : RC4                                                          --
#-- File		: RC4.py                    	                          	   --
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
#-- "python3 -O RC4.py"  -> usa inputs do usuario                              --
#-- "python3 RC4.py"     -> usa parametros pre definidos                       --
#-- Usado para verificar: http://rc4.online-domain-tools.com                   --
#--------------------------------------------------------------------------------
#

import numpy as np
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
plainText = (str(input(('Informe a mensagem: '))))
usr_key = (str(input(('Informe a chave: '))))

print("-------Starting RC4 Algorithm-----")
if(__debug__):
    print("****Usando parametros pre-definidos")
    usr_key = 'SEGREDE'
    plainText = 'Mission Accomplished'

###ORDENA ARRAY
usr_key = preparing_key_array(usr_key)

S = KSA(usr_key)

keystream = np.array(PRGA(S, len(plainText)))
#print("Key Stream: ")
#print(keystream)

plainText = np.array([ord(i) for i in plainText])
cipher = encrypt(S, keystream, plainText)
print("----------------------------------------------")
print("Mensagem cifrada: ")
print( cipher.astype(np.uint8).data.hex())
msg = encrypt(S, keystream, cipher)
msgHex = msg.astype(np.uint8).data.hex()

print("----------------------------------------------")
print("Mensagem decifrada em Hexa: ")
print(msgHex)

print("----------------------------------------------")
print("Mensagem decifrada: ")
print(bytes.fromhex(msgHex).decode('utf-8'))
