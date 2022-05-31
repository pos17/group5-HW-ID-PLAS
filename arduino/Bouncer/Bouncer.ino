

/*
  UDP OSC sender
  Works with the MKR1010 and Nano 33 IoT
  Uses the OSC library by Adrian Freed and Yotam Man
  https://github.com/CNMAT/OSC
  Add a new file called arduino_secrets.h to this sketch
  for your SECRET SSID (network name) and SECRET_PASS (password)
  http://librarymanager/All#WiFi101   // use this for MKR1000
  http://librarymanager/All#WiFiNINA    // use this for MKR1010 or Nano 33 IoT
  http://librarymanager/All#WiFiUDP
  http://librarymanager/All#OSCMessage
  created 21 Nov 2019
  by Tom Igoe
*/
#include <Arduino.h>
#include <SPI.h>
#include <WiFiNINA.h>
#include <WiFiUdp.h>
#include <OSCMessage.h>

#include "arduino_secrets.h"

#include <utility/wifi_drv.h>

WiFiUDP Udp;                 // instance of UDP library

//DEFINING PINS WITH USER-FRIENDLY NAMES
const int potPin = A0;
const int shakePin = A1;
const int heartPin = A5;
//const int switchPin1 = 2;
//const int switchPin2 = 3;

// LEDs must be connected to arduino PWM pins - see board pinout
#define RED     3   // pin that red led is connected to    
#define GREEN   4   // pin that green led is connected to     
#define BLUE    5   // pin that blue led is connected to  


//value of shake
int shakeState = 0;
bool shakeActive = false;


int counter = 0;

//DEFINING DELAYS
const int BPDELAY = 2000;
unsigned long bpTime = millis();

unsigned long hsTime = millis();

unsigned long hsSendOSCTime = millis();
const int HS_SEND_OSC_DELAY = 500;


const int VOLDELAY = 50;
unsigned long volTime = millis();

//volume
float volumeVal = 0;
float volumeValHistory = 0;



//BLOODPRESSURE
float bpMean = 0;
int numOfElements;

void readyFeedback() {
  const int BLDL = 200;
  // when connected to net the system gives feedback blinking led GREEN RED BLUE AND THREE GREEN
  WiFiDrv::analogWrite(25, 255);
  analogWrite(RED, 0);
  WiFiDrv::analogWrite(26, 0);
  analogWrite(GREEN, 255);
  WiFiDrv::analogWrite(27, 0);
  analogWrite(BLUE, 255);
  delay(BLDL);
  WiFiDrv::analogWrite(25, 0);
  analogWrite(RED, 255);
  WiFiDrv::analogWrite(26, 0);
  analogWrite(GREEN, 255);
  WiFiDrv::analogWrite(27, 0);
  analogWrite(BLUE, 255);
  delay(BLDL);
  WiFiDrv::analogWrite(25, 0);
  analogWrite(RED, 255);
  WiFiDrv::analogWrite(26, 255);
  analogWrite(GREEN, 0);
  WiFiDrv::analogWrite(27, 0);
  analogWrite(BLUE, 255);
  delay(BLDL);
  WiFiDrv::analogWrite(25, 0);
  analogWrite(RED, 255);
  WiFiDrv::analogWrite(26, 0);
  analogWrite(GREEN, 255);
  WiFiDrv::analogWrite(27, 0);
  analogWrite(BLUE, 255);
  delay(BLDL);
  WiFiDrv::analogWrite(25, 0);
  analogWrite(RED, 255);
  WiFiDrv::analogWrite(26, 0);
  analogWrite(GREEN, 255);
  WiFiDrv::analogWrite(27, 255);
  analogWrite(BLUE, 0);
  delay(BLDL);
  WiFiDrv::analogWrite(25, 0);
  analogWrite(RED, 255);
  WiFiDrv::analogWrite(26, 0);
  analogWrite(GREEN, 255);
  WiFiDrv::analogWrite(27, 0);
  analogWrite(BLUE, 255);
  delay(BLDL);

  for (int i = 0; i < 3; ++i) {
    WiFiDrv::analogWrite(25, 0);
    analogWrite(RED, 255);
    WiFiDrv::analogWrite(26, 255);
    analogWrite(GREEN, 0);
    WiFiDrv::analogWrite(27, 0);
    analogWrite(BLUE, 255);
    delay(BLDL);
    WiFiDrv::analogWrite(25, 0);
    analogWrite(RED, 255);
    WiFiDrv::analogWrite(26, 0);
    analogWrite(GREEN, 255);
    WiFiDrv::analogWrite(27, 0);
    analogWrite(BLUE, 255);
    delay(BLDL);

  }
}

