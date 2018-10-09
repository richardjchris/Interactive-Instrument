//Code and Sound Made by: Richard Christiansen
import beads.*;

class Piano {


  private float harmonicity;

  //Booleans
  //boolean[] pressed = new boolean[4]; //Mouse press
  private boolean[] pianoOver = new boolean[4]; //Mouse Over Keys
  private boolean[] optionOver = new boolean[4]; //Mouse Over Options
  private boolean[] keyHold = new boolean[4]; //Prevents unwanted playback when key is being held down.
  private boolean[] piano = new boolean[4]; //Keyboard press
  private boolean sOne = true;
  private boolean sTwo = false;

  //Colors
  private color currentColor;
  private color baseColor = color(255, 204, 153);
  private color fillColor = color(217, 255, 179);
  private color mouseColor = color(0, 228, 0);
  private color pianoColor = color(64, 128, 0);

  //Integers
  public int[] pianoX = new int[4];
  public int[] pianoY = new int[4];
  private int pianoSizeX, pianoSizeY, pianoDeviation;
  private int[] optionX = new int[2];
  private int[] optionY = new int[2];
  private float optionSizeY, optionSizeX;
  private int speedRate;
  private int volume;
  private int waveform = 3; //Amount of waveforms generated
  private int keyInt;

  //Audio Synthesis Initialization
  private AudioContext ac;
  private WavePlayer[] wp = new WavePlayer[waveform];
  private Gain[] g = new Gain[waveform];
  private Gain[] lpGain = new Gain[waveform];
  private Envelope[] env = new Envelope[waveform];
  private LPRezFilter[] lp = new LPRezFilter[waveform];

  private void initiate() {
    surface.setSize (600, 500); 
    pianoSizeX = width/5;
    pianoSizeY = height/2;
    optionSizeX = width/2.38;
    optionSizeY = height/10;
    pianoDeviation = pianoSizeX+width/50;
    speedRate = 1;
    volume = 3;
  }

  private void display()
  {
    mouseUpdate();
    background(currentColor);
    instructions();
    drawRect();
    currentColor = baseColor;
    drawOption();
  }

  //void inputCheck()
  //{
  //  if(stateVar == 1)
  //  {
  //   mousePressed();
  //   mouseReleased();
  //   keyTyped();
  //   keyReleased();
  //  }
  //}

  private void instructions()
  {
    fill(0);
    textAlign(LEFT);
    textSize(12*width/500);
    String s = "Press the listed key(s) or click on the buttons to play a sound.";
    String e = "Q: Decrease Speed    W: Increase Speed";
    String t = "G: Decrease Volume  T: Increase Volume";
    String f = "Speed Rate: " + speedRate;
    String j = "Volume: " + volume;
    text(s, 5, 5*500/height, width, height);
    fill(255, 0, 0);
    text("CONTROLS:", 5, 25*500/height, width, height);
    fill(0);
    text(e, 5, 45*500/height, width, height);
    text(t, 5, 65*500/height, width, height);
    if (speedRate==5)
    {
      text(f+" (MAX SPEED)", 5, (height-25*500/height), width, height);
    } else
    {
      text(f, 5, (height-25*500/height), width, height);
    }
    textAlign(RIGHT);
    if (volume==5)
    {
      text(j+" (MAX VOLUME)  ", 5, (height-25*500/height), width, height);
    } else if (volume==1)
    {
      text(j+" (MIN VOLUME)", -5, (height-25*500/height), width, height);
    } else
    {
      text(j, -5, (height-25*500/height), width, height);
    }
  }

  private void drawRect()
  {
    for (int j=0; j<4; j++)
    { 
      pianoX[j] = (width/14) + (pianoDeviation*j);
      pianoY[j] = height/2-pianoSizeY/2;

      if (pianoOver[j] && !piano[j])
      {
        fill(mouseColor);
      } else if (piano[j])
      {
        fill(pianoColor);
        //soundPlay[j];
      } else if (!pianoOver[j] || !piano[j])
      {
        fill(fillColor);
      }
      rect(pianoX[j], pianoY[j], pianoSizeX, pianoSizeY);
      //Text
      fill(0);
      textAlign(CENTER);
      textSize(pianoSizeX-width/10);
      if (j == 0) {
        text("D", pianoX[j]+pianoSizeX/2, pianoY[j]+pianoSizeY/1.1);
      }
      if (j == 1) {
        text("F", pianoX[j]+pianoSizeX/2, pianoY[j]+pianoSizeY/1.1);
      }
      if (j == 2) {
        text("J", pianoX[j]+pianoSizeX/2, pianoY[j]+pianoSizeY/1.1);
      }
      if (j == 3) {
        text("K", pianoX[j]+pianoSizeX/2, pianoY[j]+pianoSizeY/1.1);
      }
    }
  }

  void drawOption()
  {  
    for (int j=0; j<2; j++)
    {
      optionX[j] = pianoX[0+j*2];
      optionY[j] = pianoY[0]+pianoSizeY+20;
    }

    //Left Option
    if (sOne == true && optionOver[0] == false)
    {
      fill(181, 208, 252);
    } else  if (optionOver[0] == true)
    {
      fill(180, 182, 186);
    } else
    {
      fill(255);
    }
    rect(optionX[0], optionY[0], optionSizeX, optionSizeY);
    fill(0);
    textSize(25*width/500);
    text("Sound 1", optionSizeX/1.5, optionY[0]+optionSizeY/1.5);

    //Right Option
    if (sTwo == true && !optionOver[1] )
    {
      fill(181, 208, 252);
    } else  if (optionOver[1] == true)
    {
      fill(180, 182, 186);
    } else
    {
      fill(255);
    }
    rect(optionX[1], optionY[1], optionSizeX, optionSizeY); 
    fill(0);
    text("Sound 2", optionSizeX*1.7, optionY[0]+optionSizeY/1.45);
  }

