FILE *trace;

//Estrutura da lista que será criada
typedef struct Fila_ready
{
    int valor_ready;
    struct Fila_ready *proximo_ready;
} Ready;

//Inicializando os dados da lista
Ready *principal_ready = NULL;
Ready *final_ready = NULL;



//Inserção
void insere_r(int val, int contador_global_tempo)
{

    Ready *atual_ready = (Ready*)malloc(sizeof(Ready));
    atual_ready -> valor_ready = val;
    atual_ready -> proximo_ready = NULL;

    //se o principal estiver vazio, será o atual
    if(principal_ready == NULL)
    {
        principal_ready = final_ready = atual_ready;
    }
    //senão, o próximo valor que será o atual
    else
    {
        final_ready->proximo_ready=atual_ready;
        final_ready=atual_ready;
    }

    printf("\nGT[%d]->Processo inserido na READY! ",contador_global_tempo);
    printf("ID:[%d]\n", atual_ready -> valor_ready);
    fprintf(trace,"\nGT[%d]->Processo inserido na READY! ",contador_global_tempo);
    fprintf(trace,"ID:[%d]\n", atual_ready -> valor_ready);
}

//Exclusão
void exclui_r(int contador_global_tempo)
{
    Ready *auxiliar_ready;
    //o auxiliar será o próximo da principal
    fprintf(trace,"\nGT[%d]->Excluido da READY ID:[%d]\n",contador_global_tempo, principal_ready->valor_ready);
    printf("\nGT[%d]->Excluido da READY ID:[%d]\n",contador_global_tempo, principal_ready->valor_ready);
    auxiliar_ready=principal_ready->proximo_ready;
    //limpando a principal
    free(principal_ready);
    //a principal será a auxiliar
    principal_ready=auxiliar_ready;



}

//Mostrando
int mostra_r(int contador_global_tempo)
{
    int posicao=0;
    Ready *nova_ready=principal_ready;
    fprintf(trace,"\nGT[%d]->Mostrando os Processos da READY: \n",contador_global_tempo);
    printf("\nGT[%d]->Mostrando os Processos da READY: \n",contador_global_tempo);
    printf("--------------------------------------\n");
    fprintf(trace,"--------------------------------------\n");
    //laço de repetição para mostrar os valores
    for (; nova_ready != NULL; nova_ready = nova_ready->proximo_ready)
    {
        posicao++;
        printf("Posicao %d, contem o Processo ID:[%d]\n", posicao, nova_ready->valor_ready);
        fprintf(trace,"Posicao %d, contem o Processo ID:[%d]\n", posicao, nova_ready->valor_ready);
    }
    printf("--------------------------------------\n");
    fprintf(trace,"--------------------------------------\n");
    return posicao;
}
//Conta
int conta_r()
{
    int posicao=0;
    Ready *nova_ready=principal_ready;

    //laço de repetição para mostrar os valores
    for (; nova_ready != NULL; nova_ready = nova_ready->proximo_ready)
    {
        posicao++;

    }

    return posicao;
}
