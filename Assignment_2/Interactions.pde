void keyPressed() {
  if (keyManager.containsKey(key) && keyManager.get(key)) { //Ensures that the held button does not execute more than once.
    return;
  }
  
  for (KeyboardBindable object : keyboardBindedObjects) { //For all objects that have been binded
    object.keyInputAction();  
  }
  
  keyManager.put(key, true);
}

void keyReleased() {
  keyManager.put(key, false);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    leftClick = true;
    leftClickHold = true;
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    leftClickHold = false;
  }
}
