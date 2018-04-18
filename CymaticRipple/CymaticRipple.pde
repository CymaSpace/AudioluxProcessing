import controlP5.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;
AudioInput input;
FFT fft;
float spectrumScale = 400;
RippleVisualization rv;
ControlApplet ctrl;

float _gain = 10.0;
float _offset = 127.0;
float _cutoff = 20.0;
float _spread = 5.0;
float _speed = 3.0;
boolean _drawEllipse = false;
 
void setup()
{
  size(500, 500);
  surface.setResizable(true);
  ctrl = new ControlApplet(this);
 
  minim = new Minim(this);
  input = minim.getLineIn();
  
  fft = new FFT(input.bufferSize(), input.sampleRate());
  fft.window(FFT.HANN);
  //fft.logAverages(22, 3);
  fft.linAverages(30);
  rv = new RippleVisualization(fft, input, 501, 1, true);
}

void draw()
{
  background(0);
  rv.update();
  rv.draw();
  /*
  stroke(255);
  fft.forward(input.mix);

 
  for(int i = 0; i < fft.specSize(); i++)
  {
    // convert the magnitude to a DB value. 
    // this means values will range roughly from 0 for the loudest
    // bands to some negative value.
    float bandDB = 20 * log( 2 * fft.getBand(i) / fft.timeSize() );
    // so then we want to map our DB value to the height of the window
    // given some reasonable range
    float bandHeight = map( bandDB, 0, -150, 0, height );
    line(i, height, i, bandHeight );
  }
  fill(255);
  */
}
