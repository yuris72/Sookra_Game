// ship object class
class Ship{
  final int N_SPRITES_X = 3; // get number of sprites in the x direction
  final int N_SPRITES_Y = 1; // get number of sprites in the y direction
  final int TOTAL_SPRITES = N_SPRITES_X * N_SPRITES_Y; // get total number of sprites
  
  PImage [] sprites; // array of individual sprite images
  PImage spriteSheet;
  int spriteWidth;
  int spriteHeight;
  
  float x; // x position of the ship
  float y; // y position of the ship
  float speed; // ship speed
  float size; // size of ship hitbox
  String state; // state of the ship
  
  Ship(float x, float y, float speed, float size, String state, PImage image){
    sprites = new PImage[TOTAL_SPRITES]; // set array size equal to total number of sprites
    spriteSheet = image;
    spriteWidth = spriteSheet.width/N_SPRITES_X; // calculate width of each sprite
    spriteHeight = spriteSheet.height/N_SPRITES_Y; // calculate height of each sprite
    
    // loop through the sprite sheet and insert each sprite into "sprites"
    int index = 0;
    for (int y1=0; y1<N_SPRITES_Y; y1++){
      for (int x1=0; x1<N_SPRITES_X; x1++){
        sprites[index] = spriteSheet.get(x1*spriteWidth, y1*spriteHeight, spriteWidth, spriteHeight);
        index++;
      }
    }
    
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.size = size;
    this.state = state;
  }
  
  // method for displaying the ship
  void drawShip(){
    // if the state of the ship is "right"
    if (state.equals("right")){
      image(sprites[1],x-spriteWidth/2,y-spriteHeight/2); // draw the sprite that's tilted to the right centered at (x,y)
    // if the state of the ship is "left"
    } else if (state.equals("left")){
      image(sprites[2],x-spriteWidth/2,y-spriteHeight/2); // draw the sprite that's tilted to the left centered at (x,y)
    } else {
      image(sprites[0],x-spriteWidth/2,y-spriteHeight/2); // otherwise draw the non-tilted sprite centered at (x,y)
    }
  }
  
  // method for updating the ship's position
  void moveShip(){
    // if the state of the ship is "right"
    if (state.equals("right")){
      x+=speed; // increase its x position by speed
    // if the state of the ship is "left"
    } else if (state.equals("left")){
      x-=speed; // decrease its x position by speed
    }
  }
  
  // method for getting the x coordinate of the ship
  float getX(){
    return x;
  }
  
  // method for getting the y coordinate of the ship
  float getY(){
    return y;
  }
  
  // method for getting the size of the ship's hitbox
  float getSize(){
    return size;
  }
  
  // method for gettingthe state of the ship
  String getState(){
    return state;
  }
  
  // method for setting the state of the ship
  // @param state -> desired state of the ship
  void setState(String state){
    this.state = state;
  }
}
