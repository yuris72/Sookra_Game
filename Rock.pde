// rock object class
class Rock{
  final int N_SPRITES_X = 30; // get number of sprites in the x direction
  final int N_SPRITES_Y = 1; // get number of sprites in the y direction
  final int TOTAL_SPRITES = N_SPRITES_X * N_SPRITES_Y; // get total number of sprites
  
  int currentSprite; // index of current sprite
  PImage [] sprites; // array of individual sprite images
  PImage spriteSheet;
  int spriteWidth;
  int spriteHeight;
  
  int count; // used to implement delay
  int hits; // records number of times the rock has been hit by a bullet (for large rocks)
  
  float x; // x position of the rock
  float y; // y position of the rock
  float speed; // rock speed
  float size; // size of rock hitbox
  
  Rock(float x, float y, float speed, float size, PImage image){
    sprites = new PImage[TOTAL_SPRITES]; // set array size equal to total number of sprites
    spriteSheet = image;
    spriteWidth = spriteSheet.width/N_SPRITES_X; // calculate width of each sprite
    spriteHeight = spriteSheet.height/N_SPRITES_Y; // calculate height of each sprite
    
    count = 0;
    hits = 0;
    
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
  }
  
  // method for displaying the current rock sprite
  // @param delay -> adds a delay of delay/60 seconds between sprites
  void drawRock(int delay){
    image(sprites[currentSprite],x-spriteWidth/2,y-spriteHeight/2); // draws the current sprite centered at (x,y)
    // if the index of the current sprite is less than the maximum possible index
    if (currentSprite<TOTAL_SPRITES-1){
      // set the current sprite to be the next one after the specified delay
      count++;
      if (count == delay){
        count = 0;
        currentSprite++;
      }
    }
  }
  
  // method for updating the rock's position
  void moveRock(){
    y+=speed; // increase its y position by speed
  }
  
  // method for getting the x coordinate of the rock
  float getX(){
    return x;
  }
  
  // method for getting the y coordinate of the rock
  float getY(){
    return y;
  }
  
  // method for getting the size of the rock's hitbox
  float getSize(){
    return size;
  }
  
  // method for updating how many times the rock has been hit by a bullet
  void increaseHits(){
    hits++; // increases it by one
  }
  
  // method for getting the number of times the rock has been hit by a bullet
  int getHits(){
    return hits;
  }
}
