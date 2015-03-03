#include <cstdlib>
#include <iostream>
#include <fstream>
#include "../RF24/RF24.h"
#include "./RF24Network.h"
#include <unistd.h>

unsigned int microseconds;
using namespace std;

// init network
//RF24 radio(RPI_V2_GPIO_P1_15, BCM2835_SPI_CS0, BCM2835_SPI_SPEED_8MHZ);

RF24 radio(RPI_V2_GPIO_P1_15, RPI_V2_GPIO_P1_24, BCM2835_SPI_SPEED_8MHZ);
RF24Network network(radio);
const uint16_t this_node = 0;

// define struct for char array
struct payload_t
{
    char readings[32];
};

int main(int argc, char** argv)
{
    // init radio
    radio.begin();
    delay(5);
//    radio.printDetails();
    network.begin(90, this_node);
    radio.setDataRate(RF24_250KBPS);
    radio.setPALevel(RF24_PA_MAX);

    while(1)
    {
        // pump network
        network.update();
        while (network.available())
        {
            // get payload
            RF24NetworkHeader header;
            payload_t payload;
            network.read(header,&payload,sizeof(payload));

            // get time - can be passed to time.localtime()
            time_t rawtime;
            time (&rawtime);

                if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '2'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather02.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '3'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather03.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '4'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather04.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '5'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather05.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '6'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather06.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '7'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather07.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '8'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather08.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else if ( (payload.readings[0] == '0') &&
                      (payload.readings[1] == '1'))
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather01.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();

                }
                else
                {
            ofstream myfile;
            myfile.open ("/dev/shm/rf24weather-no.txt");
            myfile << payload.readings << ',' << rawtime << endl;
            myfile.close();
                }


            // write to file and close
            // ofstream myfile;
            // myfile.open ("/dev/shm/rf24weather.txt");
            // myfile << payload.readings << ',' << rawtime << endl;
            // myfile.close();
            //exit (0);
        }
     // pause for 5mins to reduce cpu/disk load
     // sleep(1);
     usleep (500);
}
    return 0;
}
