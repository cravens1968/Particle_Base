import controlP5.*; //<>//
import java.util.*;
CPanel myPanel;
World swamp; 

boolean pause = false;
boolean bprint = false;
boolean selected = false;

void setup() {
  size(2000, 2000);
  swamp = new World(width, height, width, height);

  swamp.createParticle();
  swamp.createParticle();
  swamp.createParticle();
  swamp.createParticle();

  myPanel = new CPanel(this);
  myPanel.setButtonSize(100, 75);
  String[] toggles = {"Pause", "Print", "Select", "Add"};
  myPanel.addToggle(toggles);


  swamp.setup();
  //swamp.print();
}
void draw() {
  if (!pause) swamp.tick();
  swamp.draw();
}
