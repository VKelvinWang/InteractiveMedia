//Every state in the program.
void doState() {
  switch(state) {
    case "Loading link":
      thread("loadLink"); //No break here, go to next case.
      state = "Show loading screen";
    case "Show loading screen":
      loadingScreen.blit();
      return;
    default: //Show data normally
      updateObjects();
      return;
  }
}

//Threaded function to prevent freezing.
void loadLink() {
  data = loadTable(links.get(currLink), "csv");
  
  int[] rawData = new int[data.getRowCount()];
  for (int i = 0; i < rawData.length; i++) {
    rawData[i] = data.getInt(i, 1);
  }
  building.updateMax(max(rawData));
  building.curr = rawData[0];
  
  state = "Show data";
}

void updateObjects() {
  //For every object in the scene, blit it.
  for (Object object : objects) {
    object.blit();
  }
}