void setup() {

  //PINMODE SETUP FOR EMBEDDED LED ON THE ARDUINO
  WiFiDrv::pinMode(25, OUTPUT); //define green pin
  WiFiDrv::pinMode(26, OUTPUT); //define red pin
  WiFiDrv::pinMode(27, OUTPUT); //define blue pin

  // LED connection pins to be set as an output
  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);


  //PINMODE SETUP FOR INPUT PINS
  pinMode(shakePin, INPUT);
  pinMode(heartPin, INPUT);
  pinMode(A3, INPUT);

  //INITIALIZING SERIALUSB DEBUG
  SerialUSB.begin(9600);
  //while (!SerialUSB) {};

  //INITIALIZING WIFI CONNECTION
  //   while you're not connected to a WiFi AP,
  while ( WiFi.status() != WL_CONNECTED) {
    SerialUSB.print("Attempting to connect to Network named: ");
    SerialUSB.println (SECRET_SSID);           // print the network name (SSID)
    WiFi.begin(SECRET_SSID, SECRET_PASS);  // try to connect
    WiFiDrv::analogWrite(25, 255);
    analogWrite(RED, 0);
    WiFiDrv::analogWrite(26, 0);
    analogWrite(GREEN, 255);
    WiFiDrv::analogWrite(27, 255);
    analogWrite(BLUE, 0);
    delay(1000);
    WiFiDrv::analogWrite(25, 0);
    analogWrite(RED, 255);
    WiFiDrv::analogWrite(26, 0);
    analogWrite(GREEN, 255);
    WiFiDrv::analogWrite(27, 0);
    analogWrite(BLUE, 255);
    delay(1000);

  }

  // When you're connected, print out the device's network status:
  IPAddress ip = WiFi.localIP();
  SerialUSB.print("IP Address: ");
  SerialUSB.println(ip);
  Udp.begin(remotePort);
  // when connected to net the system gives feedback blinking led GREEN RED BLUE AND THREE GREEN
  readyFeedback();

  
}

void loop() {

  checkShakeInput();
  checkBloodPressure();
  setVolume();
  
  
  /*
    if(digitalRead(switchPin1)) {
    SerialUSB.println("switch pos1");
    }else if(digitalRead(switchPin2)) {
    SerialUSB.println("switch pos3");
    } else {
    SerialUSB.println("switch pos2");
    }
  */
  /*
    if(millis()-hsTime>1000/SAMP_FREQ){
    checkShakeInput();
    hsTime=millis();
    }

    if(millis()-hsSendOSCTime>HS_SEND_OSC_DELAY){
    //sendHsOsc();

    int numOfShake =0;
    for(int i = 0; i< ELEMENT_COUNT_MAX; ++i)  {
        if(hsRate[i]==1) {
          numOfShake++;
        }
      }
      //SerialUSB.print("HSRATE ARRAY:");
      //for(int i = 0; i < ELEMENT_COUNT_MAX; i++) {
      //  Serial.println(hsRate[i]);
      //}
      SerialUSB.print("NUM OF SHAKES:");
      SerialUSB.println(numOfShake);
      hsSendOSCTime=millis();
    }
  */

  /*
    if (millis() % 1000 < 3) {

    Serial.print(String(buttonVal1) + "  ");
    //the message wants an OSC address as first argument
    OSCMessage msg("/test");

      for (int b = 0; b < sizeof(midimsg); b++) {
      msg.add(midimsg[b]);
      Serial.print(midimsg[b], HEX);
      Serial.print(" ");
      }

    msg.add(buttonVal1);

    Serial.println("sending OSC");
    Udp.beginPacket(remoteAddress, remotePort);
    msg.send(Udp); // send the bytes to the SLIP stream
    Udp.endPacket(); // mark the end of the OSC Packet
    msg.empty(); // free space occupied by message
    }
  */
}


