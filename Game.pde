import java.util.*;

int mode; // for switching between different states of the game

PImage ship;

Background background;
Ship player;
ArrayList<Bullet> bullets;
int countB; // for delay between bullets
ArrayList<Rock> rocks;
int countR; // for delay between rocks
ArrayList<Explosion> explosions;
ArrayList<PowerUp> powerUps;
int score;

// images for the 3 rock variants
// and their scaled up versions
PImage rock1;
PImage rock1Big;
PImage rock2;
PImage rock2Big;
PImage rock3;
PImage rock3Big;

PImage bullet;
PImage explosion1;
PImage explosion2; // scaled up version of explosion1
PImage title;

// images for the 3 power up variations
PImage tripleShot;
PImage increasedFireRate;
PImage biggerRocks;

PFont font1;
PFont font2;

float fadeInstructions; // changing alpha value for instructions
boolean increasingInstructions; // used to determine if the instructions should be fading in or out

float fadeScore; // changing alpha value for score
boolean increasingScore; // used to determine if the score should be fading in or out
boolean blinking; // used to determine if the score should be blinking
int blinkCount; // counts the number of times the score has faded in and out
int prevScore; // stores what the score was the last time it blinked

boolean tripleShotActive;
int tripleShotTimer;

boolean fireRateActive;
int fireRateTimer;

boolean biggerRocksActive;
int biggerRocksTimer;

String name;
boolean nameEntered; // for when a name has been entered
ArrayList<String> names;
ArrayList<Integer> scores;
int pause; // time delay between having just died to when the leaderboard shows
int fadeLeaderboard; // changing alpha value for leaderboard

int fadeRestart; // changing alpha value for restart text
boolean increasingRestart; // used to determine if the restart text should be fading in or out

void setup(){
  size(375,750,P2D);
  mode = 1;
  
  ship = loadImage("Ships.png");
  ship.resize(263, 0);
  
  background = new Background();
  player = new Ship(width/2, height*0.85, 5, 50, "stationary", ship);
  bullets = new ArrayList<Bullet>();
  countB = 0;
  rocks = new ArrayList<Rock>();
  countR = 0;
  explosions = new ArrayList<Explosion>();
  powerUps = new ArrayList<PowerUp>();
  score = 0;
  
  rock1 = loadImage("Rocks-1.png");
  rock2 = loadImage("Rocks-2.png");
  rock3 = loadImage("Rocks-3.png");
  
  rock1Big = loadImage("Rocks-1.png");
  rock1Big.resize(0,112);
  rock2Big = loadImage("Rocks-2.png");
  rock2Big.resize(0,112);
  rock3Big = loadImage("Rocks-3.png");
  rock3Big.resize(0,112);
  
  bullet = loadImage("Bullet.png");
  bullet.resize(21, 0);
  explosion1 = loadImage("Explosion.png");
  explosion1.resize(1281,0);
  explosion2 = loadImage("Explosion.png");
  explosion2.resize(2135,0);
  title = loadImage("Title.png");
  title.resize(236,0);
  tripleShot = loadImage("Triple-Shot.png");
  tripleShot.resize(0,50);
  increasedFireRate = loadImage("Increased-Fire-Rate.png");
  increasedFireRate.resize(0,50);
  biggerRocks = loadImage("Bigger-Rocks.png");
  biggerRocks.resize(0,50);
  
  font1 = createFont("small_bold_pixel-7.ttf", 24);
  font2 = createFont("Minercraftory.ttf",35);
  textAlign(CENTER, CENTER);
  
  fadeInstructions = 255;
  increasingInstructions = false;
  
  fadeScore = 255;
  increasingScore = false;
  blinking = false;
  blinkCount = 0;
  prevScore = 0;
  
  tripleShotActive = false;
  tripleShotTimer = 0;
  
  fireRateActive = false;
  fireRateTimer = 0;
  
  biggerRocksActive = false;
  biggerRocksTimer = 0;
  
  name = "";
  nameEntered = false;
  names = new ArrayList<String>();
  scores = new ArrayList<Integer>();
  pause = 120; // have the pause be 2 seconds long
  fadeLeaderboard = 0;
  
  fadeRestart = 255;
  increasingRestart = false;
}

