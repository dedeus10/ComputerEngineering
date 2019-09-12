/*

	UNIVERSIDADE FEDERAL DE SANTA MARIA
		CENTRO DE TECNOLOGIA
	CURSO DE ENGENHARIA DE COMPUTAÇÃO

		Sistemas Operacionais

	Autor: Luis Felipe de Deus
	Data:24/10/17
	Atualização:17/11/17

	Obejtivo: Fazer um escalonar de processos, contendo CPU, I/O, tempo para gerar processos, tempo para fazer I/O,
	tempo em que fica no I/O, exclusão da CPU por burst time, fatia de tempo ou  I/O, manipulação de filas de chegada
	e fila de prontos e lista para I/O com prioridade


*/


//Libraries
#include <stdio.h>
#include <stdlib.h>
#include "fila_ready.h"     //Header da Ready Queue
#include "fila_arrive.h"    //Header da Arrive Queue
#include "cria_proc.h"      //Header da Create Process
#include "list_i_o.h"       //Header da List I/O

//Global Variables
unsigned long int contador_global_tempo = 0;            //Variavel que faz a contagem do tempo de simulação
unsigned long int cont_tempo_cria_processo = 0;         //Variavel que faz a contagem até chegar o tempo de criar processos
int fatia_tempo = 0;                                    //Variavel que faz a contagem até chegar a fatia de tempo Round_Robin na CPU
int flag_pode_pegar_cpu = 1;                            //Flag que diz quando pode pegar a CPU
int flag_pode_criar_processo = 1;                       //Flag que diz quando pode criar processos
int flag_pode_pegar_i_o = 1;                            //Flag que diz quando pode pegar o Device

int flag_i_o_ja_visto = 0;                              //Flag para imprimir só uma vez quem esta no I/O

int intervalo_geracao_processos = 0;                    //Variavel que obtem o valor aleatorio de quando gerar processos
int tempo_i_o = 0;                                      //Variavel que obtem o valor aleatorio de quando pode fazer I/O
int tempo_i_o_processo = 0;                             //Variavel que obtem o valor aleatorio de quanto um processo fica em I/o

int faixa_geracao_processos = 5;                        //Variavel que tem a faixa do random para geração de processos
int faixa_tempo_qnd_fazer_io = 10;                      //Variavel que tem a faixa do random para quando pode fazer I/O
int faixa_tempo_uso_io = 10;                            //Variavel que tem a faixa do random para tempo de uso do I/O

int ocupando_i_o = -1;                                  //Variavel que diz quem esta ocupando o Device
int ocupando_CPU = -1;                                  //Variavel que diz quem esta ocupando a CPU

int contador_tempo_i_o = 0;                             //Variavel que faz a contagem do tempo que o processo esta no I/O
int cont_qnd_fazer_i_o = 0;                             //Variavel que faz a contagem do tempo em que um processo pode ir para I/O

int contador_processos_terminados = 0;                  //Variavel que faz a contagem de quantos processos terminaram o CPU time
int contador_processos_terminaram_i_o = 0;              //Variavel que faz a contagem de quantos processos terminaram o I/O
int contador_cpu_ociosa = 0;                            //Variavel que faz a contagem de quanto tempo CPU ficou Ociosa

int tempo_turnaround_total = 0;                         //Variavel que faz a contagem do tempo de turnaround total
float turnaround_medio = 0.0;                           //Variavel que calcula o turnaround medio

int tempo_espera_imprime = 0;                           //Variavel utilizado para printar o tempo de espera
int tempo_espera_total = 0;                             //Variavel que faz a contagem de quanto tempo os processos esperaram para ganhar a CPU
float tempo_espera_medio = 0.0;                         //Variavel que calcula o tempo medio de espera pela CPU

float porcentagem_CPU_ociosa = 0.0;                     //Variavel que calcula a porcentagem de CPU ociosa
float porcentagem_CPU_executando = 0.0;                 //Variavel que calcula a porcentagem de CPU executando
float porcentagem_I_O = 0.0;                            //Variavel que calcula a porcentagem de I/O

int tempo_total_usado_i_o = 0;                          //Variavel que calcula o tempo total usado para I/O
int tempo_pegou_i_o = -1;                               //Variavel que pega o tempo que o processo pegou o I/O

int tempo_uso_CPU_total = 0;                            //Variavel que armazena o tempo total que a CPU foi usada

int cont_processo_vai_pro_i_o = 0;                      //Variavel que faz a contagem de quanos processos foram pro i/o
int auxiliar_i_o = 1;                                   //Auxiliar para saber a hora de fazer I/O

unsigned int contador_tamanho_fila_arrive = 0;          //Contador do tamanho da fila arrive
unsigned int contador_tamanho_fila_ready = 0;           //Contador do tamanho da fila ready
unsigned int contador_tamanho_lista = 0;                //Contador do tamanho da lista

float media_fila_arrive = 0;                            //Variavel que armazena a media do tamanho da fila arrive
float media_fila_ready = 0;                             //Variavel que armazena a media do tamanho da fila ready
float media_lista = 0;                                  //Variavel que armazena a media do tamanho da lista

int transferencia_fila = 0;                             //Variavel que armazena o valor que vai de uma fila para outra
int tamanho_lista = 0;                                  //Variavel que armazena o tamanho da lista

int contador_tempo_total_espera_arrive = 0;             //Variavel que faz a contagem do tempo de espera total na fila arrive
int contador_tempo_total_espera_ready = 0;              //Variavel que faz a contagem do tempo de espera total na fila ready
int contador_tempo_total_espera_lista = 0;                                //Variavel que faz a contagem do tempo de espera total na lista

int cont_processos_entraram_lista = 0;                  //Variavel que faz a contagem dos processos que entraram na lista
int cont_processos_entraram_ready = 0;                  //Variavel que faz a contagem dos processos que entraram fila ready

int tamanho_sistema = 0;                                //Variavel que contem o tamanho atual do sistema em numero de processos

