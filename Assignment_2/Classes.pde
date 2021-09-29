//Because processing has no idea when the "color" class is used as part of a generic.
//Thus a new class had to be made.
public class Colour {
  private color colour;
  Colour(color newColour) {
    colour = newColour;
  }
}


public class YearData {
  MonthlyData[] months;
  
  YearData() {
    months = new MonthlyData[12];
    for (int i = 0; i < months.length; i++) {
      months[i] = new MonthlyData();
    }
  }
}

public class MonthlyData {
  float averageLogins;
  ArrayList<Integer> dailyLogins;
  int highestLogins;
  
  MonthlyData() {
    dailyLogins = new ArrayList<Integer>();
    averageLogins = 0;
  }
  
  int getAvg() {
    return ceil(averageLogins);
  }
}

//There should only be one.
public class Building extends CanvasObject {
  private int max; //Maximum number of windows in the year.
  private int curr; //Current value given.
  private int gridSize; //Size of the grid of windows
  private HashMap<String, Colour> palette; //The colour palette of the building.
  private boolean[] windowState; //Dictates whether the window is lit on or not.
  
  Building(float x, float y, float w, float h) {
    super(x, y, w, h);
    
    //Set colours
    palette = DeepCopyColours();
    palette.put("Stroke", new Colour(color(0, 0, 0, 255)));
    palette.put("No stroke", new Colour(color(0, 0, 0, 0)));
    palette.put("Busy", new Colour(color(250, 168, 26))); //Discord orange
    palette.put("Window", new Colour(color(24, 25, 28))); //Discord dark grey
    palette.put("Body", new Colour(color(132, 115, 90))); //Ugliest Tower In Sydney colour
  }
  
  void updateMax(int newMax) {
    max = newMax;
    curr = max(0, min(curr, max)); //Clamps value between 0 and new max.
    gridSize = GetClosestSquaredNumber(max);
    updateWindows();
  }
  
  //Overrides Object
  @Override void update() {}
  
  //Overrides Object
  @Override void display() {
    fill(palette.get("Body").colour);
    rectMode(CORNER);
    rect(x, y, w, h);
    
    float padX = w * 0.1;
    float padY = h * 0.1;
    float windowW = w * 0.8 / gridSize; //Width of each window
    float windowH = h * 0.8 / gridSize; //Height of of window
    for (int i = 0; i < gridSize * gridSize; i++) {
      fill(palette.get(windowState[i] ? "Busy" : "Window").colour);
      float windowX = x + padX + windowW * (i % gridSize);
      float windowY = y + padY + windowH * (i / gridSize);
      rect(windowX, windowY, windowW * 0.9, windowH * 0.9);
    }
  }
  
  public void updateWindows() { //Call this procedure to update the data.
    curr = GetMonth(monthIndex).dailyLogins.get(dayIndex);
    int numOfWindows = gridSize * gridSize;
    windowState = new boolean[numOfWindows]; //Clear all window states
    int litWindows = curr;
    while (litWindows > 0) {
      int randIndex = (int)random(0, numOfWindows);
      if (!windowState[randIndex]) {
        windowState[randIndex] = true;
        litWindows--;
      }
    }
  }
}

//There should only be one.
//This class is a circle spinning in a circle.
public class LoadingScreen extends CanvasObject {
  //How far does this circle move:
  float hDist; //Horizontally?
  float vDist; //Vertically?
  
  float tick; //How long has the loading been running?
  
  LoadingScreen(float x, float y, float size, float hDist, float vDist) {
    super(x, y, size, size);
    this.hDist = hDist;
    this.vDist = vDist;
    tick = 0;
  }
  
  //Overrides Object
  @Override void update() {
    tick += deltaTime;
  }
  
