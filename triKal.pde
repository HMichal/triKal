/**********************************
 **** Michal Huller
 **** TriKal - Triangles Kaleidoscop
 **** On 2 Dec 2014
 **********************************/
import javax.swing.*; 
import processing.pdf.*;
import java.util.Calendar;
PImage pic;
boolean recordPDF = false;
boolean showDots = true;
boolean showStroke = true;
boolean showFill = true;
boolean makeShort = true;
boolean showTri = false;
boolean makeMovie = false;
PImage myPallete;
PImage scrShot;

PVector rectSize;
PVector lastPos;
String ogiName = "";
JFileChooser fc; 

color bg = 0; //#98c5f7;
int fac = 16;
int numof = 50;
int maxnum = 0;
float turn = 0.03;
int jump = 0;
float waveFac = PI;
int oriPointx = 0;
int oriPointy = 0;
float disp = 0;
int dotSize = 3;
int till=1;

String readyImage = "fl_201482_127_2933";
boolean nekudot = false;
TriangleObj[] tri;
color []bottom2top = new color[4];
float []wBot2top = new float[4];
int transColor;

/////// setup ///////////////
void setup() { 
  size(1280, 720); //size(1200, 1200);
  rectSize = new PVector(width/2, height/2);
  lastPos = new PVector(width/2, height/2);
  smooth();
  fc = new JFileChooser();
  if (openFileAndGetImage() == 0)
    exit();
  background(bg);
  frameRate(10);
  initit();

  noLoop();
}

/////////////////////////////// DRAW //////////////////////////
void draw() {
  background(bg);
  for (int i=0; i < maxnum; i++) {
    if (tri[i] != null)
      tri[i].draw();
  }
  if (makeMovie) {
    String fname="forMov/mov_" + year() + month() + day() + "_######" + ".jpg";
    saveFrame(fname);
  }
}
public void initit() {
  initit(0);
}

public void initit(int byMouse) {
  if (byMouse == 1) {
    lastPos.x = mouseX; //map(mouseX,0,width, 0, original.width);
    lastPos.y = mouseY; //map(mouseY,0,height, 0, original.height);
  } else {
    background(bg);
    lastPos.x = width/2;
    lastPos.y = height/2;
  }
  maxnum = numof * 3;
  tri = new TriangleObj[maxnum];
  float limtri = width;
  float mini = 0;
  float limang = TWO_PI/fac+1;
  int i = 0;
  bottom2top = new color[4];
  wBot2top = new float[4];
  till = 1;
  if (!showFill) till = bottom2top.length;
  
  for (int k=numof-1; k >= 0; k--) {
    if (makeShort) {
      limtri = rectSize.x*float((k+1))/float(numof);
      if (showTri)
        mini = random(limtri/2, limtri);
      else 
        mini = random(limtri);
      if (float((k+1))/float(numof) < 1/5) mini = 0;     
      limang = random(PI/2);  
    }
    else {
      limtri = random((float(k+1)/float(numof))*width);
      mini = random(limtri);
      limang = random(PI/5); 
    }
    // make a triangle
    PVector p1 = new PVector(limtri, random(-limang, limang));
    PVector p2 = new PVector(p1.x + random(mini, limtri), p1.y + random(-limang, limang));
    PVector p3 = new PVector((p1.x + p2.x)/2, p1.y - random(-limang, limang));
    tri[i] = new TriangleObj(p1.x, p1.y, 
      p2.x, p2.y, 
      p3.x, p3.y, 
      myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
      myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
      fac);

    //and a double one
    if (float((k+1))/float(numof) < 0.3) {
      i++;
      p2 = new PVector(p1.x + random(mini, limtri), p1.y + random(-limang, limang));
      //p3 = new PVector(p1.x - random(mini, limtri), p1.y - random(-limang, limang));
      p3 = new PVector((p1.x + p2.x)/2, p1.y - random(-limang, limang));
      tri[i] = new TriangleObj(p1.x, p1.y, 
        p2.x, p2.y, 
        p3.x, p3.y, 
        myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
        myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
        fac);
      i++;
      p1 = new PVector(0,0);
      p2 = new PVector(p1.x + random(mini, limtri), p1.y + random(-limang, limang));
      //p3 = new PVector(p1.x - random(mini, limtri), p1.y - random(-limang, limang));
      p3 = new PVector((p1.x + p2.x)/2, p1.y - random(-limang, limang));
      tri[i] = new TriangleObj(p1.x, p1.y, 
        p2.x, p2.y, 
        p3.x, p3.y, 
        myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
        myPallete.get(int(random(0, myPallete.width)), int(random(0, myPallete.height))), 
        fac);
    }
    i++;
  }
}

