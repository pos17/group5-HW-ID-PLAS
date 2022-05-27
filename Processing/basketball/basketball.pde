import processing.sound.*;
import controlP5.*;
import java.util.*;


int angle=0;
myLine elipse, vert, hor;
ExpSine w1, w2, w3, w4, w5;
float x = 0;
float y = 0;
float z = 0;
float yV, zV, zH, xH;
PVector vec;
float angleH=0;
float angleV=0;
float radius=10;
float time=0, time2=0;
float delay = 1;
float t;
float a = 70;
float b = a/2;
float c =0;
float freq = 0.2;
int amplitude =20, numLines=80, speedBall=1, randomness=0;
float t0=0;
int bpm = 100;

boolean mainWindow=true;
boolean bpmSliderVisible=false;

float a0=200, b0=a0/2;

Amplitude amp;
SoundFile sf;
BeatDetector bd;

ControlP5 cp5;
ButtonBar bar;
Slider bpmSlider;
CheckBox checkbox;
ScrollableList scale;
Group buttons;

Ball ball = new Ball();

void setup() {
  fullScreen(P3D);
  colorMode(HSB);
  lights();

  cp5 = new ControlP5(this);
  buttons = cp5.addGroup("button menu");

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

  // CHECKBOX
  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(width/6, height/8*7)
    .setSize(width/9*2, height/8)
    .setItemsPerRow(3)
    .setSpacingColumn(0)
    .addItem("bpm", 0)
    .addItem("scale", 0)
    .addItem("sens", 0)
    .deactivateAll()
    .setGroup(buttons)
    ;
  for (int i=0; i<checkbox.getItems().size(); i++) {
    checkbox.getItem(i)
      .getCaptionLabel()
      .setFont(createFont("Arial", height/18))
      .align(ControlP5.CENTER, ControlP5.CENTER);
  }

  // SLIDER BPM
  bpmSlider = cp5.addSlider("bpmSlider")
    .setPosition(width/6, (height/8*7)-55)
    .setSize(width/9*2, 50)
    .setRange(80, 150)
    .setValue(bpm)
    .bringToFront()
    .hide()
    .setGroup(buttons)
    ;
  bpmSlider.getCaptionLabel()
    .align(ControlP5.RIGHT, ControlP5.BOTTOM)
    .setPadding(10, 10);

  // SCROLLABLE LIST
  List scales = Arrays.asList("C", "D", "E", "F", "G", "A", "B");
  scale = cp5.addScrollableList("scales")
    .setPosition(width/9*2+width/6, height/8*6)
    //.setPosition(0, 0)
    .setSize(width/9*2, height/8)
    .setBarHeight(height/8/3)
    .setItemHeight(height/8/3)
    .addItems(scales)
    .setType(0)
    .setOpen(true)
    .hide()
    .setLabelVisible(false)
    .setGroup(buttons)
    ;
  scale.getValueLabel()
    .setFont(createFont("Arial", height/50))
    .align(ControlP5.CENTER, ControlP5.CENTER);
  scale.getCaptionLabel()
    .setFont(createFont("Arial", height/50));

  // BALL
  ball.initBall(80, height/6);
}

void draw() {
  //float ampValue = amp.analyze();
  background(0);
  frameRate(25);

  //if (ampValue>0.7) t0=millis();
  //if (bd.isBeat()) t0=millis();

  if (mainWindow) drawMainWindow();
  else drawSensorWindow();
}



void mousePressed() {
}

void drawMainWindow() {
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  ball.setA0(200);
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
  translate(width/2, height/2, 0);

  ball.drawBall();
  time2=millis();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}

void drawSensorWindow() {
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  translate(width-width/6, height/2);
  ball.setA0(120);
  ball.drawBall();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}

void checkBox(float []a) {
  bpmSlider.setVisible(a[0]==1);
  scale.setVisible(a[1]==1);
  mainWindow = a[2]==0;
}
