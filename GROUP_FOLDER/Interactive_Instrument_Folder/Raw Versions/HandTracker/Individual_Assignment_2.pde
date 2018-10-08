// This is the Official DevelopmentVersion of the Assignment

/*

It is essential that you download these libraries before usage

- Beads library >> v1.01
- OpenCV library >> v0.5.4
- Processing Video Library >> v1.0.1

The function of this component of the project is to serve as the interactive 
input that can be derived from the hand tracking through the webcam. 
Initially, tracking of each gesture was going to be used. However it was suitable
to utilise just tracking of hands through the webcam as the gesture recognition often 
caused framerates to significantly drop (considering that multiple hands would be tracked.)
Furthermore, this component can be further modified to suit different types of instruments 
and can used the theremin as another implemented instrument in the array of instruments that would 
be available.


*/

import beads.*;
import processing.video.*;
import gab.opencv.*;
import java.util.*;

//global Lists
ArrayList<PVector> globalCenters;

//AV
Capture video;
OpenCV opencv;
PImage frame, thresh;
VideoProcess filterVid;
MainTracking tracking;
Theremin synth;
MenuState STATE;


void setup() {
  size(1280, 720);
  globalCenters = new ArrayList<PVector>();
  video = new Capture(this, 1280, 720);
  video.start();
  frame = createImage(1280, 720, RGB);
  opencv = new OpenCV(this, frame);
  filterVid = new VideoProcess(80, 255);
  tracking = new MainTracking();
  
  //Declares State
  STATE = new MenuState("menu");
}

void draw() {
  video.loadPixels();
  STATE.runState();
  updatePixels();
}

void mousePressed() {
  
  if (STATE.currentSTATE.equals("menu")) {
    if(STATE.hoverRectButton()) {
      STATE.pressed = true;
    }
  }
}

//Captures the frame events in the video
void captureEvent(Capture video) {
  frame.copy(video, 0, 0, video.width, video.height, 0, 0, frame.width, frame.height);
  frame.updatePixels();
  video.read();
}