void draw(){
  background.drawBackground(2); // draw the background with delay 2
  textAlign(CENTER, CENTER);
  
  if (mode == 1){
    player.drawShip(); // draw the ship
    image(title,width/2-title.width/2,height*0.1); // draw the title
    
    blinkingInstructions(); // draw the instructions and have them blink
  } else if (mode == 2){
    player.drawShip(); // draw the ship
    // if the increased fire rate power up is active
    if (fireRateActive){
      // if the timer associated with it is greater than 0
      if (fireRateTimer > 0){
        fireBullets(10,10); // fire bullets with half the normal delay
        fireRateTimer -= 1; // decrease the timer by 1
      } else {
        fireRateActive = false; // otherwise deactivate the power up
      }
    } else {
      fireBullets(20,10); // otherwise fire bullets with the normal delay
    }
    
    moveShip(); // move the ship
    fallingRocks(20,10); // have rocks and power ups fall
    rockBulletCollision(); // handle any collisions between a rock and a bullet
    rockShipCollision(); // handle any collisions between a rock and the ship
    powerUpShipCollision(); // handle any collisisons between a power up and the ship
    
    drawExplosions(); // draw any explosions
    blinkingScore(); // draw the score
  } else if (mode == 3){
    fallingRocks(20,10); // have rocks and power ups fall
    drawExplosions(); // draw any explosions
    drawLeaderboard(); // draw the leaderboard
  }
}

void keyPressed(){
  // if the game is not in its death state
  if (mode != 3){
    // if the "d" key is pressed
    if (key == 'd' || key == 'D'){
      player.setState("right"); // set the player's state to "right"
      // if the game is on its starting screen
      if (mode == 1){
        mode = 2; // start the game
      }
    // if the "a" key is pressed
    } else if (key == 'a' || key == 'A'){
      player.setState("left"); // set the player's state to "left"
      // if the game is on its starting screen
      if (mode == 1){
        mode = 2; // start the game
      }
    }
  // otherwise
  } else {
    // if a name has been entered
    if (nameEntered){
      // if the "r" key is pressed
      if (key == 'r' || key == 'R'){
        // restart the game
        player = new Ship(width/2, height*0.85, 5, 50, "stationary", ship);
        bullets = new ArrayList<Bullet>();
        countB = 0;
        rocks = new ArrayList<Rock>();
        countR = 0;
        explosions = new ArrayList<Explosion>();
        score = 0;
        mode = 1;
        fadeInstructions = 255;
        increasingInstructions = false;
        fadeScore = 255;
        increasingScore = false;
        blinking = false;
        blinkCount = 0;
        prevScore = 0;
        tripleShotActive = false;
        tripleShotTimer = 0;
        fireRateActive = false;
        fireRateTimer = 0;
        biggerRocksActive = false;
        biggerRocksTimer = 0;
        powerUps = new ArrayList<PowerUp>();
        nameEntered = false;
        pause = 120;
        fadeLeaderboard = 0;
        fadeRestart = 255;
        increasingRestart = false;
      }
    // otherwise if the leaderboard has fully loaded in
    } else if (fadeLeaderboard == 127) {
      // if the "BACKSPACE" key is pressed
      if (key == BACKSPACE){
        // if the name is currently more than 0 characters long
        if (name.length()>0){
          name = name.substring(0, name.length()-1); // remove the last character
        }
      // if the "ENTER" key is pressed
      } else if (key == ENTER){
        names.add(name.toLowerCase().trim()); // add the name to the list of names (in lower case with the trailing space removed if there is one)
        scores.add(score); // add the score to the list of scores
        // sort the lists from highest score to lowest score
        for (int i=0; i<names.size()-1; i++){
          int highestScore = -10000;
          String highestName = "";
          int index = 0;
          for (int j=i; j<names.size(); j++){
            if (scores.get(j)>highestScore){
              highestScore = scores.get(j);
              highestName = names.get(j);
              index = j;
            }
          }
          String n = names.get(i);
          int s = scores.get(i);
          names.set(i,highestName);
          scores.set(i,highestScore);
          names.set(index,n);
          scores.set(index,s);
        }
        nameEntered = true; // name has been entered
        name = ""; // reset the name variable
      // if a letter key is pressed
      } else if ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
        // if the name is currently less than 14 characters long
        if (name.length()<14){
          name += key; // add the letter to the name
        }
      // if the spacebar is pressed
      } else if (key == ' '){
        // if the name is currently less than 14 and greater than 0 characters long
        if (name.length()<14 && name.length()>0){
          // if the character at the end of the name is a letter
          if (Character.isLetter(name.charAt(name.length()-1))){
            name += key; // add the space to the name
          }
        }
      }
    }
  }
}

