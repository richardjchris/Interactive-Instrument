import beads.*;

public class Theremin {
  
  float harmonicityRatio;
  int y_height;
  AudioContext ac;
  Glide HoriFreq;
  Glide VertFreq;
  WavePlayer wq;
  Gain g;
  
  Theremin(float harmonicity, int sizeY) {
    harmonicityRatio = harmonicity;
    y_height = sizeY;
  }
  
  void begin() {
    ac = new AudioContext();
    HoriFreq = new Glide(ac, 1);
    //VertFreq = new Glide(ac, vertical);
    
    wq = new WavePlayer(ac, 30* harmonicityRatio, Buffer.SINE);
    g = new Gain(ac, 1, HoriFreq);
    g.addInput(wq);
    ac.out.addInput(g);
    ac.start();
  }
  
  void update(int centerY) {
    wq.setFrequency(valBound(valInvert(centerY, y_height)));
  }
  
  //limits the range within a calculated boundary
  float valBound(float pos) {
    return map(pos, 0, y_height, 100, 830);
  }
  
  // This inverts the input to properly orientate the frequency used
  float valInvert(float pos, int distance) {
    return (distance - pos);
  }
  
}
