import beads.*;
import processing.sound.*;

//Ryan
float deltaTime; //Time since last draw loop (iteration)
long time; //Time since program started
String state; //The current state of the program, is it loading?
LoadingScreen loadingScreen; //The loading screen of the program.

Table data;
HashMap<String, Colour> colours; //Universally holds all colours added into it.
ArrayList<String> links; //Holds the links for the entire timeline.
int currLink; //The current link that is loaded.
int prevLink; //The previous link that was loaded.

ArrayList<Object> objects; //Holds all objects on the screen.
Building building;
HashMap<Character, Boolean> keyManager; //Ensures that the button is only pressed once even when holding it.
ArrayList<KeyboardBindable> keyboardBindedObjects; //Holds all objects that has implemented this.

boolean leftClick; //Was there a left click? Lasts one frame, the moment it was clicked.
boolean leftClickHold; //Is the left click being held?

//Minh
AudioContext ac;//Sound
WavePlayer wp;
Glide freq;
HashMap<String, SamplePlayer> samplePlayers; //All the sample audios loaded

void setup(){
  size(1920, 1080);

  ///////////////////////////////////Ryan
  //Initialise global variables
  deltaTime = 0;
  time = millis();
  state = "Loading link";
  loadingScreen = new LoadingScreen(width / 2, height / 2, 50, 100, 100);

  ////variable data is not initialised here, would freeze the program.
  colours = new HashMap<String, Colour>();
  links = new ArrayList<String>();
  currLink = 0;
  prevLink = -1;

  objects = new ArrayList<Object>();
  keyManager = new HashMap<Character, Boolean>();

  //Be sure to use "keyboardBindedObjects.add(this)" in the contructor for whatever class that implemented this.
  keyboardBindedObjects = new ArrayList<KeyboardBindable>();

  //Set colours into hashmap
  colours.put("Sky blue", new Colour(color(135, 206, 235)));
  colours.put("White", new Colour(color(255, 255, 255)));
  colours.put("Black", new Colour(color(0, 0, 0)));

  //Data: PCLabs Logins
  //Start date: 1/1/2015
  //End date: 31/12/2020
  //Each link is one year.
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2015-01-01T00%3A00&rToDate=2016-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2016-01-01T00%3A00&rToDate=2017-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2017-01-01T00%3A00&rToDate=2018-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2018-01-01T00%3A00&rToDate=2019-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2019-01-01T00%3A00&rToDate=2020-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");

  //Add objects into scene.
  float x = width * 0.6;
  float y = height * 0.1;
  float w = width - x;
  float h = height - y;
  building = new Building(x, y, w, h);
  objects.add(building);
  
  ///////////////////////////////////Minh
  ac = new AudioContext();
  samplePlayers = new HashMap<String, SamplePlayer>();
  
  Envelope freqEnv = new Envelope(ac, 900);
  wp = new WavePlayer(ac, freqEnv, Buffer.SQUARE);
  
  //COMPUTER WHIRRING SOUND IN BACKGROUND
  samplePlayers.put("WhirringSound", new SamplePlayer(ac, SampleManager.sample(sketchPath() + "/whirringsound.wav")));
  samplePlayers.put("LeftClickSound", new SamplePlayer(ac, SampleManager.sample(sketchPath() + "/leftclicksound.wav")));
  
  samplePlayers.get("WhirringSound").setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS); //Background music loop
  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 2, 1);
  p.addInput(samplePlayers.get("WhirringSound"));
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}

void draw(){
  background(colours.get(state != "Show data" ? "Black" : "Sky blue").colour);

  if (prevLink != currLink) {
    prevLink = currLink; //Update link
    state = "Loading link";
  }

  doState();

  leftClick = false; //Ensures that left click lasts one frame
  calculateDeltaTime();
}
