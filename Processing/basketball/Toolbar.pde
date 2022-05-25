  int margin = 40;
  int barX = margin;
  int barY = margin;
  int barH = 800 - 2*margin;
  int barW = 300;
  int rectX, rectY;      // Position of square button
  int circleX, circleY;  // Position of circle button

  int rectSizeX = 100 ;
  int rectSizeY = height ;
  int circleSize = 93;   // Diameter of circle
  color rectColor, circleColor, baseColor;
  color rectHighlight, circleHighlight;
  color currentColor;
  boolean rectOver = false;
  boolean circleOver = false;
  Toolbar() {}
  void display() {

    background(204, 102, 0);


    // Draw Margin Elements

    pushMatrix();
    translate(barX, barY);

    // Shadow
    pushMatrix();
    translate(3, 3);
    noStroke();
    fill(204, 102, 0);
    rect(0, 0, barW, barH, margin);
    fill(250, 20);
    //noFill();
    rect(0, 0, barW, barH, margin);

    popMatrix();

    // Canvas

    fill(255, 20);
    //noFill();
    noStroke();
    rect(0, 0, barW, barH, margin);

    // Canvas Content
    translate(margin, margin);
    textAlign(LEFT, TOP);
    fill(255);
    //noFill();
    text("ciao", 0, 0, margin, margin);
    popMatrix();
  }
}
