
//HEADER PARA FUNÇÕES DO BUFFER

//Estrutura da Fila que será criada
typedef struct buffer
{
    int ID_buffer;
    struct buffer *proximo_buffer;
} buff;

//Inicializando os dados da lista
buff *principal_buffer = NULL;
buff *final_buffer = NULL;

//Inserção
void insere_buff(int val)
{

    buff *atual_buffer = (buff*)malloc(sizeof(buff));
    atual_buffer -> ID_buffer = val;
    atual_buffer -> proximo_buffer = NULL;

    //se o principal estiver vazio, será o atual
    if(principal_buffer == NULL)
    {
        principal_buffer = final_buffer = atual_buffer;
    }
    //senão, o próximo valor que será o atual
    else
    {
        final_buffer->proximo_buffer=atual_buffer;
        final_buffer=atual_buffer;
    }


}

//Exclusão
void exclui_buff()
{
    buff *auxiliar_buffer;
    //o auxiliar será o próximo da principal

    auxiliar_buffer=principal_buffer->proximo_buffer;

    //limpando a principal
    free(principal_buffer);
    //a principal será a auxiliar
    principal_buffer=auxiliar_buffer;

}

