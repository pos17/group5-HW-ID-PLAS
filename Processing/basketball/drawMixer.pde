//Slider drumSli, bassSli, padSli, arpSli;
Fader drumSli, bassSli, padSli, arpSli, masterSli;
float drumVol, bassVol, padVol, arpVol, masterVol;

int sliderPadding = 100, labelPaddingY = 20;
int sliderHeight=120;

void setupMixer() {
  drumSli = new Fader("Drum");
  bassSli = new Fader("Bass");
  padSli = new Fader("Pad");
  arpSli = new Fader("Arp");
  masterSli = new Fader("Master");
  drumSli.setPosition(sliderPadding, sliderHeight);
  bassSli.setPosition((int)drumSli.getPosition()[0]+drumSli.getWidth()+sliderPadding, sliderHeight);
  padSli.setPosition((int)bassSli.getPosition()[0]+bassSli.getWidth()+sliderPadding, sliderHeight);
  arpSli.setPosition((int)padSli.getPosition()[0]+padSli.getWidth()+sliderPadding, sliderHeight);
  masterSli.setPosition((int)arpSli.getPosition()[0]+arpSli.getWidth()+(sliderPadding*2), sliderHeight);

}


void drawMixer() {
  hint(ENABLE_DEPTH_TEST);
  
  drumSli.update();
  bassSli.update();
  padSli.update();
  arpSli.update();
  masterSli.update();
  
  pushMatrix();
  translate(width-width/6, height/2);
  ball.setA0(120);
  ball.drawBall();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}

void showMixer(){
  drumSli.show();
  bassSli.show();
  padSli.show();
  arpSli.show();
  masterSli.show();
};

void hideMixer(){
  drumSli.hide();
  bassSli.hide();
  padSli.hide();
  arpSli.hide();
  masterSli.hide();
}

// MYFADER
class Fader {
  String name;
  Slider fader;
  int volume;

  Fader(String theName) {
    name = theName;
    fader = cp5.addSlider(name)
      .setSize(width/16, height/4*2)
      .setRange(0, 4)
      .setValue(3)
      .setSliderMode(Slider.FLEXIBLE)
      .setLabelVisible(false)
      ;
  }

  float getVolume() {
    float val = cp5.getController(name).getValue();
    float vol = 20*log(map(val/3, 0, 4, 0.0001, 4));
    vol = (float)round(vol*100)/100;
    return vol;
  }

  int getWidth() {
    return cp5.getController(name).getWidth();
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

  void update() {
    float xcenter = fader.getPosition()[0]+fader.getWidth()/2;
    String volume = String.valueOf(getVolume());
    // Name Label
    textAlign(CENTER);
    fill(255);
    textSize(30);
    text(name, xcenter, fader.getPosition()[1]-labelPaddingY);
   
    // Value label
    textSize(20);
    text(volume + " dB", xcenter, fader.getPosition()[1]+fader.getHeight()+50);
  }
  void show(){
    cp5.getController(name).show();
  }
  void hide(){
    cp5.getController(name).hide();
  }
}
