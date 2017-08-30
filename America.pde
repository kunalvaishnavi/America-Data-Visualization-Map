/**
 * Author: Kunal Vaishnavi
 * Date: 5/17/17
 * Note: In order for this to run best, you should use a mouse with left click.
 */

PShape county_map;
PShape[] counties; // List of counties is in column A of income.csv
Table table;
TableRow tMax, tMin;
int avg; // ~14,310
String previous = "";

// Repaints the information box
void make(){
  fill(255, 157, 173);
  rect(550, 525, 225, 100);
  fill(0, 0, 0);
  text("County Name:", 560, 545);
  text("State Name:", 560, 560);
  text("Data Value:", 560, 575);
  fill(219, 100, 219);
  rect(560, 590, 60, 25); // Random
  rect(630, 590, 60, 25); // Max data
  rect(700, 590, 60, 25); // Min data
  fill(0, 0, 0);
  text("Random", 566, 608);
  text("Max data", 633.5, 608);
  text("Min data", 705, 608);
}

// Puts information in the text box and handles duplicate scenarios
void duplicateScenario(String c, String d){
  if(!previous.equals(c)){
    make();
    if(c.indexOf(",") == -1){ // Scenario when state name or "UNITED STATES" is written
      text("N/A", 645, 545);
      text(c, 632, 560);
    }
    else{ 
      text(c.substring(0, c.indexOf(",")), 645, 545);
      text(c.substring(c.indexOf(",")+1), 630, 560);
    }
    text(d, 630, 575);
    previous = c;
  }
}

void setup() { // Only runs once
  size(990, 627);
  county_map = loadShape("usa_counties.svg");
  counties = county_map.getChildren()[1].getChildren();
  table = loadTable("income.csv", "header");
  int sum = 0, count = 0;
  for (TableRow row : table.rows()) {
    sum += row.getInt("INC110179D");
    count++;
  }
  avg = sum/count;
  make();
}

void draw() {
  shape(county_map, 0, 0, width, height);
  // When you press "1", the blue and red colors show up
  if (keyPressed) {
    if (key == '1') {
      for (TableRow row : table.rows()) {
        String id = row.getString("STCOU");
        PShape temp = county_map.getChildren()[1].getChild(id);
        if (temp != null) {
          if (row.getInt("INC110179D") > avg) {
            temp.setFill(color(0, 0, 255));
          }
          else { 
            temp.setFill(color(255, 0, 0));
          }
        }
      }
    }
  }
  // Popup showing information about the county
  int pos = 1; // Must start where the first county is
  PShape s = null;
  for (PShape p : counties) {
    if (p.contains(mouseX, mouseY)) { // Checks to see if cursor is on the county
      s = p;
    }
  }
  for(TableRow row : table.rows()){
    if(s != null && s.getName().equals(row.getString("STCOU"))){
      String c = row.getString("Area_name"); // Gets the county name
      String d = row.getString("INC110179D"); // Gets the data value
      duplicateScenario(c, d);
    }
    else {
      pos += 1;
    }
  }
  // Case when "Random" button is pressed
  if(mouseX > 560 && mouseX < 620 && mouseY > 590 && mouseY < 615){
    if(mousePressed && (mouseButton == LEFT)){
      make();
      TableRow t = table.getRow((int)random(1, 3198));
      String c = t.getString("Area_name"); // Gets the county name
      String d = t.getString("INC110179D"); // Gets the data value
      duplicateScenario(c, d);
    }
  }
  // Max data
  pos = 0;
  if(mouseX > 630 && mouseX < 690 && mouseY > 590 && mouseY < 615){
    if(mousePressed && (mouseButton == LEFT)){
      make();
      int max = 0, posOfMax = 0;
      for(TableRow t : table.rows()){
        int d = t.getInt("INC110179D");
        if(d > max){
          max = d;
          posOfMax = pos;
        }
        pos += 1;
      }
      tMax = table.getRow(posOfMax);
      String c = tMax.getString("Area_name"); // Gets the county name
      String d = tMax.getString("INC110179D"); // Gets the data value
      duplicateScenario(c, d);
    }
  }
  // Min data
  pos = 0;
  if(mouseX > 700 && mouseX < 760 && mouseY > 590 && mouseY < 615){
    if(mousePressed && (mouseButton == LEFT)){
      make();
      int min = table.getRow(1).getInt("INC110179D"), posOfMin = 0;
      for(TableRow t : table.rows()){
        int d = t.getInt("INC110179D");
        if(d < min){
          if(d != 0){ // Skip the one "0" case since we assume it's an anomaly
            min = d;
            posOfMin = pos;
          }
        }
        pos += 1;
      }
      tMin = table.getRow(posOfMin);
      String c = tMin.getString("Area_name"); // Gets the county name
      String d = tMin.getString("INC110179D"); // Gets the data value
      duplicateScenario(c, d);
    }
  }
}