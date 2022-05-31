import java.lang.Math;

int muteColor = unhex("ffff7d00");
int soloColor = unhex("ffffdd00");
int bgColor = unhex("ff2D4A54");

//Slider drumSli, bassSli, padSli, arpSli;
Fader drumSli, bassSli, padSli, arpSli, masterSli;
CheckBox mutes, solos;
//float drumVol, bassVol, padVol, arpVol, masterVol;

float[] volumes = {1, 1, 1, 1, 1};
float[] muteMask = {1, 1, 1, 1};
float[] soloMask = {0, 0, 0, 0};
float[] channelVolumes = {1, 1, 1, 1, 1};

int sliderPaddingX = 100, labelPaddingY = 20;
int sliderPaddingY=120;

//PFont arial = createFont("Arial", 30);


void setupMixer() {
  PFont.list();

  drumSli = new Fader("Drum", 0);
  bassSli = new Fader("Bass", 1);
  padSli = new Fader("Pad", 2);
  arpSli = new Fader("Arp", 3);
  masterSli = new Fader("Master", 4);
  drumSli.setPosition(sliderPaddingX, sliderPaddingY);
  bassSli.setPosition((int)drumSli.getPosition()[0]+drumSli.getWidth()+sliderPaddingX, sliderPaddingY);
  padSli.setPosition((int)bassSli.getPosition()[0]+bassSli.getWidth()+sliderPaddingX, sliderPaddingY);
  arpSli.setPosition((int)padSli.getPosition()[0]+padSli.getWidth()+sliderPaddingX, sliderPaddingY);
  masterSli.setPosition((int)arpSli.getPosition()[0]+arpSli.getWidth()+(sliderPaddingX*2), sliderPaddingY);

  mutes = cp5.addCheckBox("mutes")
    .setSize(width/16, width/16/3*2)
    .setPosition(sliderPaddingX, drumSli.getPosition()[1]+drumSli.getHeight()+50)
    .setSpacingColumn(sliderPaddingX)
    .setItemsPerRow(4)
    .addItem("drumMute", 0)
    .addItem("bassMute", 0)
    .addItem("padMute", 0)
    .addItem("arpMute", 0)
    .setColorActive(muteColor)
    .setColorForeground(unhex("ffcc6300"))
    //.setColorBackground(unhex("ff020122"))
    .setColorBackground(bgColor)
    ;

  for (int i=0; i<mutes.getItems().size(); i++) {
    mutes.getItem(i)
      .getCaptionLabel()
      .setText("M")
      .setFont(createFont("Arial", 30))
      .align(ControlP5.CENTER, ControlP5.CENTER);
  }

  solos = cp5.addCheckBox("solos")
    .setSize(width/16, width/16/3*2)
    .setPosition(sliderPaddingX, mutes.getPosition()[1]+(width/16/3*2)+20)
    .setSpacingColumn(sliderPaddingX)
    .setItemsPerRow(4)
    .addItem("drumSolo", 0)
    .addItem("bassSolo", 0)
    .addItem("padSolo", 0)
    .addItem("arpSolo", 0)
    .setColorActive(soloColor)
    .setColorForeground(unhex("ffccb100"))
    //.setColorBackground(unhex("ff020122"))
    .setColorBackground(bgColor)
    ;


  for (int i=0; i<solos.getItems().size(); i++) {
    solos.getItem(i)
      .getCaptionLabel()
      .setText("S")
      .setFont(createFont("Arial", 30))
      .align(ControlP5.CENTER, ControlP5.CENTER);
  }
}


void drawMixer() {
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  //translate(width/2, height/2);
  noStroke();
  for (int i=0; i<400; i++) {
    float wx = map(sin(radians(frameCount+i*0.7)), -1, 1, 0, width);
    float wy = map(cos(radians(frameCount+i*2)), -1, 1, 0, height);
    float c = map(cos(radians(2*frameCount+10*i)), -1, 1, 0, 255);
    fill(c);
    rect(wx, wy, 5, 10);
    wx = map(cos(radians(0.5*frameCount+i)), -1, 1, 0, width);
    wy = map(sin(radians(0.2*frameCount+10*i)), -1, 1, 0, height);
    rect(wx, wy, 5, 10);
  }
  popMatrix();



  //masterSli.setValue(0.5);

  pushMatrix();
  translate(width-width/6, height/2);
  ball.setA0(100);
  ball.setColor(color(frameCount%255, 255, map(channelVolumes[4], 0, 1.5, 0, 255)));
  ball.drawBall(map(sin(radians(frameCount)), -1, 1, 0, 0.3));
  popMatrix();
  hint(DISABLE_DEPTH_TEST);

  for (int j=0; j<muteMask.length; j++) {
    //not soloed not muted
    channelVolumes[j] = volumes[j] * muteMask[j];
  }
  float soloSum = sum(soloMask);
  for (int i=0; i<soloMask.length; i++) {
    if (soloSum!=0)channelVolumes[i] = volumes[i] * soloMask[i];
  }
  channelVolumes[4] = volumes[4];

  println();
  println(channelVolumes);
}

