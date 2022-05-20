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


/* acceleration magnitude handling components */
float accX=0;
float accY=0;
float accZ=0;
FloatList accMagList = new FloatList();


OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size (1920, 1080, P3D);

  smooth();
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* local network location of supercollider component */
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
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
  }
}


void setAccMag(float x, float y, float z) {
  float valueToSend =0.0;
  float accMag = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2));
  accMagList.append(accMag);
  while (accMagList.size()>50) {
    accMagList.remove(0);
  }
  if (millis() - accMagTime >accMagDelay ) {
    accMag=0;
    for (int i =0; i<accMagList.size(); ++i) {
      accMag += accMagList.get(i);
    }
    accMag/=accMagList.size();
    if (accMag>10) {
      valueToSend = 1.0;
      println(accMag);
    } else {
      valueToSend = 0.0;
      println(accMag);
    }

    OscMessage myMessage = new OscMessage("/processing/SCControls/ArpONOFF");
    myMessage.add(valueToSend); /* add an int to the osc message */
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    accMagTime=millis();
  }
}