//Variaveis de entrada
int tempo_total_simulacao = 0;                          //Variavel que contem o tempo total de simulação
int ML = 0;                                             //Variavel que contem o grau de multiprogramação
int Round_Robin = 0;                                    //Variavel que contem a fatia do round robin

//Nome do arquivo do trace
char Nome_arq[] = {"trace.txt"};

//Definição da Lista e inicialização
Lista* l = NULL;

//Definições do Arquicvos
FILE *trace;
FILE *F_input;
FILE *F_output;

//Prototipos de Funções
void manipula_arrive(int id_proc,struct processos p[TAM]);
void manipula_sistema(struct processos p[TAM]);
void cpu(int id_proc,  struct processos p[TAM]);
void processo_concluido(int id_proc, struct processos p[TAM]);
void fim_fatia_tempo(int id_proc,struct processos p[TAM]);
void i_o(int id_proc, struct processos p[TAM]);
void fazendo_i_o(struct processos p[TAM]);
void aleatory();
void calc_imprime_results(struct processos p[TAM], int processo);
void verifica_filas();

//Função que manipula as Filas do programa
void manipula_arrive(int id_proc,struct processos p[TAM])
{

    //Insere na Fila ARRIVE
    insere_a(p[id_proc].id, contador_global_tempo);    //Insere na fila de chegada ARRIVE QUEUE

    //Seta o o campo da struct para saber quando o processo chegou na Arrive
    p[id_proc].entrada_na_arrive = contador_global_tempo;

    //Impressoes
    fprintf(trace,"\nGT[%ld]->Processo inserido ID:[%d]\n",contador_global_tempo, p[id_proc].id);
    printf("\nGT[%ld]->Processo inserido ID:[%d]\n",contador_global_tempo, p[id_proc].id);

    printf("GT[%ld]->Processo ID:[%d] esta no Estado: NEW\n", contador_global_tempo,p[id_proc].id);
    fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: NEW\n", contador_global_tempo,p[id_proc].id);

    //Mostra a Fila Arrive
    mostra_a(contador_global_tempo);
}

void manipula_sistema(struct processos p[TAM])
{

    //Variaveis locais
    int tamanho_fila_ready =0;
    int diferenc_tempo = 0;
    int cont = 0;

    //Obtem o tamanho da Fila Ready
    printf("\n\nGT[%ld]->Verificacao do estado da Multiprogramacao do Sistema\n", contador_global_tempo);
    fprintf(trace,"\n\nGT[%ld]->Verificacao do estado da Multiprogramacao do Sistema\n", contador_global_tempo);

    tamanho_fila_ready = mostra_r(contador_global_tempo);

    fprintf(trace,"\nGT[%ld]->Existem %d processos na READY\n",contador_global_tempo,tamanho_fila_ready);
    printf("\nGT[%ld]->Existem %d processos na READY\n",contador_global_tempo,tamanho_fila_ready);

    //Verifica o tamanho da Lista
    tamanho_lista = lst_conta(l);
    tamanho_sistema = tamanho_fila_ready + tamanho_lista;   //O tamanho do sistema sera a soma do tamanho da ready e do tamanho da Lista
    if(ocupando_CPU != -1) tamanho_sistema = tamanho_sistema + 1;   //Verifica se tem um processo usando a CPU, se sim sistema++
    if(ocupando_i_o != -1) tamanho_sistema = tamanho_sistema +1;    //Verifica se tem um processo usando device, se sim sistem++

    cont = conta_a();
    //Se o tamanho do sistema é menor que o Grau de Multiprogramação
    if(tamanho_sistema < (ML) &&  cont !=0)
    {
        //Senao tiver ninguem na CPU seta a flag que alguem pode pegar
        if(ocupando_CPU == -1) flag_pode_pegar_cpu = 1;

        if(p[principal_arrive->valor_arrive].entrada_na_arrive == contador_global_tempo)
        {
            //Nao faz nada porque o processo entrou no mesmo ciclo da arrive
        }
        else
        {

            //Seta a variavel com o primeiro elemento da arrive
            transferencia_fila = principal_arrive->valor_arrive;

            //Calcula a diferenca de tempo entre chegada e saida da arrive
            diferenc_tempo = contador_global_tempo - p[transferencia_fila].entrada_na_arrive;
            p[transferencia_fila].espera_na_arrive = diferenc_tempo;
            //Seta a Flag para informar que o processo saiu da arrive
            p[transferencia_fila].flag_saiu_arrive = 1;

            //Exclui o processo da arrive
            exclui_a(contador_global_tempo);

            printf("GT[%ld]->Processo ID:[%d] esta no Estado: READY\n",contador_global_tempo, transferencia_fila);
            fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: READY\n",contador_global_tempo, transferencia_fila);

            //Insere o processo na fila Ready
            insere_r(transferencia_fila, contador_global_tempo);      //Insere no processo na fila de prontos READY
            //Incrementa contador de processos que entraram na ready
            cont_processos_entraram_ready++;
            //Seta o campo da struct para saber quando o processo entrou na ready
            p[transferencia_fila].entrada_na_ready = contador_global_tempo;

            //Por fim mostra a fila ready atualizada
            mostra_r(contador_global_tempo);

        }

    } //Fim if do Sistema

}//Fim Função Insere

