import processing.serial.*;
import controlP5.*;

ControlP5 cp5;

int myColor = color(0,0,0);
Slider s;
Slider sm;
Slider sv;
RadioButton r;
RadioButton rf; // rippleFreq
//float Size;

Serial port;
String comPort = "COM7"; // Set this to the TEENSY!!

void setup() {
  size(640, 640);
  noStroke();
  background(myColor);
  
  PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont,20);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("Size")
     .setPosition(20,100)
     .setRange(1,150)
     .setFont(font)
     .setSize(200, 40)
     .setValue(15)
     ;
     
  cp5.addSlider("Volume")
     .setPosition(20,580)
     .setRange(0,63)
     .setFont(font)
     .setSize(200, 40)
     .setValue(13)
     ;
   
   cp5.addSlider("Smooth")
      .setPosition(20,160)
     .setRange(0, 63)
     .setFont(font)
     .setSize(200, 40)
     .setValue(1)
     ;
  r = cp5.addRadioButton("button")
         .setPosition(20,20)
         .setSize(80,40)
         .setColorForeground(color(120))
         .setColorActive(color(90,0,90))
         .setColorLabel(color(0))
         .setItemsPerRow(5)
         .setSpacingColumn(100)
         .addItem("Ripple",1)
         .addItem("Fire",2)
         .addItem("Twinkle",3)
         .setArrayValue(new float[] { 1, 0, 0 })
         ;
  styleRadioButton(r, font);
  styleRadioButton(cp5.addRadioButton("rippleFreq")
         .setPosition(20,220)
         .setSize(80,40)
         .setColorForeground(color(120))
         .setColorActive(color(90,0,90))
         .setColorLabel(color(255))
         .setItemsPerRow(5)
         .setSpacingColumn(100)
         .addItem("Amp",0)
         .addItem("Freq",1)
         .setArrayValue(new float[] { 0, 1 })
         , font);
         
  smooth();
  port = new Serial(this, comPort, 115200);
  println("Connected - " + comPort);
}

void styleRadioButton(RadioButton r, ControlFont font) {
    for(Toggle t:r.getItems()) {
       //t.getCaptionLabel().setColorBackground(color(255,80));
       t.getCaptionLabel().getStyle().moveMargin(-7,0,0,-3);
       t.getCaptionLabel().getStyle().movePadding(7,0,0,3);
       t.getCaptionLabel().getStyle().backgroundWidth = 45;
       t.getCaptionLabel().getStyle().backgroundHeight = 13;
       t.getCaptionLabel().setFont(font);
     }
}

void draw() {
  rect(0, 0, width, 80);
  while (port.available() > 0) {
    String inBuffer = port.readString();
    if (inBuffer != null) {
      println(inBuffer);
    }
  } 
}

void Size(float x) {
  sliderEvent(x, "s");
}

void button(int x) {
  try {
    if (port == null) { return; }
    //println("button");
    //println(x);
    port.write(String.valueOf(x) + "\n");
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void rippleFreq(int x) {
  sliderEvent((float)x, "f");
}

void Volume(float x) {
  sliderEvent(x, "v");
}

void Smooth(float x) {
  sliderEvent(x, "m");
}

void sliderEvent(float x, String pre) {
  if (port == null) { return; }
  //println(pre + (int)x);
  port.write(pre + String.valueOf((int)x) + "\n");
}