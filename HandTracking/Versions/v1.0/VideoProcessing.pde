import gab.opencv.*;

public class VideoProcess {
  
  int minRange;
  int maxRange;
  float red;
  float green;
  float blue;
  float median;
  float[] sampleMedians = new float[5];
  color pixelSample;
  
  VideoProcess(int min, int max) {
    minRange = min;
    maxRange = max;
  }
  
  //This processes the input frame of a video and outputs the binary masked produce from range.
  void processFrame(PImage frame) {
    opencv.loadImage(frame);
    opencv.flip(90);
    opencv.blur(2);
    opencv.inRange(minRange, maxRange);
    thresh = opencv.getOutput();
  }
  
  // This collects and takes samples of different pixels
  void testSample() {
    sampleMedians[0] = sampleMedian(640, 280);
    sampleMedians[1] = sampleMedian(620, 320);
    sampleMedians[2] = sampleMedian(650, 360);
    sampleMedians[3] = sampleMedian(660, 400);
    sampleMedians[4] = sampleMedian(640, 430);
    findQuartile();
  }
  
  //This finds the highest and lowest range and stretches its value to produce a trackable range
  void findQuartile() {
    float highest = sampleMedians[0];
    float lowest = sampleMedians[0];
    for (float sample : sampleMedians) {
      if (sample < lowest) {
        lowest = sample;
      } else if (sample > highest) {
        highest = sample;
      }
    }
    minRange = (int)lowest - 15;
    maxRange = (int)highest + 15;
  }
  
  //This is used in tandem with "testSample" to produce an output of a median based on the rgb value -> this outputs a value in HSV for binary masking
  float sampleMedian(int x, int y) {
    float median = 0;
    pixelSample = get(x, y);
    red = red(pixelSample);
    float total = red(pixelSample) + green(pixelSample) + blue(pixelSample);
    //println(total);
    median = total/765 * 255;
    return median;
  }
  
  // THESE ARE FINE TUNING CONTROLS IF YOU WANT TO MODIFY THE BINARY MASK RANGE
  void sensorControl(char pressedKey) {
    if (pressedKey == 'a') {
      minRange+=5;
    } else if (pressedKey == 'z') {
      minRange-=5;
    } else if (pressedKey == 's') {
      maxRange+=5;
    } else if (pressedKey == 'x') {
      maxRange-=5;
    }
  } 
}
