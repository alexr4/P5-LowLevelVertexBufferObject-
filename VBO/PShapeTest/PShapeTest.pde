import fpstracker.core.*;
import peasy.*;

PerfTracker perftracker;

ArrayList<Float> points = new ArrayList<Float>();
PGraphics buffer;

VBOInterleaved vbo;

void settings() {
  size(512 * 2, 424 * 2, P3D);
}

void setup() {
  //size(512, 424, P3D);
  smooth(8);
  frameRate(300);
  buffer = createGraphics(width, height, P3D);
  for (int i=0; i<512*424; i++) {
    int x = i % 512;
    int y = (i - x) / 512;
    points.add(x + 512 * -0.5);
    points.add(y + 424 * -0.5);
    points.add(0.0);
    points.add(1.0);
    
    points.add(1.0);
    points.add(1.0);
    points.add(1.0);
    points.add(1.0);
    
    points.add(1.0);
    points.add(1.0);
    points.add(1.0);
    points.add(1.0);
  }
  vbo = new VBOInterleaved(g, points);

  perftracker = new PerfTracker(this, 100);
}

void draw() {
  vboUpdateGeo();

  buffer.beginDraw();
  buffer.background(0, 0, 0);
  buffer.lights();
  buffer.translate(width/2, height/2, 300);
  buffer.rotateX(frameCount * 0.01);
  buffer.rotateY(frameCount * 0.015);
  vbo.display();
  buffer.endDraw();

  image(buffer, 0, 0);
  perftracker.displayOnTopBar();
  perftracker.display(0, 0);
}

void vboUpdateGeo() {
  for (int i=0; i<512*424; i++) {
    int index = i * 12 + 0;
    
    int x = i % 512;
    int y = (i - x) / 512;
    float z = noise(x / 512.0, y / 424.0, frameCount * 0.01) * 150;
    
    points.set(index + 0, (float)x + 512 * -0.5);
    points.set(index + 1, (float)y + 424 * -0.5);
    points.set(index + 2, z);
  }

  vbo.setGeometry(points);
}
