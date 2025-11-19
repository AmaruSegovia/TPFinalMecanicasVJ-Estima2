// Detector de teclas a nivel global
public class InputManager {
  boolean up, down, left, right, shoot;
  
  void keyPressed(char k) {
    switch(Character.toLowerCase(k)) {
      case 'w': up = true; break;
      case 's': down = true; break;
      case 'a': left = true; break;
      case 'd': right = true; break;
      case 'j': shoot = true; break;
    }
  }
  
  void keyReleased(char k) {
    switch(Character.toLowerCase(k)) {
      case 'w': up = false; break;
      case 's': down = false; break;
      case 'a': left = false; break;
      case 'd': right = false; break;
      case 'j': shoot = false; break;
    }
  }
}
