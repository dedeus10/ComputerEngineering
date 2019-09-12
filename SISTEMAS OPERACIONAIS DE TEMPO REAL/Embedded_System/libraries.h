/*

	    UNIVERSIDADE FEDERAL DE SANTA MARIA
		    CENTRO DE TECNOLOGIA
	    CURSO DE ENGENHARIA DE COMPUTAÇÃO

	Sistemas Operacionais de Tempo Real	
	
	Author: Luis Felipe de Deus
	Date:24/05/18
	Update: 27/05/18
	
	LIBRARIES 

		  

*/
//Global Variables
int temperature_sensor;  //Variable that stores temperature sensor readings
int samples_temp = 0;    //Variable that stores average temperature
int n_samples_temp = 0;  //Variable that stores number of samples temperature
int humidity_land;       //Variable that stores soil humidity sensor readings
int samples_humid = 0;   //Variable that stores average humidity
int n_samples_humid = 0; //Variable that stores numeber of samples humidity
int anemometer_sensor;   //Variable that stores the readings of the wind speed sensor
int samples_anem = 0;    //Variavle that stores average anemometer
int n_samples_anem = 0;  //Variavle that stores number of samples wind speed

//Prototypes of functions
static void *TemperatureSensor(void *threadid); //Function of temperature sensor
static void *HumidityLand(void *threadid);      //Function of Humidity sensor
static void *AnemometerSensor(void *threadid);  //Function of anemometer sensor
int lunar_calendar(int dia, int mes);           //Function of lunar calendar, return de moon
int data(int escolha);                          //Function data, return atribute of date
 
//Definitions
pthread_mutex_t mutex_p = PTHREAD_MUTEX_INITIALIZER;

//Global Variables
char *type_lua; //Used for msg lunar type
char *msg_lua;  //Used for msg matching lunar
char *bom_lua;  //Used for msg that good matching lunar
char *msg_rain; //Used for msg matching rain

int8_t flag_prediction = 0;           //Flag used for init predicition
int8_t flag_prediction_available = 0; //Flag used for indicate prediction terminated

int probability_rain = 0;  //Variable user for storage the probability of rain
int probability_storm = 0; //Variable user for storage the probability of stor

//FUNCTIONS

//Read the temperature sensor every 10s
static void *TemperatureSensor(void *threadid)
{
    long tid;
    tid = (long)threadid;

    srand(time(NULL));

    //info of periodicity
    struct periodic_info info;

    //defines the periodicity
    printf("Thread [%ld] period 10s ---- READ TEMPERATURE SENSOR ----\n", tid);
    make_periodic(10000000, &info);

    while (1)
    {
        //TAKE MUTEX
        pthread_mutex_lock(&mutex_p);

        //Read Temperature
        temperature_sensor = 25 + (rand() % 5);
        printf("Sensor de temperatura: %d °C \n", temperature_sensor);

        if (n_samples_temp < 3)
        {
            n_samples_temp++;
            samples_temp = samples_temp + temperature_sensor;
        }

        //DROP MUTEX
        pthread_mutex_unlock(&mutex_p);

        wait_period(&info);
    }

    return NULL;
}
/*-----------------------------------------------------------------------------*/

//Read the Humidity sensor every 20s
static void *HumidityLand(void *threadid)
{
    long tid;
    tid = (long)threadid;

    //Infor of periodicity
    struct periodic_info info;

    //Defines the periodicity
    printf("Thread [%ld] period 20s ---- READ HUMIDITY LAND ----\n", tid);
    make_periodic(20000000, &info);

    while (1)
    {
        //TAKE MUTEX
        pthread_mutex_lock(&mutex_p);

        //Read Humidity
        humidity_land = 45 + (rand() % 5);
        printf("Sensor de umidade do solo: %d%% \n", humidity_land);

        if (n_samples_humid < 3)
        {
            n_samples_humid++;
            samples_humid = samples_humid + humidity_land;
        }

        //DROP MUTEX
        pthread_mutex_unlock(&mutex_p);

        wait_period(&info);
    }

    return NULL;
}
/*-----------------------------------------------------------------------------*/

//Read the Anemometer sensor every 30s
static void *AnemometerSensor(void *threadid)
{
    long tid;
    tid = (long)threadid;

    //Infor periodicity
    struct periodic_info info;

    //defines the periodicity

    printf("Thread [%ld] period 30s ---- READ ANEMOMETER ----\n", tid);
    make_periodic(30000000, &info);

    while (1)
    {
        //PEGA DO MUTEX
        pthread_mutex_lock(&mutex_p);

        //Read Wind Speed
        anemometer_sensor = 10 + (rand() % 10);
        printf("Sensor de velocidade do vento: %d km/h \n", anemometer_sensor);

        if (n_samples_anem < 3)
        {
            n_samples_anem++;
            samples_anem = samples_anem + anemometer_sensor;
        }

        //SAI DO MUTEX
        pthread_mutex_unlock(&mutex_p);

        wait_period(&info);
    }

    return NULL;
}
/*-----------------------------------------------------------------------------*/

