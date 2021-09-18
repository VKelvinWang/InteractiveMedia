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
  
  boolean mouseOver() { //Overload for the mouseOver function
    return mouseOver(0, 0);
  }
}
