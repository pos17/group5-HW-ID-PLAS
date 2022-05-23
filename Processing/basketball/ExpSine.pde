class ExpSine {
  int numPoints, amp;
  float x0, y0;
  FloatList prevY = new FloatList();
  float freq, xspacing;
  color c = color(0,0,255);

  ExpSine(float h0, int numPoints, float freq, int amp) {
    this.numPoints = numPoints;
    //this.x0 = x0;
    this.y0 = h0;
    this.freq = freq;
    float w =  width/2;
    this.xspacing = w/numPoints;
    print("xspacing: ");
    println(this.xspacing);
    this.amp = amp;
  }

  void calcWave(float time, float t0) {
    float omega = TWO_PI*this.freq;
    float y = sin(radians(omega*time))*this.amp;
    this.prevY.append(y);
    while (prevY.size()>this.numPoints) this.prevY.remove(0);

    for (float i = prevY.size()-1; i>0; i--) {
      this.prevY.set(int(i), this.prevY.get(int(i))*exp(-(time-t0)/10000));
    }
  }

  void update() {
    noFill();
    strokeWeight(7);
    //translate(0, this.y0);
    for (int x =1; x<this.prevY.size(); x++) {
      //translate(this.xspacing, 0);
      stroke(this.c, 20+235*x/this.prevY.size());
      //stroke(255*x/this.prevY.size(), 255*x/this.prevY.size(), 255, 255*x/this.prevY.size());
      line((x)*this.xspacing, this.y0+this.prevY.get(x-1), (x+1)*this.xspacing, this.y0+this.prevY.get(x));
    }
  }
  
  
  
  void setColor(color col){
    this.c = col;
  }
}
