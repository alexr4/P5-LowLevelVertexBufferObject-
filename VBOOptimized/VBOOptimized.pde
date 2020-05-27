/**
 * This sketch demonstrate how to create and use a simple Low-Level interleaved VBO
 * with only few data such as (X, Y, Z, W, R, G, B, A)
 */

import fpstracker.core.*;

PerfTracker perf;

int gw, gh;
VBOInterleaved vbo;
PGraphics mainContext;

int w = 1280;
int h = 720;
float s = 1.0;

void settings() {
  size(int(w * s), int (h*s), P3D);
}

void setup() {
  frameRate(300);
  perf = new PerfTracker(this, 100);
  mainContext = createGraphics(width, height, P3D);

  float scale = 0.5;
  gw = int(1920 * scale);
  gh = int(1080 * scale);
  int nbrVertex = gw * gh;
  vbo = new VBOInterleaved(this);
  vbo.initVBO(g, nbrVertex);
  updateGeometry(vbo);
  vbo.updateVBO();
}

void draw() {
  //updateGeometry(vbo);
  //updateColor(vbo);
  //vbo.updateVBO();

  //time sequence
  float maxTimeX = 4000;
  float maxTimeY = 5000;
  float timeX = (millis() % maxTimeX) / maxTimeX;
  float timeY = (millis() % maxTimeY) / maxTimeY;

  mainContext.beginDraw();
  mainContext.background(0);
  mainContext.translate(mainContext.width/2, mainContext.height/2, 0.0);
  mainContext.rotateX(timeX * TWO_PI);
  mainContext.rotateY(timeY * TWO_PI);

  //here goes the VBO
  vbo.draw(g);

  mainContext.endDraw();

  image(mainContext, 0, 0);
  perf.display(0, 0);
  perf.displayOnTopBar(this.toString() + " - Number of Vertex : "+(gw * gh));
}

@Override
  public String toString() {
  return "VBO Optimized";
}

public void updateGeometry(VBOInterleaved vbo) {
  for (int i = 0; i<gw*gh; i++) {
    float x = i % gw;
    float y = (i - x) / gw;
    float z = 0.0;
    x += (gw * -0.5);
    y += (gh * -0.5);

    vbo.setVertex(i, x, y, z);
  }
}

public void updateColor(VBOInterleaved vbo) {
  for (int i = 0; i<gw*gh; i++) {
    float x = i % gw;
    float y = (i - x) / gw;
    float r = x / (float)gw;
    float g = y / (float)gh;
    float b = 1.0;

    vbo.setColor(i, r, g, b, 1.0);
  }
}
