import java.awt.Color;

ControlP5 cp5;
Slider gain;
Slider cutoff;
Slider offset;
Slider spread;
Slider speed;
CheckBox shape;

class ControlApplet extends PApplet {
  PApplet parent;
  int  width = 400, height = 280;
  ControlApplet(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    // init window
    PSurface surface = this.initSurface();    
    surface.setSize(width, height);
    surface.setVisible(true);
    surface.placeWindow(new int[]{0, 0}, new int[]{0, 0});    
    surface.startThread();    
  }
  void setup() {
    background(0);
    PFont pfont = createFont("Arial",10,true); // use true/false for smooth/no-smooth
    ControlFont font = new ControlFont(pfont,20);
    
    cp5 = new ControlP5(this);
    gain = cp5.addSlider("gain")
       .setPosition(20,20)
       .setRange(0,250)
       .setFont(font)
       .setSize(200, 40)
       .setValue(10)
       ;
    cutoff = cp5.addSlider("cutoff")
       .setPosition(20,60)
       .setRange(0,250)
       .setFont(font)
       .setSize(200, 40)
       .setValue(20)
       ;
    offset = cp5.addSlider("offset")
       .setPosition(20,100)
       .setRange(0,255)
       .setFont(font)
       .setSize(200, 40)
       .setValue(127)
       ;
    spread = cp5.addSlider("color spread")
       .setPosition(20,140)
       .setRange(0,64)
       .setFont(font)
       .setSize(200, 40)
       .setValue(5)
       ;
    speed = cp5.addSlider("speed")
       .setPosition(20,180)
       .setRange(0,10)
       .setFont(font)
       .setSize(200, 40)
       .setValue(3)
       ;
    shape = cp5.addCheckBox("Shapes")
      .setPosition(20, 220)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(40, 40)
      .setItemsPerRow(1)
      .setSpacingColumn(30)
      .setSpacingRow(20)
      .addItem("Ellipse", 0)
      ;
  }
  void draw() {
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(gain)) {
      _gain = gain.getValue();
    }
    if (theEvent.isFrom(cutoff)) {
      _cutoff = cutoff.getValue();
    }
    if (theEvent.isFrom(offset)) {
      _offset = offset.getValue();
    }
    if (theEvent.isFrom(spread)) {
      _spread = spread.getValue();
    }
    if (theEvent.isFrom(speed)) {
      _speed = speed.getValue();
    }
    if (theEvent.isFrom(shape)) {
      _drawEllipse = parseBoolean((int)shape.getArrayValue()[0]);
    }
  }
}
