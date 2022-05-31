Plot sens1, sens2, sens3;
float accData=0, gyrData=0, handData=0;

void drawSensorWindow() {
  pushMatrix();
  textFont(createFont("Arial", 50));
  hint(ENABLE_DEPTH_TEST);

  sens1.init(200, height/4-150);
  sens2.init(200, height/2-150);
  sens3.init(200, height/4*3-150);

  //sens1.update(sin(radians(frameCount))*50);
  //sens2.update(sin(radians(10*frameCount))*30);
  //sens3.update(sin(radians(20*frameCount))*40);

  if (millis()-shakeValResetTime > shakeValResetDelay) {
    shakeValue = 0;
    shakeValResetTime = millis();
  }

  sens1.update(shakeValue);
  sens2.update(accData);
  sens3.update(gyrData);

  pushMatrix();
  translate(width-width/6, height/2);
  noStroke();
  for (int i=0; i<400; i++) {
    float wx = map(sin(radians(0.2*frameCount+i*5)), -1, 1, -width/6, width/6);
    float wy = map(cos(radians(frameCount+i*2)), -1, 1, -height/2, height/2);
    float c = map(sin(radians(2*frameCount+10*i)), -1, 1, 0, 255);
    fill(c);
    rect(wx, wy, 5, 2);
    wx = map(cos(radians(0.5*frameCount+i)), -1, 1, -width/6, width/6);
    wy = map(sin(radians(0.2*frameCount+10*i)), -1, 1, -height/2, height/2);
    rect(wx, wy, 5, 2);
  }
  pushMatrix();
  ball.setA0(width/14);
  ball.setColor(color(frameCount%255, 255, map(channelVolumes[4], 0, 1.5, 0, 255)));
  ball.drawBall(0);
  popMatrix();
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
  popMatrix();
}
