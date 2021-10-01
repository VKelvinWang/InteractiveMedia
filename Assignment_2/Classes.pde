//Because processing has no idea when the "color" class is used as part of a generic.
//Thus a new class had to be made.
public class Colour {
  private color colour;
  Colour(color newColour) {
    colour = newColour;
  }
}

//Kelvin
public class Computer extends CanvasObject {
  PImage pathway;
  Computer(float x, float y, float w, float h, PImage pathway) {
    super(x, y, w, h);
    this.pathway = pathway;
  }

  @Override void display() {
    //prints the image
    pathway.resize((int)w, (int)h);
    image(pathway, x, y);

    //prints out text
    fill(colours.get("Black").colour);
    stroke(colours.get("White").colour);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("Total PC Logins", x + w / 2, y + h * 0.2);
  }

  @Override void update() {
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
  private PFont font, def;
  private int max; //Maximum number of windows in the year.
  private int curr; //Current value given.
  private int gridSize; //Size of the grid of windows
  private HashMap<String, Colour> palette; //The colour palette of the building.
  private boolean[] windowState; //Dictates whether the window is lit on or not.

  Building(float x, float y, float w, float h) {
    super(x, y, w, h);
    font = createFont("punkkid.ttf", 50, true);
    def = createFont("Arial", 20, true);
    //Set colours
    palette = DeepCopyColours();
    palette.put("Stroke", new Colour(color(0, 0, 0, 255)));
    palette.put("No stroke", new Colour(color(0, 0, 0, 0)));
    palette.put("Busy", new Colour(color(250, 168, 26))); //Discord orange
    palette.put("Window", new Colour(color(24, 25, 28))); //Discord dark grey
    palette.put("Body", new Colour(color(157, 125, 125))); //Building 11 colour
  }

  void updateMax(int newMax) {
    max = newMax;
    curr = max(0, min(curr, max)); //Clamps value between 0 and new max.
    gridSize = GetClosestSquaredNumber(max);
  }

  //Overrides Object
  @Override void update() {
  }

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

    //kelvin
    //prints out text
    fill(colours.get("White").colour);
    stroke(colours.get("Black").colour);
    textAlign(CENTER, CENTER);
    textFont(font);
    text("UTS BUILDING 11", x + w / 2, y + h * 0.05);
    textFont(def);
  }

  public void updateWindows() { //Call this procedure to update the data.
    int size = GetMonth(monthIndex).dailyLogins.size();
    curr = 0;
    if (size > 0) {
      dayIndex = dayIndex > size ? size - 1 : dayIndex;
      dayIndex %= size;
      curr = GetMonth(monthIndex).dailyLogins.get(dayIndex);
    }

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
  @Override void doAction() {
    currLink = index;
  }
}

public class MonthNavigator extends Navigator {
  MonthNavigator(float x, float y, float w, float h) {
    super(x, y, w, h, MONTHNAMES);
  }

  //Overrides Navigator
  @Override void doAction() {
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
    skip = yearData.months[monthIndex].dailyLogins.size() == 0;
    if (skip) {
      return;
    }

    super.update();
    index = dayIndex;
  }

  @Override void display() {
    if (!skip) {
      super.display();
    }
  }

  @Override void doAction() {
    //int size = yearData.months[monthIndex].dailyLogins.size();
    //index = index > size ? size - 1 : index;
    //index %= size;
    dayIndex = index;
  }
}

public class NavigatorButton extends Button { //Dependent class on Timeline
  Navigator navigator;
  int step;
  boolean isLeft;

  NavigatorButton(Navigator navigator, float x, float y, float w, float h, int step, boolean isLeft) {
    super(x, y, w, h);
    this.step = step;
    this.navigator = navigator;
    this.isLeft = isLeft;
  }

  //Overrides Object
  @Override void display() {
    stroke(palette.get("Black").colour);
    fill(palette.get(isHovering ? "HoverColour" : "Sky blue").colour);
    rect(x, y, w, h);
    if (isLeft) { //if it is in the left position
      stroke(palette.get("Black").colour);
      fill(palette.get("Black").colour);
      textAlign(CENTER, CENTER);
      textSize(40);
      text("Prev", x + w / 2, y + h / 2);
    } else { //else, it is in the right position
      stroke(palette.get("Black").colour);
      fill(palette.get("Black").colour);
      textAlign(CENTER, CENTER);
      textSize(40);
      text("Next", x + w / 2, y + h / 2);
    }
    stroke(palette.get("Invisible").colour);
  }

  //Overrides Button
  @Override void doAction() {
    navigator.index = (navigator.index + step) % navigator.labels.length;
    navigator.index = navigator.index < 0 ? navigator.labels.length - 1 : navigator.index;
    navigator.doAction();
    building.updateWindows();
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
      monthValues[i] = GetMonth(i).getAvg();
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