// method for drawing the leaderboard
void drawLeaderboard(){
  // if 2 seconds has passed since death
  if (pause<=0){
    // if the alpha value of the leaderboard is less than 127
    if (fadeLeaderboard<127){
      fadeLeaderboard += 5; // increase it by 5
    } else {
      fadeLeaderboard = 127; // otherwise set it equal to 127
    }
    // draw the frame of the leaderboard and have it be black
    fill(0, fadeLeaderboard);
    stroke(0, fadeLeaderboard);
    rect(62,115,251,500);
    rect(62,630,251,50);
    fill(0.9*255, fadeLeaderboard*2); // have the text be close to white
    textFont(font1);
    // if a name hasn't been entered
    if (!nameEntered){
      // have the text in the bottom box be "Enter Name :"
      // and have it be left aligned
      textAlign(LEFT);
      text("Enter Name :", 82, 660);
    } else {
      // otherwise have the text be blinking restart text
      blinkingRestart();
      fill(0.9*255, fadeLeaderboard*2);
    }
    // draw the name in the bottom box and have it be right aligned
    textAlign(RIGHT);
    text(name, 293, 660);
    
    // loop through all of the names and scores and display them
    int count = 0;
    for (String n : names){
      if (count<10){
        textAlign(LEFT);
        text(n, 82, 145+count*50);
        count++;
      } else {
        break;
      }
    }
    count = 0;
    for (int s : scores){
      if (count<10){
        textAlign(RIGHT);
        text(s, 293, 145+count*50);
        count++;
      } else {
        break;
      }
    }
    // if less than 10 scores have been submitted,
    // fill all empty spaces with "--"
    while (count<10){
      textAlign(LEFT);
      text("--", 82, 145+count*50);
      textAlign(RIGHT);
      text("--", 293, 145+count*50);
      count++;
    }
    
    // draw title text for the leaderboard
    // and have it be red
    fill(168,21,30,fadeLeaderboard*2);
    textFont(font2);
    textAlign(CENTER, CENTER);
    text("TOP 10", width/2, height*0.1+4);
    fill(217,51,52,fadeLeaderboard*2);
    text("TOP 10", width/2, height*0.1);
  } else {
    pause -= 1; // otherwise decrease the remaining time by 1
  }
}

// method for drawing the explosions
void drawExplosions(){
  ArrayList<Explosion> explosionsTemp = new ArrayList<Explosion>(); // temporary array list to store all of the explosions that need to be removed
  // loop through all of the explosions that need to be drawn
  for (Explosion e : explosions){
    e.drawExplosion(2); // draw the explosions
    // if the explosion has reached its final frame
    if (e.getCurrentSprite() >= 14){
      explosionsTemp.add(e); // add the explosion to the list of explosions that need to be removed
    }
  }
  // loop through the explosions that need to be removed
  for (Explosion e : explosionsTemp){
    explosions.remove(e); // remove it from the list of explosions
  }
}

// method for drawing blinking instructions
void blinkingInstructions(){
  fill(0.9*255, fadeInstructions); // have the text be close to white
  
  // if the text needs to fade out
  if (!increasingInstructions){
    fadeInstructions -= 5; // decrease the alpha value of the text by 5
  } else {
    fadeInstructions += 5; // otherwise increase the alpha value of the text by 5
  }
  // if the text has faded in completely
  if (fadeInstructions == 255){
    increasingInstructions = false; // have the text fade out
  // if the text has faded out completely
  } else if (fadeInstructions == 0){
    increasingInstructions = true; // have the text fade in
  }
  
  // draw the text
  textFont(font1);
  text("Press", width/2, height/2);
  text("'a'    or    'd'", width/2, height/2+25);
}

// method for drawing blinking restart text
void blinkingRestart(){
  // if the leaderboard has fully loaded in
  if (fadeLeaderboard == 127){
    fill(0.9*255, fadeRestart); // have the text be close to white
    
    // if the text needs to fade out
    if (!increasingRestart){
      fadeRestart -= 5; // decrease the alpha value of the text by 5
    } else {
      fadeRestart += 5; // otherwise increase the alpha value of the text by 5
    }
    // if the text has faded in completely
    if (fadeRestart == 255){
      increasingRestart = false; // have the text fade out
    // if the text has faded out completely
    } else if (fadeRestart == 0){
      increasingRestart = true; // have the text fade in
    }
  }
  
  // draw the text
  textAlign(CENTER);
  text("Press 'R' to restart", width/2, 660);
}

// method for drawing the score
void blinkingScore(){
  // draw the score and have it be red
  fill(168,21,30,fadeScore);
  textFont(font2);
  text(score, width/2, height*0.1+4);
  fill(217,51,52,fadeScore);
  text(score, width/2, height*0.1);
  
  // if the score is a multiple of 250 and is not equal to 0
  if (score%250 == 0 && score != 0){
    // if the score is different to the previous score that met the last condition
    if (score != prevScore){
      blinking = true; // have the score blink
    }
    prevScore = score; // set the previous score equal to the current score
  }
  // if the score needs to blink
  if (blinking){
    // if it needs to fade out
    if (!increasingScore){
      fadeScore -= 10; // decrease the alpha value of the score by 10
    } else {
      fadeScore += 10; // otherwise increase the alpha value of the score by 10
    }
    // if the score has faded in completely
    if (fadeScore >= 255){
      increasingScore = false; // have the score fade out
      blinkCount++; // increase the number of times the score has blinked by 1
    // if the score has faded out completely
    } else if (fadeScore <= 0){
      increasingScore = true; // have the score fade in
    }
  }
  // if the score has blinked 3 times
  if (blinkCount>=3){
    // stop the score from blinking and reset
    fadeScore = 255;
    blinking = false;
    blinkCount = 0;
  }
}

// method for firing bullets
// @param delay -> adds a delay of delay/60 seconds between shots
// @param speed -> moves the bullet upwards at speed*60 pixels per second
void fireBullets(int delay, float speed){
  // if the triple shot power up is active
  if (tripleShotActive){
    // if the timer associated with it is greater than 0
    if (tripleShotTimer > 0){
      tripleShotTimer -= 1; // decrease the timer by one
    }
  }
  countB++;
  if (countB>=delay){
    bullets.add(new Bullet(player.getX(), player.getY()-40, speed, 7, 10, bullet)); // add a bullet to the list of bullets after the specified delay
    // if the triple shot power up is active
    if (tripleShotActive){
      // if the timer associated with it is greater than 0
      if (tripleShotTimer > 0){
        // add two additional bullets to the list of bullets
        bullets.add(new Bullet(player.getX()+15, player.getY()-50, speed, 7, 10, bullet));
        bullets.add(new Bullet(player.getX()-15, player.getY()-50, speed, 7, 10, bullet));
      } else {
        tripleShotActive = false; // otherwise deactivate the power up
      }
    }
    countB = 0;
  }
  // if the list of bullets isn't empty
  if (!bullets.isEmpty()){
    // if the bullet at the front of the list is outside of the screen
    if (bullets.get(0).getY()<-bullets.get(0).getSizeY()/2){
      bullets.remove(0); // remove the bullet from the list
    }
    // loop through list of bullets
    for (Bullet b : bullets){
      b.drawBullet(); // draw the bullet
      b.moveBullet(); // move the bullet
    }
  }
}

// method for moving the ship
void moveShip(){
  // if the player's moving to the right and is at the right edge of the screen
  if (player.getState().equals("right") && player.getX()>=width){
    player.setState("stationary"); // set its state to "stationary"
  // if the player's moving to the left and is at the left edge of the screen
  } else if (player.getState().equals("left") && player.getX()<=0){
    player.setState("stationary"); // set its state to "stationary"
  }
  player.moveShip(); // move the ship
}

