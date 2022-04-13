// bullet object class
class Bullet{
  float x; // x position of the bullet
  float y; // y position of the bullet
  float speed; // bullet speed
  float sizeX; // width of bullet hitbox
  float sizeY; // height of bullet hitbox
  
  PImage image; // bullet image
  
  Bullet(float x, float y, float speed, float sizeX, float sizeY, PImage image){
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    
    this.image = image;
  }
  
  // method for displaying the bullet
  void drawBullet(){
    image(image, x-image.width/2, y-image.height/2); // draws it so that it's centered at (x,y)
  }
  
  // method for updating the bullet's position
  void moveBullet(){
    y-=speed; // decrease its y position by speed
  }
  
  // method for getting the x coordinate of the bullet
  float getX(){
    return x;
  }
  
  // method for getting the y coordinate of the bullet
  float getY(){
    return y;
  }
  
  // method for getting the width of the bullet's hitbox
  float getSizeX(){
    return sizeX;
  }
  
  // method for getting the height of the bullet's hitbox
  float getSizeY(){
    return sizeY;
  }
}
