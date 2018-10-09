class TempTwo {

  private void initiate() {
    surface.setSize(900, 900);
  }

  private void hide()
  {
    //fill(255);
    //rect(0, 0, width, height);
    background(255,0);
  }

  private void display()
  {
    background(92, 68, 200);
    fill(0);
    textSize(width/20);
    text("Temp Option 2", (width/2)-50, (height/2));
  }
}