// method for making rocks and power ups fall
// @param delay -> adds a delay of delay/60 seconds between objects
// @param speed -> moves the objects downwards at speed*60 pixels per second
void fallingRocks(int delay, float speed){
  // if the bigger rocks power up is active
  if (biggerRocksActive){
    biggerRocksTimer -= 1; // decrease the timer associated with it by 1
    // if the timer is less than or equal to 0
    if (biggerRocksTimer <= 0){
      biggerRocksActive = false; // deactivate the power up
    }
  }
  countR++;
  if (countR>=delay){
    int powerUpRate = int (random(0,50)); // have the chance of a power up dropping be 1/50
    // if a power up isn't meant to be dropped
    if (powerUpRate != 0){
      // randomly drop one of the 3 rock variants
      int random = int (random(0,3));
      if (random == 0){
        // if the bigger rocks power up is active
        if (biggerRocksActive){
          int random2 = int (random(0,3)); // have the chance of big rock dropping be 1/3
          // if a big rock is meant to be dropped
          if (random2 == 0){
            rocks.add(new Rock((float) Math.random()*width, -40, speed, 80, rock1Big)); // add a big rock to the list of rocks after the specified delay
          } else {
            rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock1)); // otherwise add a normal rock
          }
        } else {
          rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock1)); // otherwise add a normal rock to the list of rocks
        }
      // SAME THING FOR THE OTHER 2 VARIANTS
      } else if (random == 1){
        if (biggerRocksActive){
          int random2 = int (random(0,3));
          if (random2 == 0){
            rocks.add(new Rock((float) Math.random()*width, -40, speed, 80, rock2Big));
          } else {
            rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock2));
          }
        } else {
          rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock2));
        }
      } else {
        if (biggerRocksActive){
          int random2 = int (random(0,3));
          if (random2 == 0){
            rocks.add(new Rock((float) Math.random()*width, -40, speed, 80, rock3Big));
          } else {
            rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock3));
          }
        } else {
          rocks.add(new Rock((float) Math.random()*width, -25, speed, 50, rock3));
        }
      }
      countR = 0;
    // if a power up is meant to be dropped
    } else {
      // randomly pick between the 3 different power ups to drop
      // and add them to the list of power ups after the specified delay
      int random = int (random(0,3));
      if (random == 0){
        powerUps.add(new PowerUp((float) Math.random()*width, -15, speed, 30, tripleShot, "triple-shot"));
      } else if (random == 1){
        powerUps.add(new PowerUp((float) Math.random()*width, -15, speed, 30, increasedFireRate, "increased-fire-rate"));
      } else {
        powerUps.add(new PowerUp((float) Math.random()*width, -15, speed, 30, biggerRocks, "bigger-rocks"));
      }
      countR = 0;
    }
  }
  // if the list of rocks isn't empty
  if (!rocks.isEmpty()){
    // if the rock at the front of the list is outside of the screen
    if (rocks.get(0).getY()>height+rocks.get(0).getSize()/2){
      rocks.remove(0); // remove the rock from the list of rocks
    }
    // loop through the list of rocks
    for (Rock r : rocks){
      r.drawRock(3); // draw the rock
      r.moveRock(); // move the rock
    }
  }
  // if the list of power ups isn't empty
  if (!powerUps.isEmpty()){
    // if the power up at the front of the list is outside of the screen
    if (powerUps.get(0).getY()>height+powerUps.get(0).getSize()/2){
      powerUps.remove(0); // remove the power up from the list of power ups
    }
    // loop through the list of power ups
    for (PowerUp p : powerUps){
      p.drawPowerUp(); // draw the power up
      p.movePowerUp(); // move the power up
    }
  }
}

// method for dealing with the collisions between a rock and a bullet
void rockBulletCollision(){
  ArrayList<Bullet> bulletsToRemove = new ArrayList<Bullet>(); // temporary list of bullets to remove
  ArrayList<Rock> rocksToRemove = new ArrayList<Rock>(); // temporary list of rocks to remove
  
  // loop through the list of bullets
  for (Bullet b : bullets){
    // loop through the list of rocks
    for (Rock r : rocks){
      // get the hitbox of the bullet
      float bSizeX = b.getSizeX();
      float bSizeY = b.getSizeY();
      float bRectX = b.getX()-bSizeX/2;
      float bRectY = b.getY()-bSizeY/2;
      
      // get the hitbox of the rock
      float rSize = r.getSize();
      float rRectX = r.getX()-rSize/2;
      float rRectY = r.getY()-rSize/2;
      
      // if the hitboxes overlap
      if (bRectX < rRectX + rSize &&
          bRectX + bSizeX > rRectX &&
          bRectY < rRectY + rSize &&
          bRectY + bSizeY > rRectY){
        bulletsToRemove.add(b); // add the bullet to the list of bullets to remove
        // if the rock is normal
        if (rSize == 50){
          rocksToRemove.add(r); // add the rock to the list of rocks to remove
          score+=10; // increase the score by 10
          explosions.add(new Explosion(r.getX(),r.getY(),explosion1)); // add an explosion at the rock's position to the list of explosions
        // if the rock is big
        } else {
          // if the rock has been hit twice
          if (r.getHits()>=2){
            rocksToRemove.add(r); // add the rock to the list of rocks to remove
            score+=30; // increase the score by 30
            explosions.add(new Explosion(r.getX(),r.getY(),explosion2)); // add a big explosion at the rock's position to the list of explosions
          } else {
            r.increaseHits(); // otherwise increase the number of times the rock has been hit
          }
        }
      }
    }
  }
  
  // loop through the list of bullets to remove
  for (Bullet b : bulletsToRemove){
    bullets.remove(b); // remove the bullet from the list of bullets
  }
  // loop through the list of rocks to remove
  for (Rock r : rocksToRemove){
    rocks.remove(r); // remove the rock from the list of rocks
  }
}

// method for dealing with the collision between a rock and the ship
void rockShipCollision(){
  // get the player's hitbox
  float sSize = player.getSize();
  float sRectX = player.getX()-sSize/2;
  float sRectY = player.getY()-sSize/2-11;
  
  // loop through the list of rocks
  for (Rock r : rocks){
    // get the hitbox of the rock
    float rSize = r.getSize();
    float rRectX = r.getX()-rSize/2;
    float rRectY = r.getY()-rSize/2;
    
    // if the hitboxes overlap
    if (sRectX < rRectX + rSize &&
        sRectX + sSize > rRectX &&
        sRectY < rRectY + rSize &&
        sRectY + sSize > rRectY){
      mode = 3; // change the state of the game to the death state
      explosions.add(new Explosion(player.getX(),player.getY(),explosion2)); // add a big explosion at the player's position to the list of explosions
      break; // break out of the loop
    }
  }
}

// method for dealing with the collision between a power up and the ship
void powerUpShipCollision(){
  // get the player's hitbox
  float sSize = player.getSize();
  float sRectX = player.getX()-sSize/2;
  float sRectY = player.getY()-sSize/2-11;
  
  boolean collided = false; // used to determine if a collision has taken place
  PowerUp powerUpToRemove = null; // to store the power up that needs to be removed
  
  // loop through the list of power ups
  for (PowerUp p : powerUps){
    // get the hitbox of the power up
    float pSize = p.getSize();
    float pRectX = p.getX()-pSize/2;
    float pRectY = p.getY()-pSize/2;
    
    // if the hitboxes overlap
    if (sRectX < pRectX + pSize &&
        sRectX + sSize > pRectX &&
        sRectY < pRectY + pSize &&
        sRectY + sSize > pRectY){
      collided = true; // collision has taken place
      powerUpToRemove = p; // power up has to be removed
      break; // break out of the loop
    }
  }
  
  // if a collision has taken place
  if (collided){
    // activate the power up that collided with the ship and set its timer
    if (powerUpToRemove.getType().equals("triple-shot")){
      tripleShotActive = true;
      tripleShotTimer = 300;
    } else if (powerUpToRemove.getType().equals("increased-fire-rate")){
      fireRateActive = true;
      fireRateTimer = 300;
    } else {
      biggerRocksActive = true;
      biggerRocksTimer = 600;
    }
    powerUps.remove(powerUpToRemove); // remove the power up from the list of power ups
  }
}