void checkShakeInput() {
  shakeState = analogRead(shakePin);
  if (shakeState <= 600) {
    shakeState = analogRead(shakePin);
    delay(5);
    if (shakeState <= 600 && !shakeActive) {
      shakeActive = true;
      //DO SOMETHING
      OSCMessage msg("/arduino/handshake/val");
      msg.add(1);
      SerialUSB.println("sending OSC HS Rate");
      SerialUSB.println(1);
      Udp.beginPacket(remoteAddress, remotePort);
      msg.send(Udp); // send the bytes to the SLIP stream
      Udp.endPacket(); // mark the end of the OSC Packet
      msg.empty(); // free space occupied by message
    }
  } else {
    shakeActive = false;
  }
}
/*
  void sendHsOsc() {
  OSCMessage msg("/arduino/handshake/val");
  msg.add(1);
  SerialUSB.println("sending OSC HS Rate");
  SerialUSB.println(numOfShake);
  Udp.beginPacket(remoteAddress, remotePort);
  msg.send(Udp); // send the bytes to the SLIP stream
  Udp.endPacket(); // mark the end of the OSC Packet
  msg.empty(); // free space occupied by message
  }
*/
void checkBloodPressure() {
  float bloodPress = analogRead(heartPin);
  //SerialUSB.println(bloodPress);
  bpMean += bloodPress;
  numOfElements++;
  //SerialUSB.println(bpMean);
  if (millis() - bpTime > BPDELAY) {
    bpMean /= numOfElements;
    //DO SOMETHING
    OSCMessage msg("/arduino/BloodPressure/val");
    //SerialUSB.println("BPMEAN");
    //SerialUSB.println(bpMean);

    msg.add(bpMean);
    Udp.beginPacket(remoteAddress, remotePort);
    msg.send(Udp); // send the bytes to the SLIP stream
    Udp.endPacket(); // mark the end of the OSC Packet
    msg.empty(); // free space occupied by message
    bpTime = millis();
    bpMean = 0;
    numOfElements = 0;
  }
}

void setVolume() {
  volumeVal = analogRead(potPin);
  if (millis() - volTime > VOLDELAY) {
    boolean enter = false; 
    if(abs(volumeVal- volumeValHistory) > 10){ enter = true;}
      //if (volumeVal != volumeValHistory) {
    if (enter) {
      if(volumeVal <10) volumeVal = 0;
      float volToSend = 0;
      volToSend = (volumeVal *1.5)/ 1024;
      OSCMessage msg("/arduino/volume/val");
      SerialUSB.println("VOL SET");
      SerialUSB.println(volToSend);
      msg.add(volToSend);
      Udp.beginPacket(remoteAddress, remotePort);
      msg.send(Udp); // send the bytes to the SLIP stream
      Udp.endPacket(); // mark the end of the OSC Packet
      msg.empty(); // free space occupied by message
      volTime = millis();
      volumeValHistory = volumeVal;
      setLedVal(volumeVal);
      
    }
  }
}

//Setting led value, input from 0 - 1023
void setLedVal(int ledIn) {
  int ledToPut = (255*ledIn)/1023;
  int outLedToPut = 255-ledToPut;
  if(outLedToPut<0) outLedToPut = 0;
  if(outLedToPut>250) { 
    outLedToPut = 250;
    ledToPut = 5;
    }
  
  WiFiDrv::analogWrite(25, 0);
  digitalWrite(RED, 1);
  WiFiDrv::analogWrite(26, ledToPut);
  analogWrite(GREEN, outLedToPut);
  WiFiDrv::analogWrite(27, 0);
  digitalWrite(BLUE, 1);
}
