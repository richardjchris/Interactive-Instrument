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
  
  void processFrame(PImage frame) {
    opencv.loadImage(frame);
    opencv.flip(90);
    opencv.blur(2);
    opencv.inRange(minRange, maxRange);
    thresh = opencv.getOutput();
  }
  
  void testSample() {
    sampleMedians[0] = sampleMedian(153, 105);
    sampleMedians[1] = sampleMedian(154, 133);
    sampleMedians[2] = sampleMedian(157, 118);
    sampleMedians[3] = sampleMedian(137, 151);
    sampleMedians[4] = sampleMedian(170, 133);
    findQuartile();
  }
  
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
    minRange = (int)lowest;
    maxRange = (int)highest;
  }
  
  float sampleMedian(int x, int y) {
    float median = 0;
    pixelSample = get(x, y);
    red = red(pixelSample);
    float total = red(pixelSample) + green(pixelSample) + blue(pixelSample);
    //println(total);
    median = total/765 * 255;
    return median;
  }
  
  void sensorControl(char pressedKey) {
    if (pressedKey == 'a') {
      minRange+=5;
      println(minRange);
    } else if (pressedKey == 'z') {
      minRange-=5;
      println(minRange);
    } else if (pressedKey == 's') {
      maxRange+=5;
      println(maxRange);
    } else if (pressedKey == 'x') {
      maxRange-=5;
      println(maxRange);
    }
  }
  
  
}
