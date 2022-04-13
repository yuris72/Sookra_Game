// class for drawing animated explosions
class Explosion{
  final int N_SPRITES_X = 14; // get number of sprites in the x direction
  final int N_SPRITES_Y = 1; // get number of sprites in the y direction
  final int TOTAL_SPRITES = N_SPRITES_X * N_SPRITES_Y; // get total number of sprites
  
  int currentSprite; // index of current sprite
  PImage [] sprites; // array of individual sprite images
  PImage spriteSheet;
  int spriteWidth;
  int spriteHeight;
  
  int count; // used to implement delay
  
  float x; // x position of the explosion
  float y; // y position of the explosion
  
  Explosion(float x, float y, PImage image){
    sprites = new PImage[TOTAL_SPRITES]; // set array size equal to total number of sprites
    spriteSheet = image;
    spriteWidth = spriteSheet.width/N_SPRITES_X; // calculate width of each sprite
    spriteHeight = spriteSheet.height/N_SPRITES_Y; // calculate height of each sprite
    
    count = 0;
    
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
  }
  
  // method for displaying the current explosion sprite
  // @param delay -> adds a delay of delay/60 seconds between sprites
  void drawExplosion(int delay){
    image(sprites[currentSprite],x-spriteWidth/2,y-spriteHeight/2); // draws the current sprite centered at (x,y)
    // set the current sprite to be the next one after the specified delay
    count++;
    if (count == delay){
      count = 0;
      currentSprite++;
    }
  }
  
  // method for getting the index of the current sprite
  int getCurrentSprite(){
    return currentSprite;
  }
}
