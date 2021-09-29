//Returns the string after it has been multiplied by itself
//For example: "Hi" * 3 = "HiHiHi"
String StringMultiplier(String string, int mult) {
  String result = "";
  for (int i = 0; i < mult; i++) {
    result += string;
  }
  return result;
}

//Use this function if a copy of the global colours is needed.
//Do not use "var = colours" because var would only get the reference of colours
//Meaning any modifications to var would affect colours.
HashMap<String, Colour> DeepCopyColours() {
  HashMap<String, Colour> copy = new HashMap<String, Colour>();
  colours.forEach((String name, Colour value) -> {
    copy.put(name, value);
  });
  return copy;
}

//Return the number that when squared will be higher than the number given.
int GetClosestSquaredNumber(int num) {
  int square = 1;
  while (square * square < num) {
    square++;
  }
  return square;
}

MonthlyData GetMonth(int index) {
  return yearData.months[index];
}