//Inicio função que executa na CPU
void cpu(int id_proc,  struct processos p[TAM])
{

    //EXECUTANDO

    //Se o ID for -1 é porque não tem ninguem, mostra CPU ociosa
    if(id_proc == -1)
    {
        printf("GT[%ld]->CPU OCIOSA\n",contador_global_tempo);
        fprintf(trace,"GT[%ld]->CPU OCIOSA\n",contador_global_tempo);
        contador_cpu_ociosa++;
    }
    else
    {

        fprintf(trace,"\nGT[%ld]->Executando na CPU ID [%d]\n",contador_global_tempo, ocupando_CPU);
        printf("\nGT[%ld]->Executando na CPU ID [%d]\n",contador_global_tempo, ocupando_CPU);

        printf("GT[%ld]->Processo ID:[%d] esta no Estado: RUNNING\n",contador_global_tempo, ocupando_CPU);
        fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: RUNNING\n",contador_global_tempo, ocupando_CPU);

        //Seta o campo da struct para armazenar o tempo que ficou na Fila Ready (t_momento - t_entrada)
        p[id_proc].espera_na_ready = contador_global_tempo - p[id_proc].entrada_na_ready;
        //Seta a flag para dizer que o processo saiu da fila
        p[id_proc].flag_saiu_ready = 1;

        //Calcula o tempo de CPU e atualiza
        p[id_proc].CPU_time = p[id_proc].CPU_time - fatia_tempo;

        //Se o tempo de CPU for 0, chama a funçao que trata a finalização do processo
        if(p[id_proc].CPU_time == 0)
        {
            processo_concluido(id_proc, p);
        }
        //Se não se o tempo que executo é igual a fatia de tempo Round_robin, chama a função que trata o fim do Quantum time
        else if (fatia_tempo == Round_Robin)
        {
            fim_fatia_tempo(id_proc, p);
        }
    }

    //Contador para saber a hora de tratar I/O
    cont_processo_vai_pro_i_o++;
    auxiliar_i_o = tempo_i_o - cont_processo_vai_pro_i_o;
    //Se o contador - frequencia_i_o for 0 é hora de tratar I/O
    if(!auxiliar_i_o)
    {
        //Reseta Flag
        auxiliar_i_o = 1;
        //Reseta Contador
        cont_processo_vai_pro_i_o = 0;

        if(ocupando_CPU != -1 )
        {

            //Seta flag que o processo vai abandonar a CPU, outro pode pegar
            flag_pode_pegar_cpu = 1;

            printf("GT[%ld]->Processo [%d] vai deixar a CPU\n",contador_global_tempo, ocupando_CPU);
            fprintf(trace,"GT[%ld]->Processo [%d] vai deixar a CPU\n",contador_global_tempo, ocupando_CPU);

            //Chama função que trata o I/O
            i_o(ocupando_CPU,p);
            //Seta a flag para não executar a função fazendo_i_o, porque ela é chamada pela i_o() tambem
            flag_i_o_ja_visto = 1;
        }

    }

    //Se for nesse mesmo tempo que o processo pegou o device imprime que no proximo ele vai executar no I/O
    if(tempo_pegou_i_o == contador_global_tempo)
    {
        printf("GT[%ld]->Na proxima unidade de tempo, ID [%d] vai ocupar I/O \n",contador_global_tempo, ocupando_i_o);
        fprintf(trace,"GT[%ld]->Na proxima unidade de tempo, ID [%d] vai ocupar I/O \n",contador_global_tempo, ocupando_i_o);

    }

    //No instante 0 nao deve ter ninguem só imprime I/O Ociosa
    if(!contador_global_tempo || ocupando_i_o == -1)
    {
        printf("GT[%ld]->I/O OCIOSA\n",contador_global_tempo);
        fprintf(trace,"GT[%ld]->I/O OCIOSA\n",contador_global_tempo);
    }

    //Se nesse instante não mostrou quem ta no I/O pela função i_o() então chama a função fazendo_i_o()
    if(!(flag_i_o_ja_visto)) fazendo_i_o(p);

    //Se nao reseta a flag
    else flag_i_o_ja_visto = 0;

    fatia_tempo++;
}//Fim função CPU

//Função que trata a finização do processo
void processo_concluido(int id_proc, struct processos p[TAM])
{
    //Seta a flag para algum processo pegar a CPU
    flag_pode_pegar_cpu = 1;
    //Seta a flag para dizer que o processo acabou a execução
    p[id_proc].flag_processo_acabou = 1;

    fprintf(trace,"\n\nGT[%ld]->Processo [%d] FINALIZADO \n\n",contador_global_tempo, id_proc);
    printf("\n\nGT[%ld]->Processo [%d] FINALIZADO \n\n",contador_global_tempo, id_proc);

    printf("GT[%ld]->Processo ID:[%d] esta no Estado: TERMINATTED\n",contador_global_tempo, ocupando_CPU);
    fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: TERMINATTED\n",contador_global_tempo, ocupando_CPU);

    //Calcula tempo de turnaround do processo (t_momento - t_criacao)
    p[id_proc].t_turnaround = contador_global_tempo - p[id_proc].t_turnaround;

    printf("GT[%ld]->Tempo de TURNAROUND: %d \n",contador_global_tempo,p[id_proc].t_turnaround);
    fprintf(trace,"GT[%ld]->Tempo de TURNAROUND: %d \n",contador_global_tempo,p[id_proc].t_turnaround);

    //Incrementa tempo total do turnaround do sistema
    tempo_turnaround_total = tempo_turnaround_total + p[id_proc].t_turnaround;

    //Calcula o quanto de tempo o processo usou a CPU, ele vai abandonar no proximo T menos o tempo que ele pegou, este tempo é acumulado
    p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo+1) - p[ocupando_CPU].t_pegou_cpu) + p[ocupando_CPU].t_usou_cpu;

    //Coloca a CPU em ocioso
    ocupando_CPU = -1;
    //Incrementa contador de processos que terminaram
    contador_processos_terminados++;

}//Fim Função processo_finalizado

//Função que trata o fim da fatia de tempo
void fim_fatia_tempo(int id_proc,struct processos p[TAM])
{

    fprintf(trace,"\n\nGT[%ld]->Processo [%d] ACABOU O QUANTUM TIME \n\n",contador_global_tempo, id_proc);
    printf("\n\nGT[%ld]->Processo [%d] ACABOU O QUANTUM TIME \n\n",contador_global_tempo, id_proc);

    printf("GT[%ld]->Processo ID:[%d] esta no Estado: READY\n",contador_global_tempo, ocupando_CPU);
    fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: READY\n",contador_global_tempo, ocupando_CPU);

    //Seta a flag que alguem pode pegar a CPU
    flag_pode_pegar_cpu = 1;

    //Seta um novo tempo de criacao porque ele deixou a CPU
    p[ocupando_CPU].criacao = contador_global_tempo;

    //Insere na ready
    insere_r(id_proc, contador_global_tempo);      //Insere no processo na fila de prontos READY

    //Seta a flag para 0 porque ele voltou para a Fila
    p[id_proc].flag_saiu_ready = 0;
    //Seta o tempo de entrada na Fila
    p[id_proc].entrada_na_ready = contador_global_tempo;

    //Incrementa contador de processos que entraram na ready
    cont_processos_entraram_ready++;

    //Calcula tempo de uso da CPU, ele vai abandonar no proximo T menos o tempo que ele pegou, este tempo é acumulado
    p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo+1) - p[ocupando_CPU].t_pegou_cpu)+ p[ocupando_CPU].t_usou_cpu;

    //Seta a CPU para ociosa
    ocupando_CPU = -1;
}//Fim função fim_fatia

