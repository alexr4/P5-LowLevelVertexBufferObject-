/**
 * This sketch demonstrate how to create and use a simple Low-Level interleaved VBO
 * with only few data such as (X, Y, Z, W, R, G, B, A)
 */

import fpstracker.core.*;
import peasy.*;

PeasyCam cam;
PerfTracker perf;

int nbrVertex = 6;
VBOInterleaved vbo;
PGraphics mainContext;

int w = 1280;
int h = 720;
float s = 1.0;

PVector[] square = {
  new PVector(-1.0, -1.0, 1.0), 
  new PVector(-1.0, 1.0, 1.0), 
  new PVector( 1.0, 1.0, 1.0), 
  new PVector( 1.0, -1.0, 1.0), 

  new PVector(-1.0, -1.0, -1.0), 
  new PVector(-1.0, 1.0, -1.0), 
  new PVector( 1.0, 1.0, -1.0), 
  new PVector( 1.0, -1.0, -1.0)
};

int[] indices = {
  0, 1, 3, 
  3, 1, 2, 

  3, 2, 7, 
  7, 2, 6, 

  7, 6, 4, 
  4, 6, 5, 

  4, 5, 0, 
  0, 5, 1, 

  4, 0, 7, 
  7, 0, 3, 

  6, 2, 5, 
  5, 2, 1
};

PVector scale = new PVector(25, 100, 25);


void settings() {
  size(int(w * s), int (h*s), P2D);
}

void setup() {
  frameRate(300);
  perf = new PerfTracker(this, 100);
  mainContext = createGraphics(width, height, P3D);

  nbrVertex = indices.length;
  vbo = new VBOInterleaved(this);
  vbo.initVBO(g, nbrVertex);
  updateGeometry(vbo);
  updateColor(vbo);
  vbo.updateVBO();

  cam = new PeasyCam(this, 500);
}

void draw() {
  //updateGeometry(vbo);
  //updateColor(vbo);
  //vbo.updateVBO();

  //time sequence
  float maxTimeX = 10000;
  float maxTimeY = 20000;
  float timeX = (millis() % maxTimeX) / maxTimeX;
  float timeY = (millis() % maxTimeY) / maxTimeY;

  mainContext.beginDraw();
  mainContext.background(0);
  mainContext.rotateX(timeX * TWO_PI);
  mainContext.rotateY(timeY * TWO_PI);
  
  mainContext.stroke(255, 0, 0);
  mainContext.line(0, 0, 0, 150, 0, 0);
  mainContext.stroke(0, 255, 0);
  mainContext.line(0, 0, 0, 0, 150, 0);
  mainContext.stroke(0, 0, 255);
  mainContext.line(0, 0, 0, 0, 0, 150);

  //here goes the VBO
  vbo.draw(g);

  mainContext.endDraw();
  cam.getState().apply(mainContext);

  image(mainContext, 0, 0);
  perf.display(0, 0);
}

@Override
  public String toString() {
  return "VBO Optimized";
}

public void updateGeometry(VBOInterleaved vbo) {
  for (int i = 0; i<nbrVertex; i++) {
    PVector vertex = square[indices[i]].copy();
    vertex.x *= scale.x;
    vertex.y *= scale.y;
    vertex.z *= scale.z;
    vbo.setVertex(i, vertex.x, vertex.y, vertex.z);
  }
}

public void updateColor(VBOInterleaved vbo) {
  for (int i = 0; i<nbrVertex; i++) {
    PVector vertex = square[indices[i]].copy();

    vertex.x  = vertex.x * 0.5 + 0.5; 
    vertex.y  = vertex.y * 0.5 + 0.5; 
    vertex.z  = vertex.z * 0.5 + 0.5; 
    vbo.setColor(i, vertex.x, vertex.y, vertex.z, 1.0);
  }
}
