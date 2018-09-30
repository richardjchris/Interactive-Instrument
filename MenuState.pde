public class MenuState {
  
  String currentSTATE;
  int windowWidth = 1280;
  int windowHeight = 720;
  int rectX = width/2 - 100;
  int rectY = 400;
  int rectWidth = 200;
  int rectHeight = 100;
  color thereminColor = color(170, 219, 37);
  color thereminHighlight = color(195, 249, 47);
  color thereminSelection = color(227, 255, 148);
  color currentColor;
  boolean pressed = false;
  
  Timer theTimer = new Timer(10);
  
  MenuState(String current) {
    currentSTATE = current;
  }
  
  //This checks the running state and coordinates the present menu to run
  void runState() {
    switch (currentSTATE) {
      case "menu" : renderMenu(); break;
      case "theremin" : renderSynthTheremin(); break;
      case "capture" : captureSample(); break;
      default : renderMenu();
    }
  }
  
  //This function changes the present states of the menu
  void changeState(String changeState) {
    if (changeState.equals("menu")) {
      key = 0;
      currentSTATE = "menu";
      pressed = false;
      
    } else if (changeState.equals("theremin")) {
      theTimer.finished = false;
      key = 0;
      currentSTATE = "theremin";
      pressed = false;
      
      //Declare Theremin Player
      synth = new Theremin(4, height);
      synth.begin();
      
    } else if (changeState.equals("capture")) {
      theTimer.setTime(10);
      currentSTATE = "capture";
      pressed = false;
 
    }
  }
  
  //This renders the primary main menu of the program
  void renderMenu() {
    background(50, 50, 50);
    
    fill(255);
    textSize(60);
    text("Interactive Theremin", windowWidth / 4 + 20, windowHeight / 3);
    
    //This is the theremin button
    if (hoverRectButton()) {
      if (pressed == true) {
        fill(thereminSelection);
        stroke(0);
        rect(rectX, rectY, rectWidth, rectHeight, 4);
        changeState("capture");
      } else {
          fill(thereminHighlight);
      }
    } else {
      fill(thereminColor);
    }
    stroke(0);
    rect(rectX, rectY, rectWidth, rectHeight, 4);
    
    fill(255);
    textSize(32);
    text("Theremin", rectX + 25, rectY + 60);
    
  }
  
  //This captures the samples of values that will be used for video processing
  void captureSample() {
      background(0);
      pushMatrix();
      translate(video.width,0);
      scale(-1, 1);
      image(video, 0, 0);
      popMatrix();
      
      noFill();
      stroke(255, 0, 0);
      strokeWeight(2);
      ellipse(640, 280, 15, 15);
      ellipse(620, 320, 15, 15);
      ellipse(650, 360, 15, 15);
      ellipse(660, 400, 15, 15);
      ellipse(640, 430, 15, 15);
      
      theTimer.countDown();
      fill(255);
      textSize(50);
      text(theTimer.getTime(), 20, 60);
      textSize(30);
      text("From about 1 meter distance. Cover the dots with your hand", 23, 100);
      if (theTimer.finished == true) {
        //println("changed to renderSynth");
        filterVid.testSample();
        changeState("theremin");
      }
  }
  
  // This renders the test theremin that test the global centers of the tracked centers.
  void renderSynthTheremin() {
    background(33, 33, 33);
    keyPressed();
    
    filterVid.processFrame(frame);
    tint(255, 160);
    image(thresh, 0, 0);
    globalCenters = tracking.currentCenters;
    tracking.trackingUpdate();
    if (globalCenters.size() > 0) {
      synth.update((int)globalCenters.get(0).y);
    } else {
      synth.update(height);
    }
  }
  
  // This is created for the primary button in the menu
  boolean hoverRectButton() {
    if (mouseX >= rectX && mouseX <= rectX + rectWidth && mouseY >= rectY && mouseY <= rectY + rectHeight) {
      return true;
    } else {
      return false;
    }
  }
  
  void keyPressed() {
    if (key == 'q') {
      synth.ac.stop();
      changeState("menu");
    }
    // This is a fine tuning control for filter
    if (currentSTATE == "theremin" && keyPressed == true) {
      filterVid.sensorControl(key);
    }
  }
  
}
