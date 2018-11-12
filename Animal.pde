class Wolf extends Animal implements ICarnivore {

  Wolf(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "wolf";
    addSense(new PredatorVision(this));
    addBehavior(new Wander(this));
    setVisibility(100);
  }
  void hunt() {
  }
}

class Cow extends Animal implements IHerbavore {
  Cow(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_id, _world, _ex, _ey, _rot);
    name = "cow";
    addSense(new PreyVision(this));
    addBehavior(new Graze(this));
    addBehavior(new Wander(this));
    setVisibility(100);
  }
}


class Animal extends Entity implements ICanMove, ICanMate {

  float stomach = 5;
  float hungerThresh = 0;
  float stomachFull = 150;
  float memory = 100;
  int children = 0;
  ICanMate mate;
  int ticksSinceLastChild = 0;
  ArrayList<IBehavior> behaviors;


  // ----------------------------------------------------------------------------------
  // Constructors and Initializers
  // ----------------------------------------------------------------------------------

  Animal(int _id, World _world, float _ex, float _ey, float _rot) {
    super(_world, _ex, _ey, _rot);
    getParticle().setId(_id);
    stomach = int(random(0, stomachFull));
    behaviors = new ArrayList<IBehavior>();
  }

  void addBehavior(IBehavior newB) {
    behaviors.add(newB);
  }

  // ----------------------------------------------------------------------------------
  // getters and setters
  // ----------------------------------------------------------------------------------
  float getStomach() {
    return stomach;
  }

  float getStomachFull() {
    return stomachFull;
  }




  // ----------------------------------------------------------------------------------
  // state getters
  // ----------------------------------------------------------------------------------

  boolean isHungry() {
    return stomach < hungerThresh;
  }

  boolean hasMate() {
    return mate != null;
  }

  // ----------------------------------------------------------------------------------
  // main methods
  // ---------------------------------------------------------------------------------- 



  void tick(int _tick) {
    addTick();
    sense();
    execute();
    println(this);
  }
  
  



  void feed(float _food) {
    stomach += _food;
  }

  void burnFood(float _food) {
    stomach -= _food;
  }

  void execute() {
    for (IBehavior b : behaviors) {
      if (b.execute()) {
        break;
      }
    }
  }

  void move(float dist) {
    setBearing(getRotation());
    if (outOfBounds()) {
      setBearing(getBearing()+PI);
    }
    moveOnBearing(dist);
  }
  ArrayList<Observation> sense() {
    iObserved.addAll(super.sense());
    removeDuplicates();
    deleteAgedObservations();
    return iObserved;
  }

  void deleteAgedObservations() {
    for (int i = iObserved.size() - 1; i >= 0; i--) {
      if (iObserved.get(i).getAge() > memory) {
        iObserved.remove(i);
      }
    }
  }
  
  void removeDuplicates() {
    for (int i = 0; i < iObserved.size(); i++)  {
      for (int ii = iObserved.size() - 1; ii > i; ii--)  {
        if (iObserved.get(i).parent == iObserved.get(ii).parent ) {
          iObserved.remove(ii);
        } 
          
      }
    }
  }

  String toString() {

    String s = "[" + getId() + "] " + name + " -- observed: " + iObserved.size() + " children: " + children;
    return s;
  }
}