void mouseReleased() {
  //initit(1);
  background(bg);
  redraw();
}

void mousePressed() {
  for (int i = 0; i < numof/10; i++) {
    PVector cur = new PVector(mouseX-width/2, mouseY-height/2);
    if (i % 3 == 0)
      tri[int(random(numof))].setP1(cur.mag(), cur.heading());
    if (i % 3 == 1)
      tri[int(random(numof))].setP2(cur.mag(), cur.heading());
    if (i % 3 == 2)
      tri[int(random(numof))].setP3(cur.mag(), cur.heading());
  }
}

void keyPressed() {
  if (key == 'n' || key == 'N') {
    initit();
    redraw();
  }

  if (key == 'o' || key =='O') {
    if (openFileAndGetImage() == 0)
      exit();
    background(bg);
    initit();
    redraw();
  }

  if (key == ' ') {
    background(bg);
    initit();
    redraw();
  }

  if (key == 's' || key == 'S' || key == 'p' || key == 'P') {
    int numR = int(random(5000));
    String fname="snapshot/fl_" + year() + month() + day() + "_" + frameCount +"_" + numR + ".png";
    scrShot=get(0, 0, width, height);
    scrShot.save(fname);
  }
  if (key =='r' || key =='R') {
    if (recordPDF == false) {
      beginRecord(PDF, "snapshot/" + timestamp()+".pdf");
      println("recording started");
      recordPDF = true;
      background(bg);
      redraw();
    }
  } 
  if (key == 'e' || key =='E') {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
    }
  }
  if (key =='1') {
    fac -= 2;
    if (fac < 6) fac = 6;
    background(bg);
    for (int i=0; i < numof; i++) tri[i].setSlices(fac);
    redraw();
  }
  if (key =='2') {
    fac += 2;
    if (fac > 28) fac = 28;
    background(bg);
    for (int i=0; i < numof; i++) tri[i].setSlices(fac);
    redraw();
  }
  if (key =='3') {
    numof -= 10;
    if (numof < 10) numof = 10;
    background(bg);
    initit();
    redraw();
  }
  if (key =='4') {
    numof += 10;
    if (numof > 200) numof = 200;
    background(bg);
    initit();
    redraw();
  }
  if (key == 'w' || key == 'W') {
    bg = 255-bg;
    background(bg);
    redraw();
  }
  if (key == 'd' || key == 'D') {
    showDots = !showDots;
    redraw();
  }
  if (key == 'l' || key == 'L') {
    showStroke = !showStroke;
    redraw();
  }
  if (key == 'f' || key == 'F') {
    showFill = !showFill;
    redraw();
  }
  if (key == 'm' || key == 'M') {
    makeShort = !makeShort;
    initit();
    redraw();
  }

  if (key == 'x' || key == 'X') {
    makeMovie = !makeMovie;
    background(bg);
    redraw();
  }

  if (key == 't' || key == 'T') {
    showTri = !showTri;
    background(bg);
    redraw();
  }
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


int openFileAndGetImage() {

  int returnVal = fc.showOpenDialog(null); 

  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    // see if it's an image 
    // (better to write a function and check for all supported extensions) 
    if (file.getName().endsWith("jpg") || file.getName().endsWith("png") 
      || file.getName().endsWith("gif") || file.getName().endsWith("jpeg") ||
      file.getName().endsWith("JPG")) { 
      // load the image using the given file path
      ogiName = file.getPath();
      myPallete = loadImage(ogiName); 
      if (myPallete != null) {
        return 1;
      } else return 0;
    }
  } 
  return 0;
}
