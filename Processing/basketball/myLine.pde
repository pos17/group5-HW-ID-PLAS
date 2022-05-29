class myLine {
  FloatList prevX;
  FloatList prevY;
  FloatList prevZ;
  //float radius;
  int numLines;
  float x0;
  float y0;
  float z0;
  color lineColor = color(0,0,255);

  float randomness;

  myLine(float x0, float y0, float z0, int numLines, float randomness) {
    prevX = new FloatList();
    prevY = new FloatList();
    prevZ = new FloatList();

    prevX.append(x0);
    prevY.append(y0);
    prevZ.append(z0);

    this.x0 = x0;
    this.y0 = y0;
    this.z0 = z0;
    this.numLines = numLines;

    this.randomness = randomness;
  }

  void setNumLines (int numLines) {
    this.numLines = numLines;
  }
  
  void setRandomness (int randomness) {
    this.randomness = randomness;
  }

  void update(float x, float y, float z) {

    prevX.append(x+ randomness * random(-1, 1));
    prevY.append(y+ randomness * random(-1, 1));
    prevZ.append(z+ randomness * random(-1, 1));

    if (y==0) prevY.set(prevY.size()-1, randomness*random(-1, 1));
    if (x==0) prevX.set(prevY.size()-1, randomness*random(-1, 1));
    if (z==0) prevZ.set(prevY.size()-1, randomness*random(-1, 1));

    while (prevX.size()>this.numLines) {
      prevX.remove(0);
      prevY.remove(0);
      prevZ.remove(0);
    }
  }

  void drawLine() {
    for (int i=3; i<prevX.size(); i++) {

      noFill();
      //stroke(255*i/numLines, 255, 255, 55 + 200*i/numLines);
      //stroke(0, 0, 255, 55 + 200*i/numLines);
      stroke(map(i, 0, numLines, (hue(lineColor)-50), hue(lineColor)), saturation(lineColor), brightness(lineColor), 55 + 200*i/numLines);
      strokeWeight(5+15*i/numLines);

      curve(
        prevX.get(i-3),
        prevY.get(i-3),
        prevZ.get(i-3),
        prevX.get(i-2),
        prevY.get(i-2),
        prevZ.get(i-2),
        prevX.get(i-1),
        prevY.get(i-1),
        prevZ.get(i-1),
        prevX.get(i),
        prevY.get(i),
        prevZ.get(i)
        );
    }
  }
  void changeRadius(float radius) {
    for (int i=0; i<prevX.size(); i++) {
      PVector pv = new PVector(prevX.get(i), prevY.get(i), prevZ.get(i));
      pv.setMag(radius);
      prevX.set(i, pv.x);
      prevY.set(i, pv.y);
      prevZ.set(i, pv.z);
    }
  }
  
  void setColor(color aColor){
    lineColor = aColor;
  }
}
