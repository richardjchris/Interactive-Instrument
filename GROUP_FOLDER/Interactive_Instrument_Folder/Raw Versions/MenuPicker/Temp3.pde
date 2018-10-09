class TempThree {

  private void initiate() {
    surface.setSize(900, 500);
  }

  private void hide()
  {
    fill(255);
    rect(0, 0, width, height);
  }

  private void display()
  {
    background(200, 168, 100);
    fill(0);
    textSize(width/20);
    text("Temp Option 3", (width/2)-50, (height/2));
  }
}
