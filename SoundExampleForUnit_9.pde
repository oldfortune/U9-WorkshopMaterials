
import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
Serial port;  // The serial port, this is a new instance of the Serial class (an Object)

float val = 0;

int w = 2;
int h = 2;

int numParticles = 10;
float e = 0;

int pitch[] = {440,600,880,1200};

Minim       minim;
AudioOutput out;
Particle      [][]node;

void setup() {
  
  port = new Serial(this, Serial.list()[2], 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();  // function from serial library that throws out the first reading, in case we started reading in the middle of a string from Arduino
  serial = port.readStringUntil(end); // function that reads the string from serial port until a println and then assigns string to our string variable (called 'serial')
  serial = null; // initially, the string will be null (empty)
  
  
  size(displayWidth,displayHeight);
  background(0);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  node = new Particle[w][h];
  int count = 0;
  
  for (int i = 0; i<w; i++) {
    for (int j = 0; j<h; j++) {
     node[i][j] = new Particle(100+i*40,j*40+100,pitch[count]);
     count++;
    }
  }
}

void draw() {
  background(255);
  
  while (port.available() > 0) { //as long as there is data coming from serial port, read it and store it 
    serial = port.readStringUntil(end);
  }
  
  if (serial != null) {  //if the string is not empty, print the following
        
    val = float(serial);
    println(val);
    
  }
  
  
  int freq = int(map(val,0,1023,440,880));
  
  
  for (int i = 0; i<w; i++) {
    for (int j = 0; j<h; j++) {
     node[i][j].update(freq);
    }
  }
  
  
}

class Particle { 
  float xpos, ypos,freq; 
  Oscil wave;
  
  Particle (float x, float y,float f) { 
 
    xpos = x;
    ypos = y;
    freq = f;
    wave = new Oscil( f, 0.01, Waves.TRIANGLE);
    // patch the Oscil to the output
    wave.patch( out );

  }
  
  void update (int frequency) {
    float vol = 0.1;
    wave.setAmplitude(vol);
    wave.setFrequency(frequency);
    //fill(0);
    //ellipse(xpos,ypos,10,10);
    
  }
} 