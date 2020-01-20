############ ALGORITMO DE CRIPTOGRAFIA RSA ############
*** Aluno: Luis Felipe de Deus
*** Curso: Engenharia de Computação
*** Disciplina: Segurança de Rede
*** Linguagem: Python

Nota: Para executar: 
    Requisitos: python3 instalado
    1. Vá a um terminal de sua preferencia
    2.1 digite: python3 RSA.py (Deste jeito o codigo ira executar com parametros pre definidos)
    2.2 digite: python3 -O RSA.py (Deste jeito o codigo ira executar com parametros do usuario)

Nota2: O parametro TAM no codigo define o tamanho do numero aleatorio gerado
       Uma dos problemas enfrentados é o codigo ficar em loop por não achar um numero "d" que satisfaça a condição
       na função generate_D(fi_n, e) existe um print comentado que exibe os valores gerados e calculados