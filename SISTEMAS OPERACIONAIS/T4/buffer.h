
//HEADER PARA FUN��ES DO BUFFER

//Estrutura da Fila que ser� criada
typedef struct buffer
{
    int ID_buffer;
    struct buffer *proximo_buffer;
} buff;

//Inicializando os dados da lista
buff *principal_buffer = NULL;
buff *final_buffer = NULL;

//Inser��o
void insere_buff(int val)
{

    buff *atual_buffer = (buff*)malloc(sizeof(buff));
    atual_buffer -> ID_buffer = val;
    atual_buffer -> proximo_buffer = NULL;

    //se o principal estiver vazio, ser� o atual
    if(principal_buffer == NULL)
    {
        principal_buffer = final_buffer = atual_buffer;
    }
    //sen�o, o pr�ximo valor que ser� o atual
    else
    {
        final_buffer->proximo_buffer=atual_buffer;
        final_buffer=atual_buffer;
    }


}

//Exclus�o
void exclui_buff()
{
    buff *auxiliar_buffer;
    //o auxiliar ser� o pr�ximo da principal

    auxiliar_buffer=principal_buffer->proximo_buffer;

    //limpando a principal
    free(principal_buffer);
    //a principal ser� a auxiliar
    principal_buffer=auxiliar_buffer;

}

