import beads.*;

Table dataTable;
HashMap<String, Colour> colours; //Universally holds all colours added into it.
ArrayList<String> links; //Holds the links for the entire timeline.

ArrayList<Object> objects; //Holds all objects on the screen.
HashMap<Character, Boolean> keyManager; //Ensures that the button is only pressed once even when holding it.
ArrayList<KeyboardBindable> keyboardBindedObjects; //Holds all objects that has implemented this.

boolean leftClick; //Was there a left click? Lasts one frame, the moment it was clicked.
boolean leftClickHold; //Is the left click being held?

void setup(){
  size(1920, 1080);
  
  //Initialise global variables
  links = new ArrayList<String>();
  colours = new HashMap<String, Colour>();
  
  objects = new ArrayList<Object>();
  keyManager = new HashMap<Character, Boolean>();
  
  //Be sure to use "keyboardBindedObjects.add(this)" in the contructor for whatever class that implemented this.
  keyboardBindedObjects = new ArrayList<KeyboardBindable>();
  
  
  //Add objects into scene.
  ////Add stuff here. Delete this comment.
  
  //Set colours into hashmap
  colours.put("Sky blue", new Colour(color(135, 206, 235))); //Sky blue
  
  //Data: PCLabs Logins
  //Start date: 1/1/2015
  //End date: 31/12/2020
  //Each link is one year.
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2015-01-01T00%3A00&rToDate=2016-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2016-01-01T00%3A00&rToDate=2017-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2017-01-01T00%3A00&rToDate=2018-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2018-01-01T00%3A00&rToDate=2019-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2019-01-01T00%3A00&rToDate=2020-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
}

void draw(){
  background(colours.get("Sky blue").colour);
  
  for (Object object : objects) { //For every object in the scene, add
    object.update();
    object.display();
  }
  
  leftClick = false; //Ensures that left click lasts one frame
}
