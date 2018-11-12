class Entity implements IHaveParticle, ISensable, ICanSense, IClickable {
  String name = "Enity";
  Particle particle;
  PImage skin;
  String skinFn;
  private boolean hasSkin = false;
  private int skinSize;
  private float visibility = 100;

  color col = 255;
  float pSize = 50;
  boolean showSightLine = true;
  boolean showSenseCone = true;
  boolean sensed;
  ArrayList<ISenseStrategy> senses;
  ArrayList<ICanSense> iSensedBy;
  ArrayList<Observation> iObserved;
  World world;

  // -----------------------------------------------------------------------------
  // Constructors and Initializers
  // -----------------------------------------------------------------------------

  Entity(World _world, float _ex, float _ey, float _rot) {
    world = _world;
    particle = new Particle(world, _ex, _ey, _rot);
    senses = new ArrayList<ISenseStrategy>();
    iSensedBy = new ArrayList<ICanSense>();
    iObserved = new ArrayList<Observation>();
  }


  void addSense(ISenseStrategy _senseStrategy) {
    senses.add(_senseStrategy);
  }

  void loadSkin() {
    if (hasSkin) {
      skin = loadImage(skinFn);
      skin.resize(skinSize, skinSize);  // assume square image
    }
  }
  void setSkin(String _fn) {
    skinFn = _fn;
    hasSkin = true;
  }
  // -----------------------------------------------------------------------------
  // Getters and Setters
  // -----------------------------------------------------------------------------
  float getVisibility() {
    return visibility;
  }
  void setVisibility(float _v) {
    visibility = _v;
  }
  Observation getObservation() {
    return new Observation(this);
  }


  // -----------------------------------------------------------------------------
  // IHaveParticle Interface Prereqs
  // -----------------------------------------------------------------------------

  Particle getParticle() {
    return particle;
  }
  int getId() {
    return getParticle().getId();
  }
  void setId(int _id) {
    getParticle().setId(_id);
  }
  float px() {
    return getParticle().px();
  }

  float py() {
    return getParticle().py();
  }

  float ex() {
    return getParticle().ex();
  }
  float ey() {
    return getParticle().ey();
  }
  void ex(float _ex) {
    getParticle().ex(_ex);
  }
  void ey(float _ey) {
    getParticle().ey(_ey);
  }

  World getWorld() {
    return getParticle().world;
  }

  float getRotation() {
    return getParticle().getRotation();
  }
  void setRotation(float _rot) {
    getParticle().setRotation(_rot);
  }
  float getBearing() {
    return getParticle().getBearing();
  }
  void setBearing(float _bearing) {
    getParticle().setBearing(_bearing);
  }

  float bearingTo(IHaveParticle p1, IHaveParticle p2) {
    return getParticle().bearingTo(p1.getParticle(), p2.getParticle());
  }
  float distanceTo(IHaveParticle _p) {
    return getParticle().distanceTo(_p.getParticle()) ;
  }

  boolean outOfBounds() {
    return getParticle().outOfBounds();
  }

  void rotateTo(IHaveParticle _p) {
    getParticle().rotateTo(_p.getParticle());
  }

  void moveOnBearing(float _dist) {
    getParticle().moveOnBearing(_dist);
  }

  int getTick() {
    return getParticle().getTick();
  }

  void addTick() {
    getParticle().addTick();
  }


  // -----------------------------------------------------------------------------
  // Main Methods
  // -----------------------------------------------------------------------------

  ArrayList<Observation> sense() {
    iObserved.clear();
    for (ISenseStrategy iss : senses) {
      iObserved.addAll(iss.sense());
    }
    
      
    return iObserved;
  }

  void addSensedBy(ICanSense p) { 
    sensed = true;
    col = color(0, 255, 0);
    iSensedBy.add(p);
  }

  void removeSensedBy(ICanSense s) {
    sensed = false;
    col = color(255);
    while (iSensedBy.remove(s)) {  
      // remove all instances of s in list
    }
  }

  void draw() {


    imageMode(CENTER);

    pushMatrix();
    pushStyle();
    translate(px(), py());
    ellipse(0, 0, pSize, pSize);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(30);
    text(getId(), 0, 0);
    pushStyle();
    rotate(getRotation());
    fill(col);
    if (hasSkin) {
      image(skin, 0, 0);
    } 

    //line(-10, 0, 10, 0);  // center X
    //line(0, -10, 0, 10);


    if (showSightLine) line(0, 0, pSize/2, 0);
    if (showSenseCone) {
      for (ISenseStrategy iss : senses) {
        iss.drawSenseCone();
      }
    }
    popMatrix();
    popStyle();
    popStyle();
  }

  String toString() {
    return name + " " + getParticle().getId() + ": sensed: " + iObserved.size() + " e(" + ex() + "," + ey()+ "); p(" + px() +"," + py() + "); Rot: " + getRotation();
  }



  // --------------------------------------------------------------------------------------
  // MOUSE CONTROL HANDLERS
  //  -------------------------------------------------------------------------------------
  boolean mouseOver() {
    float dx = abs(mouseX - px());
    float dy = abs(mouseY - py());
    float dist = sqrt(dx*dx+dy*dy);
    if (dist <= pSize) {  // mouse is over
      return true;
    } else {
      return false;
    }
  }

  void mouseDragged() {

    float xOffset = px() - mouseX;
    float yOffset = py() - mouseY;
    //println("xOffset:" + xOffset + ", yOffset:" + yOffset);
    ex(ex() - xOffset);
    ey(ey() + yOffset);
  }

  void mouseClicked() {
    //if (col == color(255, 0, 0)) {
    //  col = 255;
    //} else {
    //  col = color(255, 0, 0);
    //}
  }
}
