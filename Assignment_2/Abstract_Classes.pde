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
