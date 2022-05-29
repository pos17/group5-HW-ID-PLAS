
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
float shakeResetDelay = 1500;

/* gyroscope values*/
float yaw =1;

float pitch =1;
float roll =1;
float valToSendHistory = 1;



/* acceleration magnitude handling components */
float accX=0;
float accY=0;
float accZ=0;
FloatList accMagList = new FloatList();

/* Handling handshake rate*/
int shakesIter = 0;
int shakesLimit = 3;


OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOSC() {
  //size (1920, 1080, P3D);

  smooth();
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* local network location of supercollider component */
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
  println("setting OSC done");
}



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage);
  /* check if theOscMessage has the address pattern we are looking for. */
  if (theOscMessage.checkAddrPattern("/multisense/accelerometer/x")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      accX = firstValue;
      setAccMag(accX, accY, accZ);
      println("new value found");
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
  } else if (theOscMessage.checkAddrPattern("/multisense/accelerometer/z")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      accY = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  } else if (theOscMessage.checkAddrPattern("/multisense/orientation/yaw")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      yaw = firstValue;
      int valToSend = 0;
      if(yaw <-90) {
        valToSend=0;
      } else if(yaw <0) {
        valToSend=1;
      }  else if(yaw <90) {
        valToSend=2;
      }  else if(yaw <180) {
        valToSend=3;
      }
      if(valToSend!=valToSendHistory) {
        OscMessage myMessage = new OscMessage("/processing/SCControls/changingPattern");
        myMessage.add(valToSend); /* add an int to the osc message */
        /* send the message */
        println("sendingChanging");
        println(valToSend);
        oscP5.send(myMessage, myRemoteLocation);
        valToSendHistory=valToSend;
        return;
      }
    }
  } else if (theOscMessage.checkAddrPattern("/multisense/orientation/pitch")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      pitch = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  } else if (theOscMessage.checkAddrPattern("/multisense/orientation/roll")==true) {
    /* check if the typetag is the right one. */
    if (theOscMessage.checkTypetag("f")) {
      /* parse theOscMessage and extract the values from the osc message arguments. */
      float firstValue = theOscMessage.get(0).floatValue();  // get the first osc argument
      roll = firstValue;
      setAccMag(accX, accY, accZ);
      return;
    }
  }
  
  else if (theOscMessage.checkAddrPattern("/arduino/handshake/val")==true) {
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
  println("accMag");
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
  accMag /= accMagList.size();
  if (accMag>10 && accMag<18) {
    ball.setSpeed(1);
    valueToSend = 1;
    println(accMag);
  } else if (accMag>=18 && accMag<25) {
    ball.setSpeed(2);
    valueToSend = 2;
    println(accMag);
  } else if (accMag>=25 && accMag<30) {
    ball.setSpeed(3);
    valueToSend = 3;
    println(accMag);
  } else if (accMag>=30) {
    ball.setSpeed(4);
    valueToSend = 4;
    println(accMag);
  } else {
    ball.setSpeed(0);
    valueToSend = 0;
    println(accMag);
  }
  if (millis() - accMagTime >accMagDelay ) {
    OscMessage myMessage = new OscMessage("/processing/SCControls/ArpONOFF");
    myMessage.add(valueToSend); /* add an int to the osc message */
    /* send the message */
    println("sendingArp");
    println(valueToSend);
    oscP5.send(myMessage, myRemoteLocation);
    accMagTime=millis();
  }
}



void update() {
  if (millis()-shakeResetTime>shakeResetDelay) {
    int value = 0;
    if (shakesIter <=1) {
      value = 0;
    } else if (shakesIter <=6) {
      value = 1;
    } else {
      value = 2;
    }
    OscMessage myMessage = new OscMessage("/processing/SCControls/DrumVelocity");
    myMessage.add(value);
    // send the message
    println("SENDING OSC MESSAGE TO SC");
    println(value);
    oscP5.send(myMessage, myRemoteLocation);
    shakeResetTime = millis();
    shakesIter = 0;
  }
}

void sendBPM() {
  if(bpm!=bpmHistory) {
    OscMessage myMessage = new OscMessage("/processing/SCControls/setBPM");
    myMessage.add(bpm); /* add an int to the osc message */
    /* send the message */
    println("sendingArp");
    println(bpm);
    oscP5.send(myMessage, myRemoteLocation);
    bpmHistory=bpm;
  }
  
}
