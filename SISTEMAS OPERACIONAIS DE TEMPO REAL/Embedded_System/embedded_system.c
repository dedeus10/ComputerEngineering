/*

	    UNIVERSIDADE FEDERAL DE SANTA MARIA
		    CENTRO DE TECNOLOGIA
	    CURSO DE ENGENHARIA DE COMPUTAÇÃO

	Sistemas Operacionais de Tempo Real	
	
	Author: Luis Felipe de Deus
	Date:24/05/18
	Update: 1/07/18
	
	Software Desciption: 
    --This software is intended to be the embedded system of the Planting Monitoring Center project
    *Attributes
        $-> It contains three periodic tasks (Sensor readings)
        $-> It contains two tasks that manipulate a hardware periphery whose function is irrigation or agrotoxic
        $-> It contains network programming support for a client
        $-> Function of customer predictions about what is best for planting, as well as the probability of rain or storm related to the average of collated data


*/

//Libraries
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <signal.h>
#include <errno.h>
#include <time.h>
#include <string.h>
#include "libs.h"
#include "libraries.h"

//Definitions
#define N_THREADS 10              //Number of Threads
#define TEMPO_IRRIGAR 10000000000 //TIME of Irrigation in cycles
#define TEMPO_AGROTOX 5000000000  //TIME of Agrotoxic in cycles

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;    //Mutex
pthread_cond_t protection = PTHREAD_COND_INITIALIZER; //Condition Variable

//Global Variables
int newsockfd[5];          //Variable stored the socket will be connected
int id = 0;                //Id
int8_t water = 0;          //Variable containing the state of the irrigation system
int8_t flag_water = 0;     //Flag used to enable or disable the irrigation thread
int8_t agrotoxic = 0;      //Variable containing the state of the apply pesticide
int8_t flag_agrotoxic = 0; //Flag used to enable or disable the apply pesticide

int request_tube = -1;       //Variable mode tube
int pending_request = 0;       //Variable of request that tube (Irrigation or Agrotoxic)
int8_t flag_ativated_tube = 0; //Flag used for activated tubing

//Protoypes Functions
static void *Water(void *threadid);
static void *Agrotoxic(void *threadid);
void *cliente(void *arg);

//Maintains irrigation linked
static void *Water(void *threadid)
{
    long tid;
    tid = (long)threadid;

    unsigned long int i = 0;

    while (1)
    {
        //TAKE MUTEX
        pthread_mutex_lock(&mutex);
        if (flag_water && flag_ativated_tube)
        {
            while (request_tube != 0)
            {
                printf("IRRIGATION SYSTEM IS WAITING FOR TUBE ! \n");
                pthread_cond_wait(&protection, &mutex);
            }
            flag_water = 0;

            printf("IRRIGATION - REQUEST TUBE ACCEPTED \n");

            //DROP MUTEX
            pthread_mutex_unlock(&mutex);

            printf("\n\n---- IRRIGATION ON ----\n\n");

            for (i = 0; i < TEMPO_IRRIGAR; i++)
            {
                water = 1;
            }
            //TAKE MUTEX
            pthread_mutex_lock(&mutex);

            //Requisition answered
            pending_request--;
            //Shutting Down Periferic
            water = 0;
            flag_water = 0;

            // Check if you have any pending requests, if you have not, date plumbing
            if (pending_request == 0)
            {
                flag_ativated_tube = 0;
                request_tube = -1;
            }
            //Chaged tube
            else
                request_tube = 1;

            printf("\n\n---- IRRIGATION OFF ----\n\n");
            //DROP MUTEX
            pthread_mutex_unlock(&mutex);
            pthread_cond_signal(&protection);
        }
        else
        {
            //DROP MUTEX
            pthread_mutex_unlock(&mutex);
        }
    }

    return NULL;
}

