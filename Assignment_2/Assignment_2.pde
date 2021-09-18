import java.util.*;
import beads.*;

Table dataTable;


String link;

void setup(){
  size(1920, 1080);
  
  //Start date: 1/1/2015
  //End date: 18/9/2021
  link = "https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2000-01-01T20%3A24%3A20&rToDate=2021-09-18T20%3A24%3A20&rFamily=logins&rSensor=e1-0744";
  
}

void draw(){
  background(135,206,235);
}
