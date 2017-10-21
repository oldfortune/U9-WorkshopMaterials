
import processing.serial.*; //import the Serial library

int end = 10;    // the number 10 is ASCII for linefeed (end of serial.println), later we will look for this to break up individual messages
String serial;   // declare a new string called 'serial' . A string is a sequence of characters (data type know as "char")
Serial port;  // The serial port, this is a new instance of the Serial class (an Object)

int xPos = 0;
int yPos = 0;
float angle = 0;
float vel = 0.005;
int radius = 600;

int counter = 0;

void setup() {
  
  port = new Serial(this, Serial.list()[2], 9600); // initializing the object by assigning a port and baud rate (must match that of Arduino)
  port.clear();  // function from serial library that throws out the first reading, in case we started reading in the middle of a string from Arduino
  serial = port.readStringUntil(end); // function that reads the string from serial port until a println and then assigns string to our string variable (called 'serial')
  serial = null; // initially, the string will be null (empty)
  
  size(displayWidth,displayHeight);
  background(255);
}

void draw() {

  while (port.available() > 0) { //as long as there is data coming from serial port, read it and store it 
    serial = port.readStringUntil(end);
    
  }
  
  if (serial != null) {  //if the string is not empty, print the following
    
      String[] a = split(serial, ',');  //a new array (called 'a') that stores values into separate cells (separated by commas specified in your Arduino program)
      
      //println(a.length);
      
      
      //println(a[0]); //print Value1 (in cell 1 of Array - remember that arrays are zero-indexed)
      //println(a[1]); //print Value2 value
      
      int rad = int(map(int(a[0]),0,255,0,600));
      int Shade = int(map(int(a[0]),0,255,0,255));
  
      
      circle(rad, Shade);
      //scan(rad, Shade);
      
      
   }
  
    
  
}


void circle(int sensorInput, int shade) {
  
  strokeWeight(2);
  stroke(shade,200);
  radius = sensorInput;
  
  xPos = int(displayWidth/2 + radius*sin(angle));
  yPos = int(displayHeight/2 + radius*cos(angle));
  
  angle += vel;
  
  if (angle >= 2*PI) {
     background(255); 
     angle = 0;
  }
  
  //radius = int(random(200,600));
  
  line(displayWidth/2,displayHeight/2,xPos,yPos);
  
}

void scan(int sensorInput, int shade) {
  
  strokeWeight(2);
  stroke(shade,200);
  xPos += 1;
  
  //radius = int(random(200,600));
  
  line(xPos,displayHeight,xPos,0);
  
  if (xPos >= displayWidth) {
     background(255); 
     xPos = 0;
  }
  
}