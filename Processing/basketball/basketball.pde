import processing.sound.*;
import controlP5.*;



int angle=0;
myLine elipse, vert, hor;
ExpSine w1, w2, w3, w4, w5;
float x = 0;
float y = 0;
float z = 0;
float yV, zV, zH, xH;
PVector vec;
float angleH=0;
float ballVel =1;

float angleV=0;
float radius=10;
float time=0, time2=0;
float delay = 1;
float t;
float a = 70;
float b = a/2;
float c =0;
float freq = 0.2;
int amplitude =20, numLines=200, speedBall=1, randomness=0;
float t0=0;

boolean mainWindow=true;

float a0=200, b0=a0/2;

Amplitude amp;
SoundFile sf;
BeatDetector bd;

ControlP5 cp5;
ButtonBar bar;

Ball ball = new Ball();

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  lights();

  cp5 = new ControlP5(this);


  //sf = new SoundFile(this, "SaponeLiquido.mp3");
  //sf.rate();
  //sf.loop();
  //amp = new Amplitude(this);
  //amp.input(sf);

  //bd = new BeatDetector(this);
  //bd.input(sf);
  //bd.sensitivity(300);

  w1 = new ExpSine(height/6, 50, freq, amplitude*2);
  w2 = new ExpSine(height/6*2, 50, freq*2, amplitude);
  w3 = new ExpSine(height/6*3, 50, freq, amplitude/2);
  w4 = new ExpSine(height/6*4, 50, freq*2, amplitude);
  w5 = new ExpSine(height/6*5, 50, freq, amplitude*2);

  bar = cp5.addButtonBar("bar")
    .setPosition(width/6, height/8*7)
    .setSize(width/3*2, height/8)
    .addItems(split("bpm scale sensors", " "));
    
  bar.getValueLabel().setFont(createFont("Arial",60));
  
  ball.initBall(100);
}

void draw() {
  //float ampValue = amp.analyze();
  background(0);

  //if (ampValue>0.7) t0=millis();
  //if (bd.isBeat()) t0=millis();

  if (mainWindow) drawMainWindow();
  else drawSensorWindow();

}

void setA(float aA) {
  a = aA;
  b= a/1.5;
}

/* SPEED in range(1, 3)*/
//void setSpeed(int speed) {
//  numLines = int(50/speed);
//  elipse.setNumLines(numLines);
//  vert.setNumLines(numLines);
//  hor.setNumLines(numLines);

//  elipse.setRandomness(abs(speed-3)*3);
//  vert.setRandomness(abs(speed-3)*3);
//  hor.setRandomness(abs(speed-3)*3);
//  speedBall = speed;
//}

//void mouseClicked() {
//  speedBall++;
//  if (speedBall==4) speedBall=1;
//  setSpeed(speedBall);
//  println(speedBall);
//}4

void mousePressed(){
  //t0=millis();
  //mainWindow = !mainWindow;
  //speedBall++;
  //if (speedBall==4) speedBall=1;
  //ball.setSpeed(speedBall%4);
}

void drawMainWindow(){
    pushMatrix();
  w1.calcWave(time2, t0);
  w2.calcWave(time2, t0);
  w3.calcWave(time2, t0);
  w4.calcWave(time2, t0);
  w5.calcWave(time2, t0);

  w1.setColor(color(frameCount%255, 255, 255));
  w2.setColor(color((frameCount/2)%255, 255, 255));
  w3.setColor(color((frameCount/3)%255, 255, 255));
  w4.setColor(color((frameCount/4)%255, 255, 255));
  w5.setColor(color((frameCount/5)%255, 255, 255));

  w1.update();
  w2.update();
  w3.update();
  w4.update();
  w5.update();

  loadPixels();
  for (int j=0; j<height; j++) {
    for (int i=0; i<width/2; i++) {
      pixels[(width-1-i)+j*width] = pixels[i+j*width];
    }
  }
  updatePixels();
  popMatrix();

  ball.drawBall();
  time2=millis();
}

void drawSensorWindow(){}
