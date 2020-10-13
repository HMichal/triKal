class TriangleObj {
  // points have two values: Magnitude, Direction
  PVector p1;
  PVector p2;
  PVector p3;
  color linec;
  color fillc;
  float slices;
  float stWeight;

  TriangleObj(float p1m, float p1d, 
    float p2m, float p2d, float p3m, float p3d, 
    color l, color f, float s) {
    p1 = new PVector (p1m, p1d);
    p2 = new PVector (p2m, p2d);
    p3 = new PVector (p3m, p3d); 
    linec = l;
    fillc = f;
    slices = s;
    stWeight = 0.3;
  }

  void draw() {
    int peradius = fac;
    float sl = slices;

    if ((p1.mag()+p2.mag()+p3.mag())/3 > height/2) {
      peradius*=2;
      sl = slices*2;
    }


    PVector point1 = PVector.fromAngle(p1.y);
    point1.setMag(p1.x);
    PVector point2 = PVector.fromAngle(p2.y);
    point2.setMag(p2.x);
    PVector point3 = PVector.fromAngle(p3.y);
    point3.setMag(p3.x);

    PVector mir1 = PVector.fromAngle(TWO_PI/sl -p1.y);
    mir1.setMag(p1.x);
    PVector mir2 = PVector.fromAngle(TWO_PI/sl -p2.y);
    mir2.setMag(p2.x);
    PVector mir3 = PVector.fromAngle(TWO_PI/sl -p3.y);
    mir3.setMag(p3.x);

    fill(fillc, 120);
    //noFill();
    if (showStroke) {
      stWeight = 2*abs(min(p1.x, p2.x, p2.x)/max(p1.x, p2.x, p2.x));
      SetThreadValues(fillc, stWeight);
      strokeWeight(stWeight);
      stroke(fillc, 150); //linec
    } else {
      noStroke();
    }

    if (showFill) {
      fill(fillc, 120);
    } else {
      stWeight = 4*abs(min(p1.x, p2.x, p2.x)/max(p1.x, p2.x, p2.x));
      SetThreadValues(fillc, stWeight);
      stroke(fillc, 220); 
      strokeWeight(stWeight);
      noFill();
    }
    
    pushMatrix();
    translate(lastPos.x, lastPos.y);

    for (int i=0; i < peradius; i++) {
      if (i % 2 == 1) { 
        if (showTri)
          triangle(mir1.x, mir1.y, mir2.x, mir2.y, mir3.x, mir3.y);
        else {      
          for (int ic=0; ic < till; ic++) {
            stroke(bottom2top[ic], 220);
            strokeWeight(wBot2top[ic]);
            beginShape();
            curveVertex(mir3.x, mir3.y);
            curveVertex(mir1.x, mir1.y);
            curveVertex(mir2.x, mir2.y);
            curveVertex(mir3.x, mir3.y);
            curveVertex(mir1.x, mir1.y); 
            curveVertex(mir2.x, mir2.y);
            endShape();


            if (showDots) {
              ellipse(mir1.x, mir1.y, 8, 8);
              ellipse(mir2.x, mir2.y, 8, 8);
              ellipse(mir3.x, mir3.y, 8, 8);
            }
          }
        }
      } else {
        if (showTri)
          triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
        else {
          //bezier(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, point1.x, point1.y);
          for (int ic=0; ic < till; ic++) {
            stroke(bottom2top[ic], 220);
            strokeWeight(wBot2top[ic]);
            beginShape();
            curveVertex(point3.x, point3.y);
            curveVertex(point1.x, point1.y);
            curveVertex(point2.x, point2.y);
            curveVertex(point3.x, point3.y);
            curveVertex(point1.x, point1.y);
            curveVertex(point2.x, point2.y);
            endShape();
            if (showDots) {
              ellipse(point1.x, point1.y, 8, 8);
              ellipse(point2.x, point2.y, 8, 8);
              ellipse(point3.x, point3.y, 8, 8);
            }
          }
        }
      }
      rotate(TWO_PI/sl);
    }  
    popMatrix();
  }
  void setSlices(float s) {
    slices = s;
  }

  void setP1(float mag, float dir) {
    p1.setMag(mag/2);
    p2.setMag(random(mag/2, mag*2));
    p3.setMag(random(mag/3, mag*3));
    p1.rotate(map(dir, 0, TWO_PI, 0, TWO_PI/slices +0.5));
    p2.rotate(dir-PI/3);
    p3.rotate(dir+PI/3);
    //p1.x = mag;
    //p1.y = map(dir, 0, TWO_PI, 0, TWO_PI/slices +0.5); 
    ;
  }
  void setP2(float mag, float dir) {
    p2.setMag(mag);
    p3.setMag(random(mag/2, mag*2));
    p2.setMag(random(mag/3, mag*3));
    p2.rotate(map(dir, 0, TWO_PI, 0, TWO_PI/slices +0.5));
    p1.rotate(dir-PI/3);
    p3.rotate(dir+PI/3);
  }
  void setP3(float mag, float dir) {
    p3.setMag(mag);
    p1.setMag(random(mag/2, mag*2));
    p2.setMag(random(mag/3, mag*3));
    p3.rotate(map(dir, 0, TWO_PI, 0, TWO_PI/slices +0.5));
    p2.rotate(dir-PI/3);
    p1.rotate(dir+PI/3);
  }
}
void SetThreadValues(color picolor, float strokeW) {
  for (int ic=0; ic < bottom2top.length; ic++) {
    float cInc = 0.75 + ic*0.1;
    if (!showFill) {
      bottom2top[ic] = color(red(picolor) * cInc, 
        green(picolor) * cInc, 
        blue(picolor) * cInc);
      wBot2top[ic] = strokeW * (1.7 - ic*0.55);
    } else {
      bottom2top[ic] = color(picolor);
      wBot2top[ic] = strokeW;
    }
  }
}
