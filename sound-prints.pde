//This sketch uses  the XlsReader: http://bezier.de/processing/libs/xls/

import de.bezier.data.*;
XlsReader reader;
PImage img;
String url;
float spectralIrregularity;
float pulseClarity;
float soundLevel;
// which row of the xls file to look at 0 is row 1 in Excel
// start at the second row
int row = 1; 
//for checking average hsb values
float avgh = 0;
float avgs = 0;
float avgb = 0;

//added setup and draw to get reader to work and to cycle through the data
void setup() { 
  reader = new XlsReader(this, "data.xls");
  url = "http://farm6.staticflickr.com/5312/5889940064_89316b2643.jpg"
  img = loadImage(url);
  colorMode(HSB, 1);
  size (img.width, img.height);
  //slow down the frame rate 
  frameRate(1);
}

void draw() {
  loadPixels();
  spectralIrregularity = reader.getFloat(row, 1); // row, column of data
  pulseClarity = reader.getFloat(row, 2);
  soundLevel = reader.getFloat(row, 3);

  for (int i = 0; i < img.pixels.length; i++) {
    float h, s, b;

    h = hue(img.pixels[i]);
    h = pow(h, spectralIrregularity);
    avgh += h;

    s = saturation(img.pixels[i]);
    s = pow(s, pulseClarity);
    avgs += s;

    b = brightness(img.pixels[i]);
    b = pow(b, soundLevel);
    avgb += b;

    color c = color(h, s, b);
    pixels[i] = c;
  }
  updatePixels();

  //print out the images average hsb
  avgh /= float(img.pixels.length);
  avgs /= float(img.pixels.length);
  avgb /= float(img.pixels.length);
  println("avgh = " + avgh + ", avgs = " + avgs + ", avgb = " + avgb);

  //save image with row number
  //save( "s_p_" + row + ".png");

  //move on to the next row
  row++; 

  //end after the last row of data
  if ( row > 198 ) {
    noLoop();
  }
}