//Função que trata o I/O
void i_o(int id_proc, struct processos p[TAM])
{
    //Variavel local
    int cont;

    //Cont recebe o numero de elementos na Lista, que são impressos na tela
    cont = lst_imprime(l,contador_global_tempo);

    //Se a flag diz que pode pegar o Device
    if(flag_pode_pegar_i_o) //Se pode pegar o device
    {
        //Zera a flag
        flag_pode_pegar_i_o = 0;

        //Se a fila ta vazia e tem um processo válido
        if((!cont) && id_proc != -1)
        {
            //Processo recebe Device
            ocupando_i_o = id_proc;

            printf("GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, ocupando_i_o);
            fprintf(trace,"GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, ocupando_i_o);

            //Seta o tempo em que um processo pegou o device
            tempo_pegou_i_o = contador_global_tempo;
            //Seta o tempo que este processo pegou o device
            p[ocupando_CPU].criacao = contador_global_tempo;

            //Calcula tempo de uso da CPU, ele vai abandonar no proximo T menos o tempo que ele pegou, este tempo é acumulado
            p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo+1) - p[ocupando_CPU].t_pegou_cpu) + p[ocupando_CPU].t_usou_cpu;

            //Coloca a CPU em ociosa
            ocupando_CPU = -1;
        }

        //Se a lista não esta vazia
        else if ((cont != 0))
        {
            //Seta o tempo
            p[ocupando_CPU].criacao = contador_global_tempo;

            //Calcula tempo de uso da CPU, ele vai abandonar no proximo T menos o tempo que ele pegou, este tempo é acumulado
            p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo+1) - p[ocupando_CPU].t_pegou_cpu) + p[ocupando_CPU].t_usou_cpu;

            //Coloca a CPU em Ocioso
            ocupando_CPU = -1;

            printf("GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, p[id_proc].id);
            fprintf(trace,"GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, p[id_proc].id);

            //Insere na lista por prioridade
            l = insere_crescente(l, p[id_proc].prioridade_I_O, p[id_proc].id);

            //Seta a flag que voltou pra lista
            p[ocupando_i_o].flag_saiu_lista = 0;

            //Seta o tempo que o processo entrou na lista
            p[id_proc].entrada_na_lista = contador_global_tempo;

            //Incrementa o numero de processos que entraram na Lista
            cont_processos_entraram_lista++;

            fprintf(trace,"GT[%ld]->A lista de I/O foi ATUALIZADA: \n",contador_global_tempo);
            printf("GT[%ld]->A lista de I/O foi ATUALIZADA: \n",contador_global_tempo);

            // Da o Device ao primeiro da Lista, ou seja o que tem prioridade maxima (menor valor)
            ocupando_i_o = l->id;

            //Seta o tempo que algum processo pegou o device
            tempo_pegou_i_o = contador_global_tempo;

            //Calcula tempo de espera na lista, t_momento - t_entrada
            p[ocupando_i_o].espera_na_lista = contador_global_tempo - p[ocupando_i_o].entrada_na_lista;

            //Seta a flag que saiu da lista
            p[ocupando_i_o].flag_saiu_lista = 1;

            //Retira da lista o primeiro elemento
            l = retira(l,ocupando_i_o);

            printf("GT[%ld]->O processo ID [%d] foi excluido da Lista\n",contador_global_tempo, ocupando_i_o);
            fprintf(trace,"GT[%ld]->O processo ID [%d] foi excluido da Lista\n",contador_global_tempo, ocupando_i_o);
        }//FIm if lista não vazia

        //Se não seta I/O como ociosa
        else
        {
            ocupando_i_o = -1;
            flag_pode_pegar_i_o = 1;
        }

    }//FIm if de que pode pegar device


    else //Se não pode pegar o i/o insere na lista
    {

        fprintf(trace,"GT[%ld]->Processo a ser inserido e' [%d] e tem prioridade: %d \n",contador_global_tempo, p[id_proc].id, p[id_proc].prioridade_I_O);
        printf("GT[%ld]->Processo a ser inserido e' [%d] e tem prioridade: %d \n",contador_global_tempo, p[id_proc].id, p[id_proc].prioridade_I_O);

        //Seta o tempo de criacao
        p[ocupando_CPU].criacao = contador_global_tempo;
        //Calcula tempo de uso de CPU
        p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo+1) - p[ocupando_CPU].t_pegou_cpu) + p[ocupando_CPU].t_usou_cpu;

        printf("GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, p[id_proc].id);
        fprintf(trace,"GT[%ld]->Processo ID:[%d] vai para o Estado: BLOCKED\n",contador_global_tempo, p[id_proc].id);

        //Seta a CPU como ociosa
        ocupando_CPU = -1;
        //Insere por prioridade o processo na lista
        l = insere_crescente(l, p[id_proc].prioridade_I_O, p[id_proc].id);

        //Incrementa o contador de processos que entraram na lista
        cont_processos_entraram_lista++;

        //Seta o tempo que processo entrou na lista
        p[id_proc].entrada_na_lista = contador_global_tempo;
        //Seta a Flag que o processo voltou para a lista
        p[ocupando_i_o].flag_saiu_lista = 0;


        fprintf(trace,"GT[%ld]->A lista de I/O foi ATUALIZADA: \n",contador_global_tempo);
        printf("GT[%ld]->A lista de I/O foi ATUALIZADA: \n",contador_global_tempo);

        //Imprime a lista Atualizada
        lst_imprime(l,contador_global_tempo);

    }//Fim else de que nao pode pegar o deivce

    //Se o tempo que alguem pegou é diferente do tempo do momento
    if(tempo_pegou_i_o != contador_global_tempo && ocupando_i_o != -1)
    {
        //Mostra quem ta fazendo I/O
        fprintf(trace,"GT[%ld]->Processo Fazendo I/O e' ID: [%d] \n",contador_global_tempo, ocupando_i_o);
        printf("GT[%ld]->Processo Fazendo I/O e' ID: [%d] \n",contador_global_tempo, ocupando_i_o);
    }


    //Chama a função de execução de I/O
    fazendo_i_o(p);
}//Fim função i/o()

//Inicio função que trata a execução ate certo ponto do I/O
void fazendo_i_o(struct processos p[TAM])
{
    //Varivavel Global
    int cont;

    //Se o device nao ta ocioso
    if(ocupando_i_o != -1)
    {
        //Se o acabou o tempo de i/o do processo
        if(contador_tempo_i_o == tempo_i_o_processo)    //QUando ele sair do IO
        {
            //Zera o contador
            contador_tempo_i_o = 0;

            flag_pode_pegar_i_o = 1;

            fprintf(trace,"GT[%ld]->Processo [%d] esta DEIXANDO IO \n",contador_global_tempo, ocupando_i_o);
            printf("GT[%ld]->Processo [%d] esta DEIXANDO IO \n",contador_global_tempo, ocupando_i_o);

            //Incrementa contador de processos que finalizaram o I/O
            contador_processos_terminaram_i_o++;

            //Se a CPU tiver ociosoa e a flag de CPU tiver em 0, seta a flag para 1
            if((ocupando_CPU == -1) && (flag_pode_pegar_cpu == 0)) flag_pode_pegar_cpu = 1;

            //Seta o tempo de criacao
            p[ocupando_i_o].criacao = contador_global_tempo;
            printf("Processo ID:[%d] esta no Estado: READY\n", ocupando_i_o);

            //Insere processo na fila Ready
            insere_r(ocupando_i_o,contador_global_tempo);

            //Seta a flag que voltou para a ready
            p[ocupando_i_o].flag_saiu_ready = 0;
            //Seta o tempo em que entrou na ready
            p[ocupando_i_o].entrada_na_ready = contador_global_tempo;
            //Incrementa contador de processos que entraram na ready
            cont_processos_entraram_ready++;

            //Calcula o tempo de I/O usado, variavel acumulativa
            tempo_total_usado_i_o = (contador_global_tempo - tempo_pegou_i_o) + tempo_total_usado_i_o;

            //Seta o I/O para ocioso
            ocupando_i_o = -1;

            //Acabou o anterior tenta escalonar o proximo da lista para o device
            cont = lst_imprime(l,contador_global_tempo);

            //Se tem alguem na lista
            if(cont != 0)
            {
                //Pega o primeiro da lista e da o device
                ocupando_i_o = l->id;
		
				flag_pode_pegar_i_o = 0;		

                cont_processo_vai_pro_i_o = 0;

                //Seta o tempo em que algum processo pegou o device
                tempo_pegou_i_o = contador_global_tempo;

                //Calcula tempo de espera na lista
                p[ocupando_i_o].espera_na_lista = contador_global_tempo - p[ocupando_i_o].entrada_na_lista;
                //Seta a flag que saiu da lista
                p[ocupando_i_o].flag_saiu_lista = 1;

                //Retira da lista
                l = retira(l,ocupando_i_o);

                printf("GT[%ld]->O processo ID [%d] foi excluido da Lista\n",contador_global_tempo, ocupando_i_o);
                fprintf(trace,"GT[%ld]->O processo ID [%d] foi excluido da Lista\n",contador_global_tempo, ocupando_i_o);

            }

        }//Fim if de acabou o tempo de I/O

        else  //Se não ta na hora de sair
        {
            //Mostra quem o estado do processo
            if(tempo_pegou_i_o != contador_global_tempo)
            {
                printf("GT[%ld]->Processo ID:[%d] esta no Estado: BLOCKED\n",contador_global_tempo, ocupando_i_o);
                fprintf(trace,"GT[%ld]->Processo ID:[%d] esta no Estado: BLOCKED\n",contador_global_tempo, ocupando_i_o);
            }
            //Incrementa contador do I/O
            contador_tempo_i_o++;
        }
    }//Fim if de alguem ocupando o device

}//Fim função fazendo_i_o

//Função que gera numeros aleatorios
void aleatory()
{
    //Variaveis globais
    int k = 0;
    int num[TAM];

    //Gera um vetor de numeros aleatorios
    srand(time(NULL));
    for(k=0; k<faixa_geracao_processos; k++)    num[k] = rand()%faixa_geracao_processos;

    //DO vetor gerado escolhe uma posição qualquer para ser bem aleatorio
    intervalo_geracao_processos = num[3];

    srand(time(NULL));
    for(k=0; k<faixa_tempo_uso_io; k++)    num[k] = rand()%faixa_tempo_uso_io;

    tempo_i_o_processo = num[2];     //Tempo que o processo fica no I/O

    srand(time(NULL));
    for(k=0; k<faixa_tempo_qnd_fazer_io; k++)    num[k] = rand()%faixa_tempo_qnd_fazer_io;

    tempo_i_o = num[0];              //De quanto em quanto tempo alguem deve ir pro I/O

	//Descomentar para forçar valores
    //intervalo_geracao_processos = 1;
    //tempo_i_o_processo = 2;
	//tempo_i_o = 6;


    printf("O intervalo de geracao de processos e': %d unidades de tempo \n",intervalo_geracao_processos);
    printf("O tempo de uso do I/O por processo e':  %d unidades de tempo \n",tempo_i_o_processo);
    printf("O intervalo de solicitacoes de I/O e':  %d unidades de tempo \n",tempo_i_o);
    fprintf(trace,"O intervalo de geracao de processos e': %d unidades de tempo \n",intervalo_geracao_processos);
    fprintf(trace,"O tempo de uso do I/O por processo e':  %d unidades de tempo \n",tempo_i_o_processo);
    fprintf(trace,"O intervalo de solicitacoes de I/O e':  %d unidades de tempo \n",tempo_i_o);

}//Fim função aleatory()

