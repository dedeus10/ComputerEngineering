#include <stdio.h>
#include <stdlib.h>
FILE *trace;

typedef struct lista
{
    int info;
    int id;
    struct lista* ant;
    struct lista* prox;
} Lista;


Lista* lst_cria(void);
Lista* lst_insere(Lista* l, int v);
Lista* ultimo (Lista* l);
Lista* lst_retira_ant (Lista* l, int v);
Lista* lst_busca(Lista* l, int v);
Lista* insere_crescente(Lista* l, int valor, int ident);
Lista* retira (Lista* l, int v);
int lst_imprime(Lista *l, int contador_global_tempo);
int lst_conta(Lista* l);
void lst_desaloca(Lista* l);



Lista* lst_cria(void)
{
    return NULL;
}

// inserção no início: retorna a lista atualizada
Lista* lst_insere(Lista* l, int v)
{
    Lista* novo = (Lista*) malloc(sizeof(Lista));

    novo->info = v;
    novo->prox = l;
    novo->ant = NULL;

    if(l != NULL)
        l->ant = novo;

    return novo;
}


// retorna ultimo elemento da lista
Lista* ultimo (Lista* l)
{
    Lista* p = l;
    if (p != NULL)
    {
        while (p->prox != NULL)
            p= p->prox;
    }
    return p;
}



// função busca: busca um elemento na lista
Lista* lst_busca(Lista* l, int v)
{
    Lista* p = l;

    while(p != NULL && p->info != v)
        p = p->prox;


    return p;
}

int lst_imprime(Lista* l,int contador_global_tempo)
{
    Lista* p;
    int cont = 0;
    for(p = l; p != NULL; p = p->prox)
    {
        printf("Posicao [%d] da lista contem o elemento ID: %d com prioridade %d \n", cont, p->id ,p->info);
        fprintf(trace,"Posicao [%d] da lista contem o elemento ID: %d com prioridade %d \n", cont, p->id ,p->info);
        cont++;
    }


    printf("\n");
    fprintf(trace,"\n");
    fprintf(trace,"GT[%d]->O numero de elementos na Lista de I/O e' %d \n",contador_global_tempo, cont);
    printf("GT[%d]->O numero de elementos na Lista de I/O e' %d \n",contador_global_tempo, cont);
    return(cont);
}

int lst_conta(Lista* l)
{
    Lista* p;
    int cont = 0;
    for(p = l; p != NULL; p = p->prox)
    {
        cont++;
    }

    return(cont);
}

void lst_desaloca(Lista* l)
{
    Lista* p = l;

    while(p != NULL)
    {
        l = p->prox;
        free(p);
        p = l;
    }
}



Lista* insere_crescente(Lista* l, int valor, int ident)
{
    Lista* p = l;
    Lista* ant = NULL;

    while(p != NULL && p->info < valor)
    {
        ant = p;
        p = p->prox;
    }

    Lista* novo = (Lista*) malloc(sizeof(Lista));
    novo->info = valor;
    novo->id = ident;

    if(ant == NULL)  //insere no inicio
    {
        novo->prox = l;
        l = novo;
    }
    else  //insere meio ou fim
    {
        novo->prox = ant->prox;
        ant->prox = novo;
    }

    return l;
}

/* função retira: retira elemento da lista */
Lista* retira (Lista* l, int v)
{
    Lista* ant = NULL; /* ponteiro para elemento anterior */
    Lista* p = l; /* ponteiro para percorrer a lista*/
    /* procura elemento na lista, guardando anterior */
    while (p != NULL && p->id != v)
    {
        ant = p;
        p = p->prox;
    }
    /* verifica se achou elemento */
    if (p == NULL)
        return l; /* não achou: retorna lista original */
    /* retira elemento */
    if (ant == NULL)
    {
        /* retira elemento do inicio */
        l = p->prox;
    }
    else
    {
        /* retira elemento do meio da lista */
        ant->prox = p->prox;
    }
    free(p);
    return l;
}
