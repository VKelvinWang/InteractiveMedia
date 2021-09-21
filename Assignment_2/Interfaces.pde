//Everything created should be an object.
interface Object {
  void update();
  void display();
  void blit(); //Combines update and display
}

interface KeyboardBindable {
  void keyInputAction();
}