  //Overrides Object
  @Override void display() {
    fill(colours.get("White").colour);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("Loading" + StringMultiplier(".", (int)tick % 3 + 1), x, y + vDist * 1.5);
    
    float revolutions = 1; //The 1 is the number of rotations per second.
    for (int i = 0; i < 6; i++) {
      fill(255, 255, 255, 360 - 60 * i);
      float rot = tick * 360 * revolutions - 60 * i;
      ellipse(x + sin(radians(rot)) * hDist, y + cos(radians(rot)) * -vDist, w, h);
    }
  }
}

public class YearNavigator extends Navigator {  
  YearNavigator(float x, float y, float w, float h, String[] labels) {
    super(x, y, w, h, labels);
  }
  
  //Overrides Navigator
  @Override void update() {
    super.update();
    currLink = index;
  }
}

public class MonthNavigator extends Navigator {  
  MonthNavigator(float x, float y, float w, float h) {
    super(x, y, w, h, MONTHNAMES);
  }
  
  //Overrides Navigator
  @Override void update() {
    super.update();
    monthIndex = index;
  }
}

public class DayNavigator extends Navigator {
  boolean skip;
  
  DayNavigator(float x, float y, float w, float h, String[] labels) {
    super(x, y, w, h, labels);
    skip = false;
  }
  
  //Overrides Navigator
  @Override void update() {
    int size = yearData.months[monthIndex].dailyLogins.size();
    skip = size == 0;
    if (skip) {
      return;
    }

    leftButton.update();
    index = index < 0 ? size - 1 : index;
    rightButton.update();
    index %= size;
    
    dayIndex = index;
  }
  
  @Override void display() {
    if (!skip) {
      super.display();
    }
  }
}

public class NavigatorButton extends Button { //Dependent class on Timeline
  Navigator navigator;
  int step;
  
  NavigatorButton(Navigator navigator, float x, float y, float w, float h, int step) {
    super(x, y, w, h);
    this.step = step;
    this.navigator = navigator;
  }
  
  //Overrides Object
  @Override void display() {
    stroke(palette.get("Black").colour);
    fill(palette.get(isHovering ? "HoverColour" : "Sky blue").colour);
    rect(x, y, w, h);
    stroke(palette.get("Invisible").colour);
  }
  
  //Overrides Button
  @Override void doAction() {
    navigator.index = (navigator.index + step) % navigator.labels.length; 
  }
}

public class MonthlyBarGraph extends CanvasObject {
  float[] monthValues; //The average login for each month in values
  int prevLink; //The previous link a field separate to the global instance of the variable
  int max; //The highest login value in the month
  
  MonthlyBarGraph(float x, float y, float w, float h) {
    super(x, y, w, h);
    monthValues = new float[12]; //There is always 12 months in a year right?
    prevLink = -1;
    max = 0;
  }
  
  @Override void update() {
    if (prevLink == currLink) {
      return;
    }
    prevLink = currLink;
    
    for (int i = 0; i < monthValues.length; i++) {
      monthValues[i] = GetMonth(i).getAvg(); //Ternary to account for 2019-2020
    }
    max = (int)max(monthValues);
  }
  
  @Override void display() {
    rectMode(CORNER);
    fill(colours.get("Black").colour);
    stroke(colours.get("White").colour);
    textAlign(CENTER, CENTER);
    textSize(30);
    float textHeight = textAscent() + textDescent();
    float barWidth = w / monthValues.length;
    for (int i = 0; i < monthValues.length; i++) {
      float barHeight = monthValues[i] / max * h;
      float xPos = x + (barWidth * i);
      float yPos = y + h;
      rect(xPos, yPos - barHeight, barWidth, barHeight);
      text(MONTHNAMES[i], xPos + barWidth * 0.5, yPos + textHeight * 0.5);
      text(ceil(monthValues[i]), xPos + barWidth * 0.5, yPos - barHeight - textHeight);
    }
    text("Average user logins everyday (Rounded up)", x + w * 0.5, y + h * 1.5);
    stroke(colours.get("Invisible").colour);
  }
}