  void mouseUpdate()
  {
    for (int i=0; i < 4; i++)
    {
      if ((mouseX >= pianoX[i])&&(mouseX <= pianoX[i]+pianoSizeX)&&(mouseY >= pianoY[i])&&(mouseY <= pianoY[i]+pianoSizeY))
      {
        pianoOver[i]=true;
      } else
      {
        pianoOver[i]=false;
      }
    }

    for (int j=0; j < 2; j++)
    {
      if ((mouseX >= optionX[j])&&(mouseX <= optionX[j]+optionSizeX)&&(mouseY >= optionY[j])&&(mouseY <= optionY[j]+optionSizeY))
      {
        optionOver[j]=true;
      } else
      {
        optionOver[j]=false;
      }
    }
  }
  
  void mousePressCheck()
  {
      for (int i=0; i < 4; i++)
      {
        if (pianoOver[i])
        {
          piano[i] = true;
          keyInt = i;
          sound();
        }

      if (optionOver[0])
      {
        sOne = true;
        sTwo = false;
      }

      if (optionOver[1])
      {
        sTwo = true;
        sOne = false;
      }
    }
  }

  void mouseReleaseCheck()
  {
    if (stateVar == 1)
    {
      for (int i=0; i < 4; i++)
      {
        if (pianoOver[i])
        {
          piano[i] = false;
        }
      }
    }
  }

void keyPressCheck()
  {
    if (stateVar == 1)
    {
      if (key=='D' || key == 'd' && !keyHold[0])
      {
        piano[0] = true;
        keyInt = 0;
        sound();
        keyHold[0] = true;
      }

      if (key=='F' || key == 'f' && !keyHold[1])
      {
        piano[1] = true;
        keyInt = 1;
        sound();
        keyHold[1] = true;
      }

      if (key=='J' || key == 'j' && !keyHold[2])
      {
        piano[2] = true;
        keyInt = 2;
        sound();
        keyHold[2] = true;
      }

      if (key=='K' || key == 'k' && !keyHold[3])
      {
        piano[3] = true;
        keyInt = 3;
        sound();
        keyHold[3] = true;
      }

      if (key=='W' || key == 'w')
      {
        if (speedRate!=5)
        {
          speedRate+=1;
        }
      }
      if (key=='Q' || key == 'q')
      {
        if (speedRate!=1)
        {
          speedRate-=1;
        }
      }

      if (key=='G' || key == 'g')
      {
        if (volume!=1)
        {
          volume-=1;
        }
      }
      if (key=='T' || key == 't')
      {
        if (volume!=5)
        {
          volume+=1;
        }
      }
    }
  }

  void keyReleaseCheck()
  {
    if (stateVar == 1)
    {
      if (key=='D' || key == 'd' && keyHold[0])
      {
        piano[0] = false;
        keyHold[0] = false;
      }

      if (key=='F' || key == 'f' && keyHold[1])
      {
        piano[1] = false;
        keyHold[1] = false;
      }

      if (key=='J' || key == 'j' && keyHold[2])
      {
        piano[2] = false;
        keyHold[2] = false;
      }

      if (key=='K' || key == 'k' && keyHold[3])
      {
        piano[3] = false;
        keyHold[3] = false;
      }
    }
  }

  private void sound()
  {
    harmonicity = 400.0f + 100.0f*keyInt;
    ac = new AudioContext(); 
    if (sOne==true && sTwo == false)
    {
      soundOne();
    } else if (sOne==false && sTwo == true)
    {
      soundTwo();
    }
    ac.start();
    float volModifier = 0.2*volume;

    for (int i = 0; i < waveform; i++)
    {
      env[i].addSegment(volModifier/(i+1), 200.0f/speedRate); //Attack
      env[i].addSegment((volModifier-0.1f)/(i+1), 300.0f/speedRate); //Decay
      env[i].addSegment((volModifier-0.2f)/(i+1), 400.0f/speedRate); //Sustain
      env[i].addSegment(0.0f/(i+1), 500.0f/speedRate); //Release
    }
  }

  private void soundOne()
  {

    for (int i = 0; i < waveform; i++)
    {
      wp[i] = new WavePlayer(ac, harmonicity + (100.0f*i), Buffer.SAW);

      lpGain[i] = new Gain(ac, 1, 0.8f / (i+1));
      lp[i] = new LPRezFilter(ac, lpGain[i], 0.95f);
      lp[i].addInput(wp[i]);

      env[i] = new Envelope(ac, 0.0f/(i+1));
      g[i] = new Gain(ac, 1, env[i]);

      g[i].addInput(lp[i]);
      ac.out.addInput(g[i]);
    }
  }

  private void soundTwo()
  {
    for (int i = 0; i < waveform; i++)
    {
      wp[i] = new WavePlayer(ac, harmonicity + (200.0f*i), Buffer.SINE);

      lpGain[i] = new Gain(ac, 1, 0.8f / (i+1));
      lp[i] = new LPRezFilter(ac, lpGain[i], 0.95f);
      lp[i].addInput(wp[i]);

      env[i] = new Envelope(ac, 0.0f/(i+1));
      g[i] = new Gain(ac, 1, env[i]);

      g[i].addInput(lp[i]);
      ac.out.addInput(g[i]);
    }
  }
}
