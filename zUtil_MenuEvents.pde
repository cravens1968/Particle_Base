public void Pause () {
  pause = !pause;
}
public void Print() {

  bprint = !bprint;
}

public void Select() {

  bSelected = !bSelected;
}
public void ToMouse() {
  bToMouse = !bToMouse;
}

public void Freeze() {
  bFreeze = !bFreeze;
  pause = bFreeze;
}

public void Scale() {
  bScale = !bScale;
}
void FindAnimal(int theAnimal) {
  Animal tag = swamp.findAnimal(theAnimal);
  if (tag != null) {
    swamp.setSelected(tag);
  }
}
