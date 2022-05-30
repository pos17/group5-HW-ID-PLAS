void drawSensorWindow() {
  hint(ENABLE_DEPTH_TEST);

  textFont(createFont("Arial", 50));
  text("SENS 1", 50, height/4-50);
  text("SENS 2", 50, height/2-50);
  text("SENS 3", 50, height/4*3-50);
  
  
  sens1.init(250, height/4-150);
  sens2.init(250, height/2-150);
  sens3.init(250, height/4*3-150);

  sens1.update(sin(radians(frameCount))*50);
  sens2.update(sin(radians(10*frameCount))*30);
  sens3.update(sin(radians(20*frameCount))*40);
  
  pushMatrix();
  translate(width-width/6, height/2);
  ball.setA0(120);
  ball.drawBall();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
}
