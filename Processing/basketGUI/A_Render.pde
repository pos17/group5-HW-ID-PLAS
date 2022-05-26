/*  GUI3D
 *  Ira Winder, ira@mit.edu, 2018
 *
 *  Render Functions (Superficially Isolated from Main.pde)
 *
 *  MIT LICENSE: Copyright 2018 Ira Winder
 *
 *               Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 *               and associated documentation files (the "Software"), to deal in the Software without restriction, 
 *               including without limitation the rights to use, copy, modify, merge, publish, distribute, 
 *               sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is 
 *               furnished to do so, subject to the following conditions:
 *
 *               The above copyright notice and this permission notice shall be included in all copies or 
 *               substantial portions of the Software.
 *
 *               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT 
 *               NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *               NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 *               DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 *               OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// Begin Drawing 3D Elements
//
void render3D() {
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

  angleH += 0.7;
  //a = 100+50*sin(c/10);
  //t+=0.1;
  t = millis()/10*speedBall;
  c+=0.1;
  time2=millis();


}
void setA(float aA) {
  a = aA;
  b= a/1.5;
}
// Begin Drawing 2D Elements
//
void render2D() {
  
  hint(DISABLE_DEPTH_TEST);
  cam.off();
  
  // Diameter of Cursor Objects
  //
  float diam = min(225, 5/pow(cam.zoom, 2));
  
  // Arrow-Object: Draw Cursor Ellipse and Text
  //
  noFill(); stroke(#FFFF00, 200);
  ellipse(s_x, s_y, diam, diam);
  fill(#FFFF00, 200); textAlign(LEFT, CENTER);
  text("OBJECT: Move with Arrow Keys", s_x + 0.6*diam, s_y);
  

  // Click-Object: Draw Cursor Text
  //
  if (cam.enableChunks && cam.chunkField.closestFound && placeAdditions && !cam.hoverGUI()) {
    fill(#00FF00, 200); textAlign(LEFT, CENTER);
    text("Click to Place", cursor_x + 0.3*diam, cursor_y);
  }
    
  // Draw Slider Bars for Controlling Zoom and Rotation (2D canvas begins)
  //
  cam.drawControls();
  
  // Draw Margin ToolBar
  //
  bar_left.draw();
  bar_right.draw();
}

PImage loadingBG;
void loadingScreen(PImage bg, int phase, int numPhases, String status) {

  // Place Loading Bar Background
  //
  image(bg, 0, 0, width, height);
  pushMatrix(); 
  translate(width/2, height/2);
  int BAR_WIDTH  = 400;
  int BAR_HEIGHT =  48;
  int BAR_BORDER =  10;

  // Draw Loading Bar Outline
  //
  noStroke(); 
  fill(255, 200);
  rect(-BAR_WIDTH/2, -BAR_HEIGHT/2, BAR_WIDTH, BAR_HEIGHT, BAR_HEIGHT/2);
  noStroke(); 
  fill(0, 200);
  rect(-BAR_WIDTH/2+BAR_BORDER, -BAR_HEIGHT/2+BAR_BORDER, BAR_WIDTH-2*BAR_BORDER, BAR_HEIGHT-2*BAR_BORDER, BAR_HEIGHT/2);

  // Draw Loading Bar Fill
  //
  float percent = float(phase+1)/numPhases;
  noStroke(); 
  fill(255, 150);
  rect(-BAR_WIDTH/2 + BAR_HEIGHT/4, -BAR_HEIGHT/4, percent*(BAR_WIDTH - BAR_HEIGHT/2), BAR_HEIGHT/2, BAR_HEIGHT/4);

  // Draw Loading Bar Text
  //
  textAlign(CENTER, CENTER); 
  fill(255);
  text(status, 0, 0);

  popMatrix();
}
