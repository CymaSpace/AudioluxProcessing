class RippleVisualization {
  FFT fft;
  AudioInput input;
  int size;
  int smoothing;
  boolean freq;
  float smoothing_amp[];
  float smoothing_freq[];
  color viz[];
  int max[];
  
  RippleVisualization(FFT _fft, AudioInput _input, int _size, int _smoothing, boolean _freq) {
    fft = _fft;
    input = _input;
    size = _size;
    smoothing = _smoothing;
    freq = _freq;
    
    smoothing_amp = new float[smoothing];
    smoothing_freq = new float[smoothing];
    for (int iX = 0; iX < smoothing; iX++) {
      smoothing_amp[iX] = 0.0;
      smoothing_freq[iX] = 0.0;
    }
    
    viz = new color[size];
    for (int iX = 0; iX < size; iX++) {
      viz[iX] = color(0,0,0);
    }
    
    max = new int[fft.specSize()];
    colorMode(HSB);
    noStroke();
    ellipseMode(RADIUS);
    rectMode(CENTER);
  }
  
  float smooth(float[] smoothing, int length, float value) {
    float sum = 0.0;
    for (int iX = 0; iX < length; iX++) {
      sum += smoothing[iX];
    }
    sum += value;
    value = sum / (float)(length + 1);
    
    smoothing = append(smoothing, value);
    return value;
  }
  
  void update() {
    if (freq) {
      update_freq();
    } else {
      update_amp();
    }
  }
  
  void update_amp() {
    float value = input.mix.get(0);
    value = smooth(smoothing_amp, smoothing, value);
    
    int hue = 192 + (-(int)value * 192);
    int val = 255;
    if (value < 0.1) { val = 0; }
    push_queue(color(hue, 255, val));
  }
  
  void update_freq() {
    float amp = abs(input.mix.get(0)*10);
    float freq = get_freq() * 7;
    //print("Amp", amp, "Freq", freq);
    amp = smooth(smoothing_amp, smoothing, amp);
    freq = smooth(smoothing_freq, smoothing, freq);
    //print("  SAmp", amp, "SFreq", freq);
    int hue = (int)(127 * freq + 127) % 255;
    int val = (int)map(amp, 0.0, 1.0, 0.0, 255.0);
    if (val < 20) { val = 0; }
    println("   H", hue, "V", val);
    push_queue(color(hue, 255, val));
  }
  
  void push_queue(color c) {
    for (int iX = (size - 1); iX > 0; iX--) {
      viz[iX] = viz[iX-1];
    }
    viz[0] = c;
  }
  
  float get_freq() {
    float max_delta = 0.0;
    int max_value = 0;
    int max_index = 0;
    float freq = 0.0;
    
    fft.forward(input.mix);
    for(int i = 0; i < fft.specSize(); i++)
    {
      float value = fft.getBand(i) * 5;
      float delta = value / max[i];
      
      // decay max
      max[i] = (int)(max[i] * 0.993);
      
      // track max
      if (value > max[i]) {
        max[i] = (int)value;
      }
      
      // find max amplitude
      if (value > max_value) {
        max_value = (int)value;
      }
      
      // track the frequency that changed the most
      if (delta > max_delta) {
        max_delta = delta;
        max_index = i;
      }
    }
    //println("Max index", max_index);
    //println("Max value", max_value);
    freq = (float)max_index / (fft.specSize() - 1);
    freq = min(1.0, freq);
    
    return freq;
  }
  
  void draw() {
    int speedFactor = 3;
    int radius = width/(2*speedFactor);
    int x = width/2;
    int y = height/2;
    
    println(frameRate);
    boolean drawEllipse = true;
    int rad = (int)(radius * 2);
    if (drawEllipse) { rad = (int)(radius * 1.5); }
    for (int iR = rad; iR > 0; --iR) {
       fill(viz[iR % size]);
       int w = iR*speedFactor;
       int h = iR*speedFactor;
       if (drawEllipse) {
         ellipse(x, y, w, h);
       } else {
         rect(x, y, w, h);
       }
    }
  }
}