import supercollider.*;
import netP5.*;
import oscP5.*;

/*   testing OSC Compass
 *
 * Pos17
 *
 */

//import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;

//TIMERS
float accMagTime = millis();
float accMagDelay = 500;

float shakeResetTime = millis();
float shakeResetDelay = 5000;

/* acceleration magnitude handling components */
float accX=0;
float accY=0;
float accZ=0;
FloatList accMagList = new FloatList();

/* Handling handshake rate*/
int shakesIter = 0;
int shakesLimit = 5;


OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  //size (1920, 1080, P3D);

  smooth();
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* local network location of supercollider component */
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
}

void draw() {
  update();
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  if (theOscMessage.checkAddrPattern("/multisense/accelerometer/x")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      accX = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  } else if (theOscMessage.checkAddrPattern("/multisense/accelerometer/z")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      accZ = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  } else if (theOscMessage.checkAddrPattern("/multisense/accelerometer/y")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      accY = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  } else if (theOscMessage.checkAddrPattern("/arduino/handshake/val")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("i")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).intValue();  // get the first osc argument
      shakesIter += firstValue;
      println("ARRIVA OSC");
      /*
      if (shakesIter>=shakesLimit) {
       shakesIter = 0;
       println("SENDING TO SC");
       OscMessage myMessage = new OscMessage("/processing/SCControls/ArpONOFF");
       myMessage.add(valueToSend);
       // send the message
       
       println(valueToSend);
       oscP5.send(myMessage, myRemoteLocation);
       
       }
       */
       return;
      
    }
  }
}


void setAccMag(float x, float y, float z) {
  float valueToSend =0.0;
  float accMag = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2));
  accMagList.append(accMag);
  while (accMagList.size()>100) {
    accMagList.remove(0);
  }
  accMag=0;
  for (int i =0; i<accMagList.size(); ++i) {
    accMag += accMagList.get(i);
  }
  accMag/=accMagList.size();
  if (accMag>10 && accMag<15) {
    valueToSend = 0.25;
    println(accMag);
  } else if (accMag>15 && accMag<18) {
    valueToSend = 0.125;
    println(accMag);
  } else if (accMag>19) {
    valueToSend = 0.0625;
    println(accMag);
  } else {
    valueToSend = 0.0;
    println(accMag);
  }
  if (millis() - accMagTime >accMagDelay ) {
    OscMessage myMessage = new OscMessage("/processing/SCControls/ArpONOFF");
    myMessage.add(valueToSend); /* add an int to the osc message */
    /* send the message */
    println(valueToSend);
    oscP5.send(myMessage, myRemoteLocation);
    accMagTime=millis();
  }
}

void update() {
  if (millis()-shakeResetTime>shakeResetDelay) {
    int value = 0;
    if (shakesIter <=5) {
      value = 0;
    } else if (shakesIter <=10) {
      value = 1;
    } else {
      value = 2;
    }
    OscMessage myMessage = new OscMessage("/processing/SCControls/ChangeThings");
    myMessage.add(value);
    // send the message
    println("SENDING OSC MESSAGE TO SC");
    println(value);
    oscP5.send(myMessage, myRemoteLocation);
    shakeResetTime = millis();
    shakesIter = 0;
  }
}
