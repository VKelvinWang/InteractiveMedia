import beads.*;
import processing.sound.*;


Table dataTable;

HashMap<String, Colour> colours; //Universally holds all colours added into it.
ArrayList<String> links; //Holds the links for the entire timeline.

String link;

AudioContext ac;//Sound
WavePlayer wp;
Glide freq;

void setup(){
  size(1920, 1080);
  
  //Initialise global variables
  links = new ArrayList<String>();
  colours = new HashMap<String, Colour>();
  
  //Set colours into hashmap
  colours.put("Background", new Colour(color(135, 206, 235))); //Sky blue
  
  //Data: PCLabs Logins
  //Start date: 1/1/2015
  //End date: 31/12/2020
  //Each link is one year.
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2015-01-01T00%3A00&rToDate=2016-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2016-01-01T00%3A00&rToDate=2017-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2017-01-01T00%3A00&rToDate=2018-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2018-01-01T00%3A00&rToDate=2019-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  links.add("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2019-01-01T00%3A00&rToDate=2020-01-01T00%3A00&rFamily=logins&rSensor=E1-07404");
  
  ac = new AudioContext();
  Envelope freqEnv = new Envelope(ac, 900);
  wp = new WavePlayer(ac, freqEnv, Buffer.SQUARE);
  //COMPUTER WHIRRING SOUND IN BACKGROUND
  String backGround = "/Users/Minh Khoi/Documents/GitHub/InteractiveMedia/Assignment_2/whirringsound.wav";
  SamplePlayer player1 = new SamplePlayer(ac, SampleManager.sample(backGround));
  player1.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS); // Background music loop
  Panner p = new Panner(ac, 0);
  Gain g = new Gain(ac, 2, 1);
  p.addInput(player1);
  g.addInput(p);
  ac.out.addInput(g);
  ac.start();
}

void draw(){
  background(colours.get("Background").colour);
  
  if (mousePressed && (mouseButton == LEFT)) 
  {
    sound();
  }
}