float sum(float[] a) {
  float sum=0;
  for (int i=0; i<a.length; i++) {
    sum = sum+a[i];
  }
  return sum;
}

void showMixer() {
  drumSli.show();
  bassSli.show();
  padSli.show();
  arpSli.show();
  masterSli.show();
  mutes.show();
  solos.show();
};

void hideMixer() {
  drumSli.hide();
  bassSli.hide();
  padSli.hide();
  arpSli.hide();
  masterSli.hide();
  mutes.hide();
  solos.hide();
}

void mutes(float[] a) {
  for (int i=0; i<a.length; i++) {
    boolean b = a[i]==1;
    b = !b;
    muteMask[i] = b ? 1.0 : 0.0;
  }
}

void solos(float[] a) {
  for (int i=0; i<a.length; i++) {
    boolean b = a[i]==1;
    soloMask[i] = b ? 1.0 : 0.0;
  }
}


// MYFADER
class Fader {
  String name;
  Slider fader;
  int volume;
  int id;

  Fader(String theName, int theId) {
    id = theId;
    name = theName;
    fader = cp5.addSlider(name)
      .setSize(width/16, height/4*2)
      .setRange(0, 3)
      .setValue(2)
      .setSliderMode(Slider.FLEXIBLE)
      .setLabelVisible(false)
      .setColorActive(activeColor)
      .setColorForeground(unhex("ffff006d"))
      //.setColorBackground(unhex("ff020122"))
      .setColorBackground(bgColor)
      ;
  }

  float getVolume() {
    float val = cp5.getController(name).getValue();
    //double vol =  20*Math.log10((double)map(val/3, 0, 4, 0.0001, 4));
    double vol =  20*Math.log10((double)map(val/2, 0, 3, 0.0001, 3));
    float a = (float)vol;
    a = (float)round(a*100)/100;
    return a;
  }

  int getWidth() {
    return cp5.getController(name).getWidth();
  }

  int getHeight() {
    return cp5.getController(name).getHeight();
  }

  float[] getPosition() {
    return cp5.getController(name).getPosition();
  }

  void setPosition(int x0, int y0) {
    fader.setPosition(x0, y0);
    //textAlign(CENTER);
    //textSize(30);
    //text(name, fader.getPosition()[0]+fader.getWidth()/2, fader.getPosition()[1]-labelPaddingY);
  }

  void setValue(float theVal) {
    double val = constrain(theVal, 0.0001, 1.5);
    volumes[id] = (float)val;
    //println("val: "+val);

    double vol1 = 20*Math.log10(val);
    //println("vol_1: "+vol1);

    float vol = (float)vol1;
    vol = pow(10, vol/20);
    //println("vol_2: "+vol);

    float faderVal = map(vol, 0, 1.5, 0, 3);
    //println("faderVal: "+faderVal  );

    fader.setValue(faderVal);
  };

  void update() {
    volumes[id] = pow(10, getVolume()/20);
    float xcenter = fader.getPosition()[0]+fader.getWidth()/2;
    String volume = String.valueOf(getVolume());

    if (fader.isVisible()) {
      // Name Label
      textAlign(CENTER);
      //textFont(arial);
      fill(255);
      textSize(30);
      text(name, xcenter, fader.getPosition()[1]-labelPaddingY);

      // Value label
      textSize(20);
      text(volume + " dB", xcenter, fader.getPosition()[1]+fader.getHeight()+30);
    }
    setVolume();
  }

  void show() {
    cp5.getController(name).setVisible(true);
  }

  void hide() {
    cp5.getController(name).setVisible(false);
  }
}