//Função que verifica as filas
void verifica_filas()
{
    //Variavel local
    int aux = 0;

    //aux contem o numero de elementos da fila
    aux = conta_a();
    //Incrementa o tamanho total da fila a cada unidade de tmepo
    contador_tamanho_fila_arrive = aux + contador_tamanho_fila_arrive;


    //aux contem o numero de elementos da fila
    aux = 0;
    aux = conta_r();
    //Incrementa o tamanho total da fila a cada unidade de tmepo
    contador_tamanho_fila_ready = aux+ contador_tamanho_fila_ready;


    //aux contem o numero de elementos da lista
    aux = 0;
    aux = lst_conta(l);
    //Incrementa o tamanho total da lista a cada unidade de tmepo
    contador_tamanho_lista = aux + contador_tamanho_lista;


}//Fim função verifica_fila

//Função principal
int main()
{
    //Referencia da struct
    struct processos p[TAM];

    //Variavel local
    int processo = 0;       //Variavel que recebe e armazena o id do processo na main

    //Variaveis Arquivo Input
    char leitura[100];
    int cont_line = 0;

    //Abre o arquivo
    F_input = fopen("input.txt", "rt");
    //Verifica se foi realmente aberto
    if(F_input==NULL)
    {
        printf("Problema ! \n");
        exit(0);

    }

    //Faz a leitura por linha dos elementos da arquivo de entrada
    while(feof(F_input) == 0)
    {
        fgets(leitura,100,F_input);
        if(cont_line == 0) tempo_total_simulacao = atoi(leitura);
        else if(cont_line == 1) ML = atoi(leitura);
        else if(cont_line == 2) Round_Robin = atoi(leitura);

        cont_line++;
    }

    //Fecha o arquivo de saida
    fclose(F_input);

    //Abre o arquivo de trace de executação
    trace = fopen(Nome_arq, "wt");
    fprintf(trace,"ARQUIVO QUE CONTEM O TRACE DE EXECUCAO \n\n\nGT is Global Time Counter\n");

    //Verifica se foi realmente aberto
    if(trace == NULL)
    {
        printf("Erro, nao foi possivel abrir o arquivo\n");
        exit(0);
    }

    //Imprime e salva no arquivo alguns paramentros
    printf("O Tempo Total e' %d \n",tempo_total_simulacao);
    printf("O Grau de Multiprogramacao e' %d \n",ML);
    printf("A Fatia do Round Robin e' %d \n",Round_Robin);

    fprintf(trace,"O Tempo Total e' %d \n",tempo_total_simulacao);
    fprintf(trace,"O Grau de Multiprogramacao e' %d \n",ML);
    fprintf(trace,"A Fatia do Round Robin e' %d \n",Round_Robin);

    printf("\nGERANDO ALEATORIOEDADES PARA A EXEC. \n");
    fprintf(trace,"\nGERANDO ALEATORIOEDADES PARA A EXEC. \n");

    //Chama função que gera numeros aleatorios
    aleatory();

    //Loop de execução que simula o sistema, cada iteração é umidade de tempo do sistema
    for(contador_global_tempo=0; contador_global_tempo<tempo_total_simulacao; contador_global_tempo++)
    {
        //Se pode criar procesos
        if(flag_pode_criar_processo)
        {
            //Zera a flag
            flag_pode_criar_processo = 0;

            //Chama função que cria o processo no Header
            processo = cria_processo(p,contador_global_tempo);

            //Processo criado chama a função insere para manipular as filas
            manipula_arrive(processo,p);


        }


        manipula_sistema(p);

        //Se pode pegar a CPU
        if(flag_pode_pegar_cpu)
        {

            int cont_r = 0;

            //Verifica se tem alguem na fila ready
            cont_r = conta_r();

            //Se tem alguem
            if(cont_r != 0)
            {
                if(p[principal_ready->valor_ready].entrada_na_ready == contador_global_tempo )
                {
                        //Nao ganha CPU porque foi o tempo que ele chegou na ready
                }
                else
                {
                    //Zera a flag para ninguem pegar a CPU
                    flag_pode_pegar_cpu = 0;

                    //Processo ganha a CPU
                    ocupando_CPU = principal_ready->valor_ready;

                    //Seta o campo da struct para saber o tempo em que o processo pegou a CPU
                    p[ocupando_CPU].t_pegou_cpu = contador_global_tempo;

                    //Calcula o tempo que ele esperou pelo recurso
                    tempo_espera_imprime = contador_global_tempo - p[ocupando_CPU].criacao;        //t_Momento - t_criacao

                    //Acumula o tempo que o processo ficou esperando
                    p[ocupando_CPU].t_espera = p[ocupando_CPU].t_espera + tempo_espera_imprime;     //Tempo espera total por processo

                    //Acumula o tempo geral que os processos ficaram esperando
                    tempo_espera_total = tempo_espera_total + p[ocupando_CPU].t_espera;

                    //Exclui o primeiro da fila ready
                    exclui_r(contador_global_tempo);

                    printf("\nGT[%ld]->Tempo de espera do Processo ID:[%d] foi: %d \n",contador_global_tempo, ocupando_CPU, tempo_espera_imprime);
                    fprintf(trace,"\nGT[%ld]->Tempo de espera do Processo ID:[%d] foi: %d \n",contador_global_tempo, ocupando_CPU, tempo_espera_imprime);
                }
            }
            //Se a fila estiver vazia
            else
            {
                //CPU fica ociosa
                ocupando_CPU = -1;

            }

            //Zera a fatia de tempo de execução
            fatia_tempo = 0;
        }

        //Chama a função que vai para a CPU
        cpu(ocupando_CPU, p);

        //Incrementa contador de tempo para criar processos
        cont_tempo_cria_processo++;

        //Se o tempo for = ao intervalo que se deve criar...
        if(cont_tempo_cria_processo == intervalo_geracao_processos)
        {
            //Seta a flag para na proxima execução criar
            flag_pode_criar_processo = 1;
            //Reseta contador
            cont_tempo_cria_processo = 0;
        }

        //Chama função para vericar como estão as filas
        verifica_filas();

        fprintf(trace,"\n\n###########FIM DA [%ld] UNIDADE DE TEMPO GLOBAL###################\n\n", contador_global_tempo);
        printf("\n\n###########FIM DA [%ld] UNIDADE DE TEMPO GLOBAL###################\n\n", contador_global_tempo);
    }//Fim do for do sistema

    //Se acabou a execução e tinnha alguem na CPU calcula o tempo de uso dele
    if(ocupando_CPU!=-1) p[ocupando_CPU].t_usou_cpu = ((contador_global_tempo) - p[ocupando_CPU].t_pegou_cpu) + p[ocupando_CPU].t_usou_cpu;

    //Se acabou a execução e tinha alguem no I/O incrementa o tempo de I/O usado
    if(ocupando_i_o!=-1) tempo_total_usado_i_o = (contador_global_tempo - tempo_pegou_i_o)+tempo_total_usado_i_o;

    //Chama função que calcula as estatisticas e imprime
    calc_imprime_results(p,processo);

    //Fecha o arquivo do trace
    fclose(trace);
    //Desaloca a memoria da lista
    lst_desaloca(l);

    return 0;
}//Fim função main

