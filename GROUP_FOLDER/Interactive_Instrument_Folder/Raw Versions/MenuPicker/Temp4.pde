class TempFour {

  private void initiate() {
    surface.setSize(500, 800);
    //if (stateVar != 4) {
    //  TempFour.Visible(false);
    //}
  }
  private void hide()
  {
    fill(255);
    rect(0, 0, width, height);
  }
  private void display()
  {
    background(120, 148, 100);
    fill(0);
    textSize(width/20);
    text("Temp Option 4", (width/2)-50, (height/2));
  }
}
