class Plot {
  String name;
  int sizeX, sizeY;
  FloatList prevY;
  int numPoints = 40, gridLinesX=30, gridLinesY=10;
  float x0, y0, xspac;
  boolean triggered=false;


  Plot(String theName, int theSizeX, int theSizeY) {
    name = theName;
    sizeX = theSizeX;
    sizeY = theSizeY;
    prevY = new FloatList();
    xspac = sizeX/numPoints;
  }

  void init(float theX0, float theY0) {
    x0 = theX0;
    y0 = theY0;
    //triggered = isTriggered;
    textAlign(CENTER);
    text(name, x0-110, y0+sizeY/2);
    int dx = sizeX/gridLinesX;
    int dy = sizeY/gridLinesY;
    stroke(100);
    strokeWeight(1);
    for (int i=1; i<=gridLinesX; i++) {
      line(x0+dx*i, y0, x0+dx*i, y0+sizeY);
    }
    for (int i=1; i<gridLinesY; i++) {
      line(x0, y0+dy*i, x0+sizeX, y0+dy*i);
    }
  }

  void update(float sig) {
    pushMatrix();
    prevY.append(sig);
    while (prevY.size()>numPoints) prevY.remove(0);
    translate(x0, y0+sizeY);
    for (float i=1; i<prevY.size(); i++) {
      stroke(255);
      strokeWeight(2+7*i/numPoints);
      line((i-1)*xspac, prevY.get(int(i-1)), i*xspac, prevY.get(int(i)));
    }
    popMatrix();
  }
  
  int getHeight(){
    return sizeY;
  }
}