//Função que calcula e imprime as estatisticas
void calc_imprime_results(struct processos p[TAM], int processo)
{
    //Variaveis locais
    int k = 0;

    //Abre o arquivo de saída
    F_output = fopen("output.txt", "wt");
    fprintf(F_output,"ARQUIVO QUE CONTEM A SAÍDA DE DADOS DA EXECUCAO \n\n\n");
    //Testa se foi aberto
    if(F_output == NULL)
    {
        printf("Erro, nao foi possivel abrir o arquivo\n");
        exit(0);
    }

    //Se teve pelo menos 1 processo que finalizou calcula o turnaround medio
    if(contador_processos_terminados>0)turnaround_medio = ((float)(tempo_turnaround_total))/((float)(contador_processos_terminados));

    //Calcula o tempo de espera medio para ganhar a CPU
    tempo_espera_medio = ((float)(tempo_espera_total))/((float)(processo+1));

    //Calcula o tamanho medio das filas Arrive e Ready e da Lista
    media_fila_arrive = contador_tamanho_fila_arrive/contador_global_tempo;
    media_fila_ready = contador_tamanho_fila_ready/contador_global_tempo;
    media_lista = contador_tamanho_lista/contador_global_tempo;

    //Imprime alguns resultados
    printf("%d Processos terminaram sua execucao\n", contador_processos_terminados);
    fprintf(F_output,"%d Processos terminaram sua execucao\n", contador_processos_terminados);

    printf("%d Processos completaram o I/O\n", contador_processos_terminaram_i_o);
    fprintf(F_output,"%d Processos completaram o I/O\n", contador_processos_terminaram_i_o);

    printf("%d Processos foram criados\n", processo+1);
    fprintf(F_output,"%d Processos foram criados\n", processo+1);

    printf("O tempo de TURNAROUND medio e': %.2f\n", turnaround_medio);
    fprintf(F_output,"O tempo de TURNAROUND medio e': %.2f\n", turnaround_medio);

    printf("O tempo de ESPERA medio e': %.2f\n", tempo_espera_medio);
    fprintf(F_output,"O tempo de ESPERA medio e': %.2f\n", tempo_espera_medio);

    printf("\n--------------TEMPO DE ESPERA POR PROCESSO:--------------\n");
    fprintf(F_output,"\n--------------TEMPO DE ESPERA POR PROCESSO:--------------\n");

    //Imprime o tempo de espera por processo
    for(k = 0; k<=processo; k++)
    {
        if(p[k].t_espera != 0)  //Se teve tempo de espera diferente de 0
        {
            printf("O processo [%d] teve tempo de ESPERA TOTAL de: %d\n",k,p[k].t_espera);
            fprintf(F_output,"O processo [%d] teve tempo de ESPERA TOTAL de: %d\n",k,p[k].t_espera);
        }

    }
    printf("Os demais processos tiveram tempo de Espera 0 (zero), ou seja, nao ganharam a CPU\n");
    fprintf(F_output,"Os demais processos tiveram tempo de Espera 0 (zero), ou seja, nao ganharam a CPU\n");

    printf("\n--------------TEMPO DE TURNAROUND POR PROCESSO:--------------\n");
    fprintf(F_output,"\n--------------TEMPO DE TURNAROUND POR PROCESSO:--------------\n");

    //Imprime o tempo de turnaround por processo
    for(k = 0; k<=processo; k++)
    {
        if(p[k].flag_processo_acabou)   //So imprime se ele acabou
        {
            printf("O processo [%d] teve tempo de TURNAROUND de: %d\n",k,p[k].t_turnaround);
            fprintf(F_output,"O processo [%d] teve tempo de TURNAROUND de: %d\n",k,p[k].t_turnaround);
        }
    }

    printf("\n--------------TEMPO DE USO DE CPU POR PROCESSO:--------------\n");
    fprintf(F_output,"\n--------------TEMPO DE USO DE CPU POR PROCESSO:--------------\n");
    //Imprime o tempo de uso de CPU por processo
    for(k = 0; k<=processo; k++)
    {
        if(p[k].t_usou_cpu !=0) //Se o tempo for diferente de 0
        {
            printf("O processo [%d] teve tempo de CPU de: %d\n",k,p[k].t_usou_cpu);
            fprintf(F_output,"O processo [%d] teve tempo de CPU de: %d\n",k,p[k].t_usou_cpu);
            tempo_uso_CPU_total = tempo_uso_CPU_total + p[k].t_usou_cpu;
        }
    }
    printf("Os demais processos nao ganharam a CPU\n");
    fprintf(F_output,"Os demais processos nao ganharam a CPU\n");

    //Imprime mais alguns resultados
    printf("\n--------------RESULTADOS & PORCENTAGENS:--------------\n");
    fprintf(F_output,"\n--------------RESULTADOS & PORCENTAGENS:--------------\n");

    //Calcula Porcentagem da CPU ociosa
    porcentagem_CPU_ociosa = (((float)contador_cpu_ociosa)*100)/tempo_total_simulacao;
    printf("Tempo que a CPU ficou ociosa foi %d, equivalente a %.2f %% \n",contador_cpu_ociosa,porcentagem_CPU_ociosa);
    fprintf(F_output,"Tempo que a CPU ficou ociosa foi %d, equivalente a %.2f %% \n",contador_cpu_ociosa,porcentagem_CPU_ociosa);

    //Calcula a porcentagem que a CPU ficou Executando
    porcentagem_CPU_executando = (((float)tempo_uso_CPU_total)*100)/tempo_total_simulacao;
    printf("Tempo que a CPU foi utilizada foi %d, equivalente a %.2f %% \n",tempo_uso_CPU_total, porcentagem_CPU_executando);
    fprintf(F_output,"Tempo que a CPU foi utilizada foi %d, equivalente a %.2f %% \n",tempo_uso_CPU_total, porcentagem_CPU_executando);

    //Calcula a porcentagem de uso do I/O
    porcentagem_I_O = (((float)tempo_total_usado_i_o)*100)/tempo_total_simulacao;
    printf("Tempo que utilizado para I/O foi %d, equivalente a %.2f %% \n",tempo_total_usado_i_o, porcentagem_I_O);
    fprintf(F_output,"Tempo que utilizado para I/O foi %d, equivalente a %.2f %% \n",tempo_total_usado_i_o, porcentagem_I_O);

    //Imprime as informações sobre as Filas e Lista
    printf("\n------Informacoes sobre as Filas------ \n");
    printf("O tamanho media da Fila Arrive e' %.2f\n", media_fila_arrive);
    printf("O tamanho media da Fila Ready e' %.2f\n", media_fila_ready);
    printf("O tamanho media da Lista de I/O e' %.2f\n", media_lista);

    fprintf(F_output,"\n------Informacoes sobre as Filas------ \n");
    fprintf(F_output,"O tamanho media da Fila Arrive e' %.2f\n", media_fila_arrive);
    fprintf(F_output,"O tamanho media da Fila Ready e' %.2f\n", media_fila_ready);
    fprintf(F_output,"O tamanho media da Lista de I/O e' %.2f\n", media_lista);

    for(k = 0; k<=processo; k++)
    {
        if(!p[k].flag_saiu_arrive)  //Se ele nao saiu da arrive contabiliza o tempo que ele ficou
        {
            p[k].espera_na_arrive = contador_global_tempo - p[k].espera_na_arrive ;
        }
        contador_tempo_total_espera_arrive = contador_tempo_total_espera_arrive + p[k].espera_na_arrive;
    }

    //Calcula o tempo medio de espera na fila arrive
    contador_tempo_total_espera_arrive = contador_tempo_total_espera_arrive / (processo+1);
    printf("\nO tempo medio de espera na ARRIVE foi de %d\n",contador_tempo_total_espera_arrive);
    fprintf(F_output,"\\nO tempo medio de espera na ARRIVE foi de %d\n",contador_tempo_total_espera_arrive);


    for(k = 0; k<=processo; k++)
    {
        //printf("O processo [%d] teve tempo de espera na READY de: %d\n",p[k].id,p[k].espera_na_ready);
        if(!p[k].flag_saiu_ready && p[k].espera_na_ready>0)  //Se ele nao saiu da arrive contabiliza o tempo que ele ficou
        {
            p[k].espera_na_ready = contador_global_tempo - p[k].espera_na_ready ;
        }
        contador_tempo_total_espera_ready = contador_tempo_total_espera_ready + p[k].espera_na_ready;

    }

    //printf("O tempo medio de espera na READY foi de %d\n",contador_tempo_total_espera_ready);
    //Calcula o tempo medio de espera na fila Ready
    if(cont_processos_entraram_ready != 0)
    {
        contador_tempo_total_espera_ready = contador_tempo_total_espera_ready / cont_processos_entraram_ready;
        printf("O tempo medio de espera na READY foi de %d\n",contador_tempo_total_espera_ready);
        fprintf(F_output,"O tempo medio de espera na READY foi de %d\n",contador_tempo_total_espera_ready);
    }
    else printf("Nenhum processo entrou na ready\n");



    for(k = 0; k<=processo; k++)
    {

        if(!p[k].flag_saiu_lista && p[k].espera_na_lista>0)  //Se ele nao saiu da arrive contabiliza o tempo que ele ficou
        {
            p[k].espera_na_lista = contador_global_tempo - p[k].espera_na_lista ;
        }
        //printf("O processo [%d] teve tempo de espera na LISTA de: %d\n",p[k].id,p[k].espera_na_lista);
        contador_tempo_total_espera_lista = contador_tempo_total_espera_lista + p[k].espera_na_lista;

    }
    //printf("O tempo total de espera na LISTA foi de %d\n",contador_tempo_total_espera_lista);
    //Calcula o tempo medio de espera na Lista
    if(cont_processos_entraram_lista != 0)
    {
        contador_tempo_total_espera_lista = contador_tempo_total_espera_lista / cont_processos_entraram_lista;
        printf("O tempo medio de espera na LISTA foi de %d",contador_tempo_total_espera_lista);
        fprintf(F_output,"O tempo medio de espera na LISTA foi de %d",contador_tempo_total_espera_lista);
    }
    else    printf("Nenhum processo entrou na Lista\n");



    //Fecha o arquivo de saída
    fclose(F_output);

}//fim função de calculos e impressoes

//Fim Software
