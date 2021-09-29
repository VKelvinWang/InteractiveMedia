//Every state in the program.
void doState() {
  switch(state) {
    case "Loading link":
      thread("changeLink"); //No break here, go to next case.
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
void changeLink() {
  yearData = new YearData();
  data = loadTable(links.get(currLink), "csv");
  
  int highestLogins = 0;
  int totalDailyLogin = 0;
  float totalMonthlyLogin = 0; //Is a float to save the hassle of casting
  int numOfDaysInMonth = 0;
  
  String prevMonth = "01";
  String currMonth = prevMonth;
  String prevDay = "01";
  String currDay;
  String date;
  for (int i = 0; i < data.getRowCount(); i++) {
    date = data.getString(i, 0);
    currDay = date.substring(8, 10);
    
    if (prevDay.equals(currDay)) {
      totalDailyLogin += data.getInt(i, 1);
      continue;
    }
    
    GetMonth(int(currMonth) - 1).dailyLogins.add(totalDailyLogin);
    
    prevDay = currDay;
    totalMonthlyLogin += totalDailyLogin;
    highestLogins = totalDailyLogin > highestLogins ? totalDailyLogin : highestLogins;
    totalDailyLogin = 0;
    numOfDaysInMonth++;
    
    currMonth = date.substring(5, 7);
    if (prevMonth.equals(currMonth)) {
      continue;
    }
    
    GetMonth(int(prevMonth) - 1).averageLogins = totalMonthlyLogin / numOfDaysInMonth;
    prevMonth = currMonth;
    numOfDaysInMonth = 0;
    totalMonthlyLogin = 0;
  }
  
  int numOfDays = GetMonth(monthIndex).dailyLogins.size();
  dayIndex = dayIndex < 0 ? numOfDays - 1 : dayIndex;
  dayIndex = dayIndex % numOfDays;
  
  building.updateMax(highestLogins);
  
  state = "Show data";
}

void updateObjects() {
  //For every object in the scene, blit it.
  for (Object object : objects) {
    object.blit();
  }
  
  fill(colours.get("Black").colour);
  text(dayIndex, width / 2, height / 2);
}
