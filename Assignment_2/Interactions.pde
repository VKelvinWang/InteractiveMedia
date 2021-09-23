void keyPressed() {
  //Ensures that the held button does not execute more than once.
  if (keyManager.containsKey(key) && keyManager.get(key)) {
    return;
  }
  
  //For all objects that have been binded
  for (KeyboardBindable object : keyboardBindedObjects) {
    object.keyInputAction();  
  }
  
  keyManager.put(key, true);
}

void keyReleased() {
  keyManager.put(key, false); //No check is needed, guarenteed to be in the hashmap.
}

void mousePressed() {
  if (mouseButton == LEFT) {
    leftClick = true;
    leftClickHold = true;
    sound();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    leftClickHold = false;
  }
}