//Maintains irrigation linked
static void *Agrotoxic(void *threadid)
{
    long tid;
    tid = (long)threadid;

    unsigned long int i = 0;

    while (1)
    {
        //TAKE MUTEX
        pthread_mutex_lock(&mutex);
        if (flag_agrotoxic && flag_ativated_tube)
        {
            while (request_tube != 1)
            {
                printf("AGROTOXIC SYSTEM IS WAITING FOR TUBE ! \n");
                pthread_cond_wait(&protection, &mutex);
            }

            flag_agrotoxic = 0;

            printf("AGROTOXIC - REQUEST TUBE ACCEPTED \n");

            //DROP MUTEX
            pthread_mutex_unlock(&mutex);

            printf("\n\n---- APPLYING AGROTOXIC ----\n\n");
            for (i = 0; i < TEMPO_AGROTOX; i++)
            {
                agrotoxic = 1;
            }

            //TAKE MUTEX
            pthread_mutex_lock(&mutex);

            //Requisition answered
            pending_request--;
            //Shutting Down Periferic
            agrotoxic = 0;

            // Check if you have any pending requests, if you have not, date plumbing
            if (pending_request == 0)
            {
                flag_ativated_tube = 0;
                request_tube = -1;
            }
            //Chaged modo tube
            else
                request_tube = 0;

            printf("\n\n---- AGROTOXIC OFF ----\n");

            //DROP MUTEX
            pthread_mutex_unlock(&mutex);

            pthread_cond_signal(&protection);
        }
        else
        {
            //DROP MUTEX
            pthread_mutex_unlock(&mutex);
        }
    }

    return NULL;
}

//Therad client Read information from a host and sends information to a host
void *cliente(void *arg)
{
    int cid = (int)arg;
    int i, n;
    char buffer[256];
    char msg1[256];
    char prob_rain[256];
    char prob_storm[256];
    char help_msg[500];
    char status_msg[256] = {"Growing planting! :D \n"};
    char water_msg[256] = {"Irrigation planting! (y) \n"};
    char agrotoxic_msg[256] = {"Applying Agrotoxic in planting! (y) \n"};
    char warning_msg[256] = {"Don't stay in planting - Contamination Warning !!! :x \n"};
    char GPS_msg[256] = {"Location: Santa Maria, Rio Grande do Sul, Brasil \n"};
    char msg_erro[256] = {"Prediction initialized! wait a few momments and type prediction -f \n"};
    char help_funct[500] = {"\n\n | #### Threads: #####\n |static void *Water(void *threadid);\n |static void *Agrotoxic(void *threadid); \n |void *cliente(void *arg); \n |static void *TemperatureSensor(void *threadid); \n |static void *HumidityLand(void *threadid); \n |static void *AnemometerSensor(void *threadid); \n |int lunar_calendar(int dia, int mes); \n |int data(int escolha);\n\n"};

    while (1)
    {

        bzero(buffer, sizeof(buffer));
        n = read(newsockfd[cid], buffer, 50);

        //Controle de erros para desconexão do user
        if (strlen(buffer) <= 0)
        {
            printf("\n\n\n\n#### User has been Disconnected #####\n");
            printf("#### Shutting Down System #####\n\n\n\n");
            exit(1);
        }

        printf("\nReceived from [%d]: %s\n", cid, buffer);
        if (n < 0)
        {
            printf("Error Reading to socket!\n");
            exit(1);
        }

        if (strcmp(buffer, "sample\n") == 0)
        {

            sprintf(msg1, "Temperature Sensor: %d ºC \n", temperature_sensor);
            n = write(newsockfd[i], msg1, 50);
            sprintf(msg1, "Humidity Sensor: %d%% \n", humidity_land);
            n = write(newsockfd[i], msg1, 50);
            sprintf(msg1, "anemometer Sensor: %d km/h \n", anemometer_sensor);
            n = write(newsockfd[i], msg1, 50);
        }

        else if (strcmp(buffer, "status\n") == 0)
        {

            n = write(newsockfd[i], status_msg, 50);
        }

        else if (strcmp(buffer, "water\n") == 0)
        {
            //TAKE MUTEX
            pthread_mutex_lock(&mutex);

            flag_water = 1;
            flag_ativated_tube = 1;

            pending_request++;

            if(request_tube == -1)  request_tube = 0;

            //DROP MUTEX
            pthread_mutex_unlock(&mutex);

            n = write(newsockfd[i], water_msg, 50);
        }

        else if (strcmp(buffer, "agrotoxic\n") == 0)
        {
            //TAKE MUTEX
            pthread_mutex_lock(&mutex);

            flag_agrotoxic = 1;
            flag_ativated_tube = 1;

            pending_request++;

            if(request_tube == -1)  request_tube = 1;
            

            //DROP MUTEX
            pthread_mutex_unlock(&mutex);

            n = write(newsockfd[i], agrotoxic_msg, 50);
            n = write(newsockfd[i], warning_msg, 90);
        }

        else if (strcmp(buffer, "prediction -s\n") == 0)
        {
            flag_prediction = 1;
            if (!flag_prediction_available)
            {
                n = write(newsockfd[i], msg_erro, 100);
            }
        }

        else if (strcmp(buffer, "GPS\n") == 0)
        {
            n = write(newsockfd[i], GPS_msg, 50);
        }

        else if (strcmp(buffer, "help\n") == 0)
        {
            sprintf(help_msg, "\n\n | #### Comando Line #### \n |*sample -> Retorna leituras dos sensores\n |*status -> Retorna Status da plantação\n |*water -> Liga irrigação por 2 min \n |*agrotoxic -> Aplica pesticida por 1 min \n |*GPS -> Informa localização do sistema\n |*help -> Retorna lista de comandos \n |*prediction -s -> Inicia as predições\n |*prediction -f -> Reve se já tem alguma predição disponivel\n |*clear -> Limpa a tela\n");
            n = write(newsockfd[i], help_msg, 500);
            n = write(newsockfd[i], help_funct, 500);
        }
        else if (strcmp(buffer, "clear\n") == 0)
        {
            sprintf(msg1, "clear");
            n = write(newsockfd[i], msg1, 300);
            system("clear");
        }
        else if (strcmp(buffer, "prediction -f\n") == 0)
        {

            if (flag_prediction_available)
            {
                flag_prediction_available = 0;
                n = write(newsockfd[i], type_lua, 50);
                n = write(newsockfd[i], msg_lua, 50);
                n = write(newsockfd[i], bom_lua, 70);
                sprintf(prob_rain, "A probabilidade de chuva e' %d%% \n", probability_rain);
                sprintf(prob_storm, "A probabilidade de tempestade e' %d%% \n", probability_storm);
                n = write(newsockfd[i], prob_rain, 50);
                n = write(newsockfd[i], prob_storm, 70);
                n = write(newsockfd[i], msg_rain, 100);
            }
        }
    }
}

