import processing.serial.*;

// DECLARE A SPOUT OBJECT HERE
Spout spout;

PImage img;
Table pixMap;
Serial conn;

String spoutName = "led";
String filename = "curtain2x.tsv";
String comPort = "COM10";
int pixelCount = 300;

void setup() {
  
  size(640, 480, P2D);
  surface.setResizable(false); // to adapt to sender frame size
  background(0);

  // Create an image to receive the data.
  // RGB, ARGB, image size or frame size do not matter
  // because the received image and the frame adapt if
  // the incomimg texture size changes
  img = createImage(width, height, RGB);
  
  // CREATE A NEW SPOUT OBJECT HERE
  spout = new Spout();
  
  // INITIALIZE A SPOUT RECEIVER HERE
  // Give it the name of the sender you want to connect to
  // Otherwise it will connect to the active sender
  // img will be updated to the sender size
  spout.initReceiver(spoutName, img);
 
  // Alternative for memoryshare only 
  // spout.initReceiver();
  frameRate(60);
  
  // connect to serial
  conn = new Serial(this, comPort, 115200);
  
  // configure LEDs
  pixMap = loadTable(filename, "tsv");
} 

byte[] pixdata = new byte[pixelCount*3];
void draw() {
  
  // RECEIVE A SHARED TEXTURE HERE
  img = spout.receiveTexture(img);
  
  // Draw the result
  image(img, 0, 0, width, height);
  println(frameRate);
  
  int iX = 0;
  for (TableRow row : pixMap.rows()) {
    int x = row.getInt(0);
    int y = row.getInt(1);
    //println(x);
    //println(y);
    
    color c = img.pixels[y*width+x];
    pixdata[iX++] = byte(green(c));
    pixdata[iX++] = byte(red(c));
    pixdata[iX++] = byte(blue(c));
  }
  conn.write(pixdata);
}


// RH click to select a sender
void mousePressed() {
  
  // SELECT A SPOUT SENDER HERE
  if (mouseButton == RIGHT) {
    // Bring up a dialog to select a sender from
    // the list of all senders running.
    JSpout.SenderDialog();
  }
  
}

// over-ride exit to release sharing
void exit() {
  // CLOSE THE SPOUT RECEIVER HERE
  spout.closeReceiver();
  super.exit(); // necessary
} 