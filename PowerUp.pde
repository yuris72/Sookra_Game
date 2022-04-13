// power up object class
class PowerUp{
  float x; // x position of the power up
  float y; // y position of the power up
  float speed; // power up speed
  float size; // size of power up hitbox
  
  PImage image; // power up image
  
  String type; // type of power up
  
  PowerUp(float x, float y, float speed, float size, PImage image, String type){
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.size = size;
    
    this.image = image;
    
    this.type = type;
  }
  
  // method for displaying the power up
  void drawPowerUp(){
    image(image, x-image.width/2, y-image.height/2); // draws it so that it's centered at (x,y)
  }
  
  // method for updating the power up's position
  void movePowerUp(){
    y+=speed; // increase its y position by speed
  }
  
  // method for getting the x coordinate of the power up
  float getX(){
    return x;
  }
  
  // method for getting the y coordinate of the power up
  float getY(){
    return y;
  }
  
  // method for getting the size of the power up's hitbox
  float getSize(){
    return size;
  }
  
  // method for getting the power up's type
  String getType(){
    return type;
  }
}