int main(int argc, char *argv[])
{
    struct sockaddr_in serv_addr, cli_addr;
    socklen_t clilen;
    int sockfd, portno;

    int i = 0;
    int tid = 0;
    int lua = 0;

    sigset_t alarm_sig;
    pthread_t t[N_THREADS];

    if (argc < 2)
    {
        printf("Error, port not set!\n");
        exit(1);
    }

    sigemptyset(&alarm_sig);
    for (i = SIGRTMIN; i <= SIGRTMAX; i++)
        sigaddset(&alarm_sig, i);
    sigprocmask(SIG_BLOCK, &alarm_sig, NULL);

    printf("In main: creating thread [%d] - TemperatureSensor \n", 1);
    pthread_create(&t[0], NULL, TemperatureSensor, (void *)1);

    printf("In main: creating thread [%d] - HumidityLandSensor \n", 2);
    pthread_create(&t[1], NULL, HumidityLand, (void *)2);

    printf("In main: creating thread [%d] - AnemometerSensor \n", 3);
    pthread_create(&t[2], NULL, AnemometerSensor, (void *)3);

    printf("In main: creating thread [%d] - Water \n", 4);
    pthread_create(&t[3], NULL, Water, (void *)4);

    printf("In main: creating thread [%d] - Agrotoxic \n", 5);
    pthread_create(&t[4], NULL, Agrotoxic, (void *)5);

    printf("In main: creating thread [%d] - Prediction \n", 6);
    pthread_create(&t[5], NULL, Prediction, (void *)6);

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        printf("Error opening socket!\n");
        exit(1);
    }
    bzero((char *)&serv_addr, sizeof(serv_addr));
    portno = atoi(argv[1]);
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(portno);
    if (bind(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        printf("Error doing bind!\n");
        exit(1);
    }
    listen(sockfd, 5);

    while (1)
    {
        clilen = sizeof(cli_addr);
        newsockfd[id] = accept(sockfd, (struct sockaddr *)&cli_addr, &clilen);
        printf("Connection established with host [%d]\n", id);

        if (newsockfd[id] < 0)
        {
            printf("Erro in accept - %d!\n", errno);
            exit(1);
        }

        pthread_create(&t[7], NULL, cliente, (void *)id);
        id++;
    }
    //        close(newsockfd);
    //      close(sockfd);
    return 0;
}
