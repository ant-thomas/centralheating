#include "RCSwitch.h"
#include <stdlib.h>
#include <stdio.h>
RCSwitch mySwitch = RCSwitch();

#define RELAY1  6
 
void setup() {
  Serial.begin(9600);
  mySwitch.enableReceive(0);  // Receiver on inerrupt 0 that is pin #2
  pinMode(RELAY1, OUTPUT);
}
 
void loop() {
  if (mySwitch.available()) {
 
    int value = mySwitch.getReceivedValue();
 
    if (value == 0) {
      Serial.print("Unknown encoding");
    }
    else if (mySwitch.getReceivedValue() == 1234560) //put on command number here
    {
     Serial.print("Received ");
     Serial.println( mySwitch.getReceivedValue() );
     digitalWrite(RELAY1,HIGH);
    }
    else if (mySwitch.getReceivedValue() == 1234561) //put off command number here
    {
     Serial.print("Received ");
     Serial.println( mySwitch.getReceivedValue() );
     digitalWrite(RELAY1,LOW);
    }
    else {
 
     Serial.print("Received ");
      Serial.print( mySwitch.getReceivedValue() );
      Serial.print(" / ");
      Serial.print( mySwitch.getReceivedBitlength() );
      Serial.print("bit ");
      Serial.print("Protocol: ");
      Serial.println( mySwitch.getReceivedProtocol() );
    }
 
    mySwitch.resetAvailable();
 
  }
}
