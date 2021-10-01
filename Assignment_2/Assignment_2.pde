import beads.*;
import processing.sound.*;

//Constants
String[] MONTHNAMES;

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

YearData yearData;
int dayIndex; //The index to access data on a day in the month
int monthIndex; //The index to access a month in the year.

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

//Kelvin
HashMap<String, PImage> imageManager; //Universally holds all images into a hashmap
PImage computer;
PImage backgroundLoading;
PImage backgroundMenu;
PImage button;

void setup() {
  size(1920, 1080);

  ///////////////////////////////////Ryan
  //Seting constants
  MONTHNAMES = new String[] { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

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

  yearData = new YearData();
  dayIndex = 0;
  monthIndex = 0;

  objects = new ArrayList<Object>();
  keyManager = new HashMap<Character, Boolean>();
  imageManager = new HashMap<String, PImage>();
  //Be sure to use "keyboardBindedObjects.add(this)" in the contructor for whatever class that implemented this.
  keyboardBindedObjects = new ArrayList<KeyboardBindable>();

  //Set colours into hashmap
  colours.put("Sky blue", new Colour(color(135, 206, 235)));
  colours.put("White", new Colour(color(255, 255, 255)));
  colours.put("Black", new Colour(color(0, 0, 0)));
  colours.put("Invisible", new Colour(color(0, 0, 0, 0)));

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

  x = width * 0.05;
  y = height * 0.2;
  w = width * 0.5;
  h = height * 0.15;
  objects.add(new MonthlyBarGraph(x, y, w, h));

  ///////////////////////////////////Kelvin

  String[] labels = new String[] {"2015-2016", "2016-2017", "2017-2018", "2018-2019", "2019-2020"};
  x = width * 0.15;
  y = height * 0.01;
  w = width * 0.3;
  h = height * 0.1;
  objects.add(new YearNavigator(x, y, w, h, labels));

  y = height * 0.6;
  objects.add(new MonthNavigator(x, y, w, h));

  y = height * 0.7;
  labels = new String[31];
  for (int i = 0; i < labels.length; i++) {
    labels[i] = str(i + 1);
  }
  objects.add(new DayNavigator(x, y, w, h, labels));

  //Kelvin
  computer = loadImage("cartooncomp.png");
  backgroundMenu = loadImage("background.jpg");
  button = loadImage("button.png");
  backgroundLoading = loadImage("black.jpg");

  imageManager.put("Computer", computer);
  imageManager.put("Background", backgroundMenu);
  imageManager.put("Button", button);
  imageManager.put("Loading", backgroundLoading);

  x = width * 0.07;
  y = height * 0.45;
  w = 900;
  h = 650;
  objects.add(new Computer(x, y, w, h, imageManager.get("Computer")));

  ///////////////////////////////////Minh
  ac = new AudioContext();
  samplePlayers = new HashMap<String, SamplePlayer>();

  Envelope freqEnv = new Envelope(ac, 900);
  wp = new WavePlayer(ac, freqEnv, Buffer.SQUARE);

  ////COMPUTER WHIRRING SOUND IN BACKGROUND
  samplePlayers.put("WhirringSound", new SamplePlayer(ac, SampleManager.sample(sketchPath() + "/whirringsound.wav")));
  samplePlayers.get("WhirringSound").setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS); //Background music loop
  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 1, 0.1); //volume control between 0.0-1.0
  p.addInput(samplePlayers.get("WhirringSound"));
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();

  ///////////////////////Kelvin
  samplePlayers.put("BackgroundMusic", new SamplePlayer(ac, SampleManager.sample(sketchPath() + "/backgroundmusic.wav")));
  samplePlayers.get("BackgroundMusic").setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS); //Background music loop
  Panner pan = new Panner(ac, 0);
  Gain gains = new Gain(ac, 1, 0.2); //volume control between 0.0-1.0
  pan.addInput(samplePlayers.get("BackgroundMusic"));
  gains.addInput(pan);
  ac.out.addInput(gains);
  ac.start();
}

void draw() {
  //display background
  background(imageManager.get(state != "Show data" ? "Loading" : "Background"));

  if (prevLink != currLink) {
    prevLink = currLink; //Update link
    state = "Loading link";
  }

  doState();

  leftClick = false; //Ensures that left click lasts one frame
  calculateDeltaTime();
}
