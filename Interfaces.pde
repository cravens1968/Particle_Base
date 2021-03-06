
interface IClickable {
  boolean mouseOver();
  void mouseDragged();
  void mouseClicked();
}

interface IHaveParticle {
  Particle getParticle();
  float px();
  float py();
  float ex();
  float ey();
  void ex(float _ex);
  void ey(float _ey);
  float getRotation();
  void setRotation(float _rot);
  float getBearing();
  void setBearing(float _rot);
  float bearingTo(IHaveParticle p1, IHaveParticle p2);
  void rotateTo(IHaveParticle _p);
  float distanceTo(IHaveParticle _p);
  boolean outOfBounds();
  void moveOnBearing(float dist);
  int getId();
  int getTick();
  void addTick();
}
interface ICanDie {
  void die();
  boolean isDead();
}

interface ISenseStrategy {
  ArrayList<Observation> sense();
  void drawSenseCone(int _col);
  ArrayList<String> getReport();
}

interface ICanSense extends IHaveParticle {
  World getWorld();
  ArrayList<Observation> sense();
}

interface ISensable extends IHaveParticle {
  void addSensedBy(ICanSense s);
  void removeSensedBy(ICanSense s);
  float getVisibility();
  Observation getObservation();
  String getObjectName();
  int getId();
  void die();
  boolean isDead();
}


interface ICanMove {
}

interface ICanMate {
  boolean isAdult();
  boolean isFull();
  boolean isHungry();
  boolean isReadyToMate();
  int getLastChildTick();
  void setLastChildTick(int _tick);
  Animal spawn();
 
}

interface ICarnivore extends ICanEat {
  boolean isCarnivore();
  float getMemory();
}
interface ICannibal  {

  
  
}
interface IHerbivore extends ICanEat {
  boolean isHerbavore();
}
interface ICanEat {
  void feed(float _food);
  float getStomach();
  boolean isHungry();
  boolean isFull();
  float getStomachFull();
  void burnFood(float _food);
  String getObjectName();
  int getId();
}
interface ICanTrack {
  ArrayList<Observation> getObserved();
  ISensable getTarget();
  void setTarget(ISensable _target);
}
interface IBehavior extends IReportable {
  boolean execute();
  int getId();
  void setId(int newId);
  String getObjectName();
  void drawTrackLine();
}

interface IReportable {
  ArrayList<String> getReport();
  String toString();
  void toggleTagged();
  int getId();
}
interface IPackAnimal {
  
}
