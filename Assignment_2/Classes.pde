//Because processing has no idea when the "color" class is used as part of a generic.
//Thus a new class had to be made.
public class Colour {
  private color colour;
  Colour(color newColour) {
    colour = newColour;
  }
}

//There should only be one.
public class Building extends CanvasObject {
  private int max; //Maximum number of windows in the year.
  int curr; //Current value given.
  private int gridSize; //Size of the grid of windows
  private HashMap<String, Colour> palette; //The colour palette of the building.
  
  Building(float x, float y, float w, float h) {
    super(x, y, w, h);
    updateMax(1);
    
    //Set colours
    palette = DeepCopyColours();
    palette.put("Stroke", new Colour(color(0, 0, 0, 255)));
    palette.put("No stroke", new Colour(color(0, 0, 0, 0)));
    palette.put("Busy", new Colour(color(250, 168, 26))); //Discord orange
    palette.put("Window", new Colour(color(24, 25, 28))); //Discord dark grey
    palette.put("Body", new Colour(color(132, 115, 90))); //Ugliest Tower In Sydney colour
  }
  
  void updateMax(int newMax) {
    max = newMax;
    curr = max(0, min(curr, max)); //Clamps value between 0 and new max.
    gridSize = GetClosestSquaredNumber(max);
  }
  
  //Overrides Object
  @Override void update() {
  }
  
  //Overrides Object
  @Override void display() {
    fill(palette.get("Body").colour);
    rectMode(CORNER);
    rect(x, y, w, h);
    
    int busyWindows = curr;
    float padX = w * 0.1;
    float padY = h * 0.1;
    float windowW = w * 0.8 / gridSize; //Width of each window
    float windowH = h * 0.8 / gridSize; //Height of of window
    for (int i = 0; i < gridSize * gridSize; i++) {
      fill(palette.get(busyWindows-- <= 0 ? "Window" : "Busy").colour);
      float windowX = x + padX + windowW * (i % gridSize);
      float windowY = y + padY + windowH * (i / gridSize);
      rect(windowX, windowY, windowW * 0.9, windowH * 0.9);
    }
  }
}

//There should only be one.
//This class is a circle spinning in a circle.
public class LoadingScreen extends CanvasObject {
  //How far does this circle move:
  float hDist; //Horizontally?
  float vDist; //Vertically?
  
  float tick; //How long has the loading been running?
  
  LoadingScreen(float x, float y, float size, float hDist, float vDist) {
    super(x, y, size, size);
    this.hDist = hDist;
    this.vDist = vDist;
    tick = 0;
  }
  
  //Overrides Object
  @Override void update() {
    tick += deltaTime;
  }
  
  //Overrides Object
  @Override void display() {
    fill(colours.get("White").colour);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Loading" + StringMultiplier(".", (int)tick % 3 + 1), x, y + vDist * 1.5);
    
    float revolutions = 1; //The 1 is the number of rotations per second.
    for (int i = 0; i < 6; i++) {
      fill(255, 255, 255, 360 - 60 * i);
      float rot = tick * 360 * revolutions - 60 * i;
      ellipse(x + sin(radians(rot)) * hDist, y + cos(radians(rot)) * -vDist, w, h);
    }
  }
}
