FILE *trace;
//Estrutura da lista que será criada
typedef struct Fila_arrive
{
    int valor_arrive;
    struct Fila_arrive *proximo_arrive;
} Arrive;

//Inicializando os dados da lista
Arrive *principal_arrive = NULL;
Arrive *final_arrive = NULL;



//Inserção
void insere_a(int val, int contador_global_tempo)
{

    Arrive *atual_arrive = (Arrive*)malloc(sizeof(Arrive));
    atual_arrive -> valor_arrive = val;
    atual_arrive -> proximo_arrive = NULL;

    //se o principal estiver vazio, será o atual
    if(principal_arrive == NULL)
    {
        principal_arrive = final_arrive = atual_arrive;
    }
    //senão, o próximo valor que será o atual
    else
    {
        final_arrive->proximo_arrive=atual_arrive;
        final_arrive=atual_arrive;
    }

    fprintf(trace,"\nGT[%d]->Processo inserido na ARRIVE! ",contador_global_tempo);
    fprintf(trace,"ID:[%d]", atual_arrive -> valor_arrive);
    printf("\nGT[%d]->Processo inserido na ARRIVE! ",contador_global_tempo);
    printf("ID:[%d]", atual_arrive -> valor_arrive);
}

//Exclusão
void exclui_a(int contador_global_tempo)
{
    Arrive *auxiliar_arrive;
    //o auxiliar será o próximo da principal
    fprintf(trace,"\nGT[%d]->Excluido da ARRIVE ID:[%d]\n",contador_global_tempo, principal_arrive->valor_arrive);
    printf("\nGT[%d]->Excluido da ARRIVE ID:[%d]\n",contador_global_tempo, principal_arrive->valor_arrive);
    auxiliar_arrive=principal_arrive->proximo_arrive;
    //limpando a principal
    free(principal_arrive);
    //a principal será a auxiliar
    principal_arrive=auxiliar_arrive;



}

//Mostrando
void mostra_a(int contador_global_tempo)
{
    int posicao=0;
    Arrive *nova_arrive=principal_arrive;
    fprintf(trace,"\nGT[%d]->Mostrando os Processos da ARRIVE: \n",contador_global_tempo);
    printf("\nGT[%d]->Mostrando os Processos da ARRIVE: \n",contador_global_tempo);
    printf("--------------------------------------\n");
    fprintf(trace,"--------------------------------------\n");
    //laço de repetição para mostrar os valores
    for (; nova_arrive != NULL; nova_arrive = nova_arrive->proximo_arrive)
    {
        posicao++;
        printf("Posicao %d, contem o Processo ID:[%d]\n", posicao, nova_arrive->valor_arrive);
        fprintf(trace,"Posicao %d, contem o Processo ID:[%d]\n", posicao, nova_arrive->valor_arrive);
    }
    printf("--------------------------------------");
    fprintf(trace,"--------------------------------------");

}

int conta_a()
{
    int posicao=0;
    Arrive *nova_arrive=principal_arrive;

    //laço de repetição para mostrar os valores
    for (; nova_arrive != NULL; nova_arrive = nova_arrive->proximo_arrive)
    {
        posicao++;

    }

    return(posicao);
}
