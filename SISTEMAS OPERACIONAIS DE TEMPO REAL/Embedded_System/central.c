/*

	    UNIVERSIDADE FEDERAL DE SANTA MARIA
		    CENTRO DE TECNOLOGIA
	    CURSO DE ENGENHARIA DE COMPUTAÇÃO

	Sistemas Operacionais de Tempo Real	
	
	Author: Luis Felipe de Deus
	Date:24/05/18
	Update: 1/07/18
	
	Software Desciption: 
    --This software refers to the embedded system client
    *Attributes
        $-> It contains network programming support for a client    
		  

*/

//Libraries
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h> // inet_aton
#include <pthread.h>
#include <time.h>
#include <termios.h>

int sockfd;

void *leitura(void *arg)
{
    char buffer[500];
    int n;
    while (1)
    {
        bzero(buffer, sizeof(buffer));
        n = recv(sockfd, buffer, 500, 0);
        if (n <= 0)
        {
            printf("Error reading to socket!\n");
            exit(1);
        }
        printf("\n[Dóris - Agro Assistant]: %s \n", buffer);
    }
}

int main(int argc, char *argv[])
{
    int portno, n;
    struct sockaddr_in serv_addr;
    pthread_t t;

    char buffer[300];

    //Login
    //   if (login())
    //  {
    if (argc < 3)
    {
        fprintf(stderr, "Use: %s nomehost port\n", argv[0]);
        exit(0);
    }
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        printf("Error creating socket!\n");
        return -1;
    }
    bzero((char *)&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    //    serv_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    inet_aton(argv[1], &serv_addr.sin_addr);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("Error connecting!\n");
        return -1;
    }
    system("clear");
    printf("               ###  Planting Monitoring Center #### \n\n");
    printf("Connection successful with Embedded System !!!\n");
    printf("Data :%s Hora:%s\n\n", __DATE__, __TIME__);

    pthread_create(&t, NULL, leitura, NULL);
    do
    {
        bzero(buffer, sizeof(buffer));
        printf("Type to message:");

        fgets(buffer, 50, stdin);

        n = send(sockfd, buffer, 50, 0);

        if (n == -1)
        {
            printf("Error writing to socket!\n");
            return -1;
        }
        if (strcmp(buffer, "exit\n") == 0)
        {
            break;
        }
        else if (strcmp(buffer, "clear\n") == 0)
        {
            system("clear");
            printf("               ###  Planting Monitoring Center #### \n\n");
        }

    } while (1);
    close(sockfd);
    //}
    return 0;
}

int login()
{
    printf("        ##### Login ##### \n");
    int username_ok = 0;
    int password_ok = 0;
    char username[256];
    char password[256];

    struct termios new, old;

    bzero(username, sizeof(username));
    while (!(username_ok))
    {
        printf("_______________________\n");
        printf("| Username: ");
        fgets(username, 50, stdin);
        if (strcmp(username, "dedeus\n") == 0)
        {
            username_ok = 1;
        }

        else
        {
            printf("| Username is not valid... Try Again \n");
            username_ok = 0;
        }
    }

    //bzero(password,sizeof(password));
    while (!(password_ok))
    {
        printf("| Password: ");

        // salvando atual terminal
        tcgetattr(fileno(stdin), &old);
        new = old;
        new.c_lflag &= ~ECHO; // desligando o ECHO

        // setando novo terminal
        tcsetattr(fileno(stdin), TCSAFLUSH, &new);

        scanf("%s", password);

        // setando para o antigo terminal
        (void)tcsetattr(fileno(stdin), TCSAFLUSH, &old);

        printf("senha %s\n", password);

        if (strcmp(password, "1234") == 0)
        {
            password_ok = 1;
        }

        else
        {
            printf("| Password is incorrect... Try Again \n");
            password_ok = 0;
        }
    }

    return 1;
}
