ArrayList<PVector> cylinderPositions = new ArrayList(); 
ArrayList<PShape> cylinders = new ArrayList();
float cylinderBaseSize = 20;
float cylinderHeight = 50;
int cylinderResolution = 20;
PShape openCylinder;


PShape makeCylinder() {
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);

  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();
  return openCylinder;
}

void displayCylinders() {
  pushMatrix(); 
  moveToCenterOfBoardPlane();
  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, boxHeight/2, cylinderPositions.get(i).y); 
    rotateX(PI/2);
    shape(cylinders.get(i)); 
    popMatrix();
  }
  popMatrix();
}


void displaySelector() {
  
  ortho();
  
  pushMatrix();
  PShape cursorCylinder = makeCylinder();
  translate(mouseX,mouseY,boxHeight/2);
  shape(cursorCylinder);
  popMatrix();
  
  pushMatrix();
  moveToCenterOfScreen();
  fill(255, 0, 0);
  box(boxWidth, boxDepth, boxHeight);

  
  pushMatrix();
  translate(spherePositionFromCenter.x, spherePositionFromCenter.z, /*spherePositionFromCenter.y+*/(boxHeight/2+sphereSize));
  fill(0, 0, 255);
  sphere(sphereSize);
  popMatrix();
  

  for (int i=0; i<cylinders.size(); i++) {
    pushMatrix(); 
    translate(cylinderPositions.get(i).x, cylinderPositions.get(i).y, boxHeight/2); 
    shape(cylinders.get(i)); 
    popMatrix();
  }

  popMatrix();
}