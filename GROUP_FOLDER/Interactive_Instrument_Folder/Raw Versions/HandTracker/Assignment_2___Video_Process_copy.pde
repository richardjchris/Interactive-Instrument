//Official Hand Tracking main
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


void setup() {
  size(640, 480);
  globalCenters = new ArrayList<PVector>();
  video = new Capture(this, 320, 240);
  video.start();
  frame = createImage(320, 240, RGB);
  opencv = new OpenCV(this, frame);
  filterVid = new VideoProcess(80, 255);
  tracking = new MainTracking();
}

void draw() {
  video.loadPixels();
  pushMatrix();
  translate(video.width,0);
  scale(-1, 1);
  image(video, 0, 0);
  popMatrix();
  
  filterVid.processFrame(frame);
  image(thresh, 320, 0);
  globalCenters = tracking.currentCenters;
  tracking.trackingUpdate();
  
  println(globalCenters.size());
  
  updatePixels();
}

void mousePressed() {
  filterVid.testSample();
  tracking.resetAll();
}

void keyPressed() {
  filterVid.sensorControl(key);
}

void captureEvent(Capture video) {
  frame.copy(video, 0, 0, video.width, video.height, 0, 0, frame.width, frame.height);
  frame.updatePixels();
  video.read();
}
