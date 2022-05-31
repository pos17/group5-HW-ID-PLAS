import processing.sound.*;
import controlP5.*;
import java.util.*;

int activeColor = unhex("ff61ff17");
int foregroundColor = unhex("ffff006d");
int backgroundColor = unhex("ff8600EC");


myLine elipse, vert, hor;
ExpSine w1, w2, w3, w4, w5;
float x = 0;
float y = 0;
float z = 0;
float yV, zV, zH, xH;
float time=0, time2=0;
float delay = 1;
float t;
float c =0;
float freq = 0.2;
int amplitude =20, numLines=80, speedBall=1, randomness=0;
int hueBall = 150;
float t0=0;
int bpm0 = 100, bpm, bpmHistory;
String whatScale;
float ampValue = 1;

//VOLUMES
float mainVolume=0.5;
float kickVolume=0.5;
float snareVolume=0.5;
float hihatVolume=0.5;
float chordVolume=0.5;
float bassVolume=0.5;
float arpVolume=0.5;


boolean mainWindow = true;
boolean mixerDrawable = false;
boolean bpmSliderVisible = false;

float a0=200, b0=a0/2;

AudioIn input;
Amplitude amp;
SoundFile sf;
BeatDetector bd;

ControlP5 cp5;
Slider bpmSlider;
Toggle barVisible, mixerVisible;
CheckBox checkbox;
ScrollableList scale;
controlP5.Group buttons;

Ball ball = new Ball();

void setup() {
  Sound s = new Sound(this);
  Sound.list();
  s.inputDevice(14);

  fullScreen(P3D);
  //size(800, 600, P3D);
  colorMode(HSB);
  lights();
  setupOSC();

  cp5 = new ControlP5(this);
  buttons = cp5.addGroup("button menu");


  // Create the Input stream
  input = new AudioIn(this, 0);
  input.start();

  amp = new Amplitude(this);
  amp.input(input);
  //println("DONE!!");
  //println(amp.analyze());
  bd = new BeatDetector(this);
  bd.input(input);
  bd.sensitivity(500);

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
    .addItem("tempo", 0)
    .addItem("root note", 0)
    .addItem("sensors", 0)
    .deactivateAll()
    .setGroup(buttons)
    .setColorActive(activeColor)
    .setColorForeground(foregroundColor)
    .setColorBackground(backgroundColor)
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
    .setValue(bpm0)
    .hide()
    .setGroup(buttons)
    .setColorActive(activeColor)
    .setColorForeground(foregroundColor)
    .setColorBackground(backgroundColor)
    ;
  bpmSlider.getCaptionLabel()
    .align(ControlP5.RIGHT, ControlP5.BOTTOM)
    .setPadding(10, 10);

  // SCROLLABLE LIST
  List scales = Arrays.asList("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B");
  scale = cp5.addScrollableList("scales")
    .setPosition(width/9*2+width/6, height/8*6)
    //.setPosition(0, 0)
    .setSize(width/9*2, height/8)
    .setItemHeight(height/8/3)
    .addItems(scales)
    .setValue(0)
    .setType(0)
    .setOpen(true)
    .hide()
    .setLabelVisible(false)
    .setBarVisible(false)
    .setGroup(buttons)
    .setColorActive(activeColor)
    .setColorForeground(foregroundColor)
    .setColorBackground(backgroundColor)
    ;

  scale.getValueLabel()
    .setFont(createFont("Arial", height/50))
    .align(ControlP5.CENTER, ControlP5.CENTER);
  scale.getCaptionLabel()
    .setFont(createFont("Arial", height/50))
    ;

  // BALL
  ball.initBall(80, height/6);

  sens1 = new Plot("SHAKE", width/5*3-70, height/5);
  sens2 = new Plot("ACCEL", width/5*3-70, height/5);
  sens3 = new Plot("GYROS", width/5*3-70, height/5);

  barVisible = cp5.addToggle("barVisible")
    .setPosition(0, height-100)
    .setSize(100, 100)
    .setValue(true)
    .setColorActive(activeColor)
    .setColorForeground(foregroundColor)
    .setColorBackground(backgroundColor)
    ;
  barVisible.getCaptionLabel()
    .setText("BAR")
    .setFont(createFont("Arial", 20))
    .align(ControlP5.CENTER, ControlP5.CENTER);

  mixerVisible = cp5.addToggle("mixerVisible")
    .setPosition(width-100, height-100)
    .setSize(100, 100)
    .setValue(false)
    .setColorActive(activeColor)
    .setColorForeground(foregroundColor)
    .setColorBackground(backgroundColor)
    ;
  mixerVisible.getCaptionLabel()
    .setText("MIXER")
    .setFont(createFont("Arial", 20))
    .align(ControlP5.CENTER, ControlP5.CENTER);

  setupMixer();
  hideMixer();

  setVolume();


  frameRate(30);
}

void draw() {
  background(0);
  if (bd.isBeat()) t0=millis();


  //osc part
  sendBPM();
  update();
  setScale();

  if (mouseY>(height-height/8) || barVisible.getBooleanValue()) {
    barVisible.show();
    mixerVisible.show();
  } else {
    barVisible.hide();
    mixerVisible.hide();
  }

  mixerDrawable = mixerVisible.getBooleanValue();

  if (!mixerDrawable) {
    hideMixer();
    if (mainWindow) drawMainWindow();
    else drawSensorWindow();
  } else {
    showMixer();
    drawMixer();
  }
  drumSli.update();
  bassSli.update();
  padSli.update();
  arpSli.update();
  masterSli.update();
}



void mousePressed() {
}

void drawMainWindow() {
  //if (frameCount%90 == 0) t0=millis();
  ampValue = amp.analyze();
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

  ball.setColor(color(frameCount%255, 255, map(channelVolumes[4],0,1.5,0,255)));
  println("master Vol: " + channelVolumes[4]);
  ball.drawBall(ampValue);
  time2=millis();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}

void checkBox(float []a) {
  bpmSlider.setVisible(a[0]==1);
  if (a[0]==1) bpmSlider.bringToFront();
  scale.setVisible(a[1]==1);
  if (a[1]==1) scale.bringToFront();
  mainWindow = a[2]==0;
}

void bpmSlider(int value) {
  bpm = value;
}

void scales(int n) {
  whatScale = cp5.get(ScrollableList.class, "scales").getItem(n).get("text").toString();
  setScale();
}

void barVisible(boolean visible) {
  checkbox.setVisible(visible);
  if (!visible) {
    bpmSlider.hide();
    scale.hide();
  }
  //println("visible: "+visible);
}

//void mixerVisible(boolean visible) {
//  mixerDrawable = visible;
//  if (visible) showMixer();
//  else hideMixer();
//}
