/*
Every object that is on the screen should have:
  1. A bounding box.
  2. Collision detection.
  3. Position on the screen.
*/
abstract class CanvasObject implements Object {
  float x; //X position
  float y; //Y position
  float w; //Width of object
  float h; //Height of object
  
  CanvasObject(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  @Override void blit() { //Calls both update and display at once.
    update();
    display();
  }
  
  /*
    Is the mouse colliding with the bounding box of object?
      - It naturally goes by corner.
    
    Parameters:
      offsetX - Offsets the collision detection by given float in x axis
      offsetY - Offsets the collision detection by given float in y axis
  */
  boolean mouseOver(float offsetX, float offsetY) {
    boolean left = x + offsetX < mouseX;
    boolean right = x + offsetX + w > mouseX;
    boolean top = y + offsetY < mouseY;
    boolean bottom = y + offsetY + h > mouseY;
    
    return left && right && top && bottom;
  }
  
  //Just an overload for the mouseOver function
  boolean mouseOver() {
    return mouseOver(0, 0);
  }
}

abstract class Interactable extends CanvasObject {
  boolean isHovering;
  
  Interactable(float x, float y, float w, float h) {
    super(x, y, w, h);
    isHovering = false;
  }
  
  @Override void update() {
    isHovering = mouseOver();
    if (isHovering && leftClick) {
      doAction();
    }
  }
  
  void doAction() {}
}

//Kelvin
//Button class for implementation inside the navigation bar
abstract class Button extends Interactable {
  HashMap<String, Colour> palette; //The colour palette of the button.
  
  Button(float x, float y, float w, float h) {
    super(x, y, w, h);
    
    palette = DeepCopyColours();
    palette.put("HoverColour", new Colour(color(0, 255,0)));
  }
}

//Ryan
abstract class Navigator extends CanvasObject {
  String[] labels;
  int index;
  
  NavigatorButton leftButton;
  NavigatorButton rightButton;
  
  Navigator(float x, float y, float w, float h, String[] labels) {
    super(x, y, w, h);
    this.labels = labels;
    index = currLink;
    leftButton = new NavigatorButton(this, x, y, h, h, -1);
    rightButton = new NavigatorButton(this, x + w - h, y, h, h, 1);
  }
  
  //Overrides Object
  @Override void update() {
    leftButton.update();
    rightButton.update();
  }
  
  //Overrides Object
  @Override void display() {
    leftButton.display();
    
    fill(colours.get("Black").colour);
    textAlign(CENTER, CENTER);
    textSize(50);
    text(labels[index], x + w / 2, y + h / 2);
    
    rightButton.display();
  }
  
  void doAction() {}
}