//Function that makes the predictions
static void *Prediction(void *threadid)
{
    long tid;
    tid = (long)threadid;

    int lua, dia, mes, ano;

    while (1)
    {
        if (flag_prediction)
        {
            dia = data(0);
            mes = data(1);
            ano = data(2);
            //Ver Lua
            //Predições Baseadas no calendario Lunar
            lua = lunar_calendar(dia, mes);

            if (lua == 1)
            {
                type_lua = "A lua hoje é Minguante \n";
                msg_lua = "Pouca influencia da lua sobre a terra :(";
                bom_lua = "É bom plantar raízer como: Mandioca, Batata, Cenoura";
            }

            else if (lua == 2)
            {
                type_lua = "A lua hoje é Nova \n";
                msg_lua = "Começa a influencia da lua sobre a terra :|";
                bom_lua = "É bom plantar: Cebolinha, Espinafre e Arvores para madeira";
            }

            else if (lua == 3)
            {
                type_lua = "A lua hoje é Crescente \n";
                msg_lua = "Boa influencia da lua sobre a terra :)";
                bom_lua = "É bom plantar: Feijão, Arroz, Milho";
            }

            else if (lua == 4)
            {
                type_lua = "A lua hoje é Cheia \n";
                msg_lua = "Apice da influencia da lua sobre a terra :D";
                bom_lua = "É bom plantar hortaliças e flores: Repolho, Couve-flor, Alface";
            }

            //TAKE MUTEX
            pthread_mutex_lock(&mutex_p);
            if (n_samples_temp == 3 && n_samples_anem == 3 && n_samples_humid == 3)
            {

                temperature_sensor = samples_temp / 3;
                humidity_land = samples_humid / 3;
                anemometer_sensor = samples_anem / 3;

                //Probabilidade de chuva
                //Se o vento esta "vivo" a umidade esta baixa e a temperatura esta alta a chance de chover é de 60 %
                if (anemometer_sensor > 10 && anemometer_sensor < 39 && humidity_land > 20 && temperature_sensor > 35)
                {
                    probability_rain = 60;
                    probability_storm = 30;
                    msg_rain = "É interessante passar pesticida, visto que pode chover e não tem tempestade vindo \n";
                }
                //Condições normais
                else if (anemometer_sensor > 10 && anemometer_sensor < 39 && humidity_land > 20 && humidity_land < 50 && temperature_sensor > 22 && temperature_sensor < 30)
                {
                    probability_rain = 40;
                    probability_storm = 20;
                    msg_rain = "Clima seco, é bom irrigar a platanção !\n";
                }
                //Se o vento esta forte e a umidade esta media e a temperatura quente a chance de chuva é de 70%
                else if (anemometer_sensor > 40 && anemometer_sensor < 60 && humidity_land > 40 && temperature_sensor > 30)
                {
                    probability_rain = 70;
                    probability_storm = 50;
                    msg_rain = "Clima propicio de chuva, melhor não irrigar, espere alguns dias\n";
                }
                //Se o vento esta muito forte a chance é de temporal
                else if (anemometer_sensor > 65 && temperature_sensor > 28)
                {
                    probability_rain = 90;
                    probability_storm = 80;
                    msg_rain = "Vem tempestade por aí, é aconselhavel medidas de prevenção \n";
                }
                else
                {
                    probability_rain = 20;
                    probability_storm = 10;
                    msg_rain = "Clima agradável, ao final do dia irrigue a plantação \n";
                }
                flag_prediction_available = 1;
                samples_temp = 0;
                samples_humid = 0;
                samples_anem = 0;
                flag_prediction = 0;
                printf("\n----Prediçoes Referentes a data: %d/%d/%d---- \n", dia, mes, ano);
                printf("\n\n ---- PREDICTION AVAILABLE ----\n\n");
            }
            //DROP MUTEX
            pthread_mutex_unlock(&mutex_p);
        }
    }

    return NULL;
}
/*-----------------------------------------------------------------------------*/
//Função que retorna o tipo da lua de acordo com a data
int lunar_calendar(int dia, int mes)
{
    int lua;
    // 1- Lua Minguante; 2- Lua Nova; 3- Lua crescente; 4- Lua Cheia

    switch (mes)
    {
    //Primeiro mes Junho
    case 6:
    {
        if (dia >= 1 && dia <= 5)
            lua = 4;

        else if (dia >= 6 && dia <= 12)
            lua = 1;

        else if (dia >= 13 && dia <= 19)
            lua = 2;

        else if (dia >= 20 && dia <= 27)
            lua = 3;

        else
            lua = 4;

        break;
    }

    //Segundo mes Julho
    case 7:
    {
        if (dia >= 1 && dia <= 5)
            lua = 4;

        else if (dia >= 6 && dia <= 11)
            lua = 1;

        else if (dia >= 12 && dia <= 18)
            lua = 2;

        else if (dia >= 19 && dia <= 26)
            lua = 3;

        else
            lua = 4;

        break;
    }
    default:
    {
        lua = 1;
        break;
    }
    }

    return lua;
}
/*-----------------------------------------------------------------------------*/

//Funcao que retorna atributo da data
int data(int escolha)
{

    int dia, mes, ano;

    struct tm *local;
    time_t t;

    t = time(NULL);
    local = localtime(&t);

    dia = local->tm_mday;
    mes = local->tm_mon + 1;
    ano = local->tm_year + 1900;

    //day = dia;

    if (escolha == 0)
        return dia;

    else if (escolha == 1)
        return mes;

    else if (escolha == 2)
        return ano;
}
