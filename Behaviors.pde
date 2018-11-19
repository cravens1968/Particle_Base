class BaseBehavior implements IBehavior, IReportable {
  Animal self;
  boolean tagged = false;
  int behaviorID;
  String name = "";
  float averageStep = 1;
  float moveStep = averageStep;
  float averageFoodBurned = 1;
  float memoryCounter = 1;

  BaseBehavior(Animal _self) {
    behaviorID = 0;
    self = _self;
  }
  boolean execute() {
    return false;
  }
  void move() {
    self.burnFood(averageFoodBurned);
    if (self.getStomach() > .5) {
      moveStep = averageStep * 1.3;
    } else if (self.isHungry()) {
      moveStep = averageStep * .7;
    }
    self.move(moveStep);
  }
  void setId(int newId) {
    behaviorID = newId;
  }
  int getId() {
    return behaviorID;
  }
  String getName() {
    return name;
  }
  String toString() {
    String s = ""; 
    return s;
  }
  void toggleTagged() {
    tagged = !tagged;
  }
  void selfReport() {
    if (tagged) {
      Report(this);
    }
  }

  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    sArray.add("Behavior Report: ");
    sArray.add("No behaviors reporting...");
    return sArray;
  }
}




class Graze extends BaseBehavior {
  boolean grazing = false; 

  Graze(Animal _self) {
    super(_self);
    name = "Graze";
  }
  boolean execute() {
    Console(this);
    if (!grazing && self.isHungry()) {
      self.feed(1);
      grazing = true;
      return true;
    } else if (grazing && self.getStomach() < 1) {
      self.feed(1);
      return true;
    }
    grazing = false;
    return false;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Grazing ...."; 
    return s;
  }
}


class Wander extends BaseBehavior {
  float wanderMin = 100;
  float wanderMax = 300;
  float wanderRate = random(wanderMin, wanderMax);



  Wander(Animal _self) {
    super(_self);
    memoryCounter = wanderRate;
    name = "Wander";
  }
  boolean execute() {

    if (memoryCounter-- <= 0) {
      self.setRotation(random(0, 2*PI));
      memoryCounter = wanderRate;  // reset counter
      wanderRate = int(random(wanderMin, wanderMax));
    }
    move();

    Console(this);
    selfReport();
    return true;
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Wandering ...."; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    sArray.add("Name: ");
    sArray.add(self.getName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Wandering: ");
    sArray.add("..." );
    for (Observation o : self.getObserved()) {
      buf = buf + o.parent.getId() + " ";
    }
    sArray.add("Observed: ");
    sArray.add(buf);
    return sArray;
  }
}

class Avoid extends Track {

  Avoid(Animal _self, String _targetType) {
    super(_self, _targetType);
    name = "Avoid";
  }
  boolean execute() {

    if (super.execute()) {
      selfReport();
      return true;
    }
    return false;
  }
  void turn() {
    super.turn();
    self.setRotation(self.getRotation()+PI);
  }
  void move() {
    self.burnFood(averageFoodBurned);
    if (self.getStomach() > .5) {
      moveStep = averageStep * 1.3;
    } else if (self.isHungry()) {
      moveStep = averageStep * .7;
    }
    self.move(moveStep);
  }
  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Avoiding ..." + targetType; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    sArray.add("Name: ");
    sArray.add(self.getName());
    sArray.add("Id: ");
    sArray.add(str(getId()));
    sArray.add("Avoiding: ");
    sArray.add("..." + str(memoryCounter));
    return sArray;
  }
}

class Mate extends Track {


  Mate(Animal _self, String _targetType) {
    super(_self, _targetType);  
    name = "Mate";
  }

  boolean execute() {
    Animal animal = null;
    ICanMate targetMate = null;

    if (self.isFull()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }
      targetMate = (ICanMate)target;  

      if (distanceToTarget() < 10) {  // close enough to mate
        if (self.isFull() && self.isAdult())
          if (targetMate.isAdult()) {
            animal = animalFactory.getAnimal(self.name);
            if (animal != null) {
              animal.clone(self);
              animal.setChild(true);
              animal.feed(animal.stomachFull);  // kids start full
              self.world.addAnimal(animal);
            }
          }
      }
      return true;
    } else {
      target = null;
      return false;
    }
  }
}




class Hunt extends Track {

  Hunt(ICarnivore _self, String _targetType) {
    super((Animal)_self, _targetType);
    name = "Hunt";
  }
  boolean execute() {

    if (self.isAdult() && !self.isFull()) {
      if (!super.execute()) {  // super couldnt find a target
        return false;
      }

      if (distanceToTarget() < 10) {  // close enough to eat
        target.kill();
        self.feed(self.stomachFull);
        target = null;
      }
      selfReport();
      return true;
    } else {
      return false;
    }
  }



  String toString() {
    String s = self.getName() + " [" + self.getId() + "] hunting ..." + targetType; 
    return s;
  }
  ArrayList<String> getReport() {
    ArrayList<String> sArray = new ArrayList<String>();
    String buf = "";
    if (target != null) {
      sArray.add("[" + str(self.getId()) + "] is hunting [" + str(target.getId()) + "] ..." + str(memoryCounter));
    }
    for (Observation o : prey) {
      buf = buf + o.parent.getId() + " ";
    }
    sArray.add("Prey: ");
    sArray.add(buf);
    sArray.add("closest Prey: " + str(closestPrey.getId()));
    return sArray;
  }
}

class Track extends BaseBehavior {
  ISensable target;
  String targetType;
  ArrayList<Observation> prey = null;
  Observation closestPrey = null;



  Track(ICanTrack _self, String _targetType) {
    super((Animal)_self);
    targetType = _targetType;
    name = "Track";
  }

  boolean execute() {

    if (forget() || !acquire()) {
      return false; // lost scent
    } 
    self.setTarget(target);
    turn();
    move();
    Console(this);
    return true;
  }



  boolean acquire() {
    prey = new ArrayList<Observation>();
    
    if (self.getObserved().size() > 0) {  // I see something

      for (Observation obs : self.getObserved()) {   // add all cows to list of prey
        if (obs.parent.getName() == targetType) {
          prey.add(obs);
        }
      }

      // compare distance to each prey and hunt closest
      if (prey.size() == 1) {
        if (!prey.get(0).parent.isDead() ) {
          target = prey.get(0).parent;
          return true;
        } else {
          target = null;
          return false;
        }
      } else if (prey.size() > 1) {  // there more than 1 in the list so choose closest

        for (Observation obs : prey) {
          if (closestPrey == null) {
            closestPrey = obs;
          } else {
            float distanceObs = self.distanceTo(obs);
            float distancePrey = self.distanceTo(closestPrey);
            if (distanceObs < distancePrey) {
              closestPrey = obs;
            } else {
              // do nothing because closest is still closests
            }
          }
        }
        target = closestPrey.parent;
      } else if (prey.size() == 0) {  
        return false; // only wolves  in sight
      }
    }
    return false;  // I don't see anything at all
  }


  void turn() {
    self.rotateTo(target);
  }

  float distanceToTarget() {
    return self.distanceTo(target);
  }

  boolean forget() {
    if (memoryCounter-- <= 0) {
      memoryCounter = self.getMemory(); // reset memory counter
      target = null;
      if(self != null) {
        self.setTarget(null);  // How can self be null?
      }
      return true;
    } else {
      return false;
    }
  }



  String toString() {
    String s = self.getName() + " [" + self.getId() + "] Tracking ..." + targetType; 
    return s;
  }
}
