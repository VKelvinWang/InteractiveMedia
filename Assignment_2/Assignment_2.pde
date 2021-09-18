import beads.*;

Table dataTable;

HashMap<String, Colour> colours; //Universally holds all colours added into it.
ArrayList<String> links; //Holds the links for the entire timeline.

String link;

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
}

void draw(){
  background(colours.get("Background").colour);
}
