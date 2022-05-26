import processing.sound.*;


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

float a0=200, b0=a0/2;

Amplitude amp;
SoundFile sf;
BeatDetector bd;


void setup() {
  fullScreen(P3D);
  //size(1920, 1200, P3D);
  //noFill();
  colorMode(HSB);
  lights();
  //sphereDetail(100);

  elipse = new myLine(0, 0, 0, numLines, randomness);
  vert = new myLine(0, 0, 0, numLines, randomness);
  hor = new myLine(0, 0, 0, numLines, randomness);

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

  setupOSC();

  
}

void draw() {
  //float ampValue = amp.analyze();
  background(0);

  //if (ampValue>0.7) t0=millis();
  //if (bd.isBeat()) t0=millis();

  //stroke(255);
  //line(width/2, 0, width/2, height);
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
  //pointLight(0, 200, 255, 400, 0, -500);
  spotLight(255, 255, 255,
    0, 0, -(a0+b0+300),
    0, 0, 1,
    PI/2, 1);

  rotateY(radians(angleH));

  //pointLight(127, 175, 155, 0, 0, -3*(a0+b0));
  //pointLight(200, 175, 155, 3*(a0+b0), 0, 0);
  //pointLight(50, 175, 155, -3*(a0+b0), 0, 0);

  //setA(a0+5*sin(c));
  a = a0;
  b = b0;
  //setA(a0+50*ampValue);
  //elipse.changeRadius(a+b);
  //hor.changeRadius(a+b);
  //vert.changeRadius(a+b);

  //BASKET LINE
  x = a*cos(radians(t)) + b*cos(3*radians(t));
  y = a*sin(radians(t)) - b*sin(3*radians(t));
  z = 2*sqrt(a*b)*sin(2*radians(t));

  // VERTICAL LINE
  zV = (a+b)*cos(radians(t));
  yV = (a+b)*sin(radians(t));

  // HORIZONTAL LINE
  xH = (a+b)*cos(radians(t));
  zH = (a+b)*sin(radians(t));

  if ((millis()-time) > delay) {
    elipse.update(x, y, z);
    vert.update(0, yV, zV);
    hor.update(xH, 0, zH);
    time = millis();
  }
  noStroke();
  //fill(127+127*ampValue, 255);
  fill(255);
  sphere(a+b-8);

  elipse.drawLine();
  rotateZ(radians(45));
  vert.drawLine();
  hor.drawLine();

  angleH += (0.7*ballVel);
  //a = 100+50*sin(c/10);
  //t+=0.1;
  t = millis()/10*speedBall;
  c+=0.1;
  time2=millis();


  //setSpeed(1);
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
//}
