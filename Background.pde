// class for drawing the animated background
class Background{
  final int N_SPRITES_X = 10; // get number of sprites in the x direction
  final int N_SPRITES_Y = 9; // get number of sprites in the y direction
  final int TOTAL_SPRITES = N_SPRITES_X * N_SPRITES_Y; // get total number of sprites
  
  int currentSprite; // index of current sprite
  PImage [] sprites; // array of individual sprite images
  PImage spriteSheet;
  int spriteWidth;
  int spriteHeight;
  
  int count; // used to implement delay
  
  Background(){
    sprites = new PImage[TOTAL_SPRITES]; // set array size equal to total number of sprites
    spriteSheet = loadImage("Background.png");
    spriteWidth = spriteSheet.width/N_SPRITES_X; // calculate width of each sprite
    spriteHeight = spriteSheet.height/N_SPRITES_Y; // calculate height of each sprite
    
    count = 0;
    
    // loop through the sprite sheet and insert each sprite into "sprites"
    int index = 0;
    for (int y=0; y<N_SPRITES_Y; y++){
      for (int x=0; x<N_SPRITES_X; x++){
        sprites[index] = spriteSheet.get(x*spriteWidth, y*spriteHeight, spriteWidth, spriteHeight);
        index++;
      }
    }
  }
  
  // method for displaying the current background sprite
  // @param delay -> adds a delay of delay/60 seconds between sprites
  void drawBackground(int delay){
    image(sprites[currentSprite],0,0); // draws the current sprite at (0,0)
    // set the current sprite to be the next one after the specified delay
    count++;
    if (count == delay){
      count = 0;
      currentSprite++;
    }
    // loop back to the start of the animation
    if (currentSprite == TOTAL_SPRITES){
      currentSprite = 0;
    }
  }
}
