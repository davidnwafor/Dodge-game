import ddf.minim.analysis.*; // SoundFile
import ddf.minim.*;
Minim minim;
AudioPlayer music; // Background music
AudioPlayer menu; // Menu music
AudioPlayer won; // Winning music
AudioPlayer lose; // Lost music

PImage scene; // storing background image
int timer = 0; // timer
int mode = 0; // game mode
boolean startGame = true; // used for switching music
boolean inMenu = true;

float sx = 455; // start x location of sqaure
float sy = 800; // start y location of square
float sw = 90; // width of square
float sh = 90; // height of square

float cx1 = 60; // start x location of circle1
float cy1 = 100; // start y location of circle1
float r1 = 50; // radius of circle1
float speed1 = 7.5; // initial speed of circle1

float cx2 = 375; // start x location of circle2
float cy2 = 100; // start y location of circle2
float r2 = 50; // radius of circle2

float cx3 = 625; // start x location of circle3
float cy3 = 100; // start y location of circle3
float r3 = 50; // radius of circle3

float cx4 = 940; // start x location of circle4
float cy4 = 100; // start y location of circle4
float r4 = 50; // radius of circle4

void setup()
{
  size(1000,1000); // set up background size
  
  minim = new Minim(this); // Load background music and play
  music = minim.loadFile("theme.wav");
  won = minim.loadFile("win.wav");
  lose = minim.loadFile("lost.wav");
  menu = minim.loadFile("opening.wav");
  menu.play();
  
  scene = loadImage("backdrop.png"); // Load background image
}

void draw()
{
  background(scene); //refresh background every frame
  timer = millis(); // start timer
  if (mode == 0)
  {
    fill(0,0,0);
    rect(140,300,720,350); // makes text easier to read
    // Text information
    textSize(48);
    textAlign(CENTER);
    fill(255,255,255);
    text("Dodge the red circles!\nUse A and D to move!\nDon't touch the sides of the screen!",width/2,(height/2) - 100);
    
    if (timer > 5000)
     {
       if (inMenu) // check if menu theme is playing
       {
         menu.rewind();
         menu.pause();
         inMenu = false;
       }
       if (startGame)
       {
          music.play();
          startGame = false;
       }
       mode = 1;
     }
  }
    
  if (mode == 1) // if game is playable
  { 
    
    fill(0,255,0); // fill green
    rect(sx,sy,sw,sh); // draw square
  
    // Move square
    if (keyPressed == true)
    {
      if (key == 'a' || key == 'A')
      {
        sx = sx - 5;
      }
      if (key == 'd' || key == 'D')
      {
        sx = sx + 5;
      }
    }
    
    if (sx <= 0 || sx >= 910) // if the player touches the sides
    {
      mode = 3; // they lose
    }
  
    // Red circles
    cy1 = cy1 + speed1; // speed of circle1
    fill(255,0,0); // fill red
    ellipse(cx1,cy1,r1*2,r1*2); // draw circle1
    
    cy2 = cy2 + speed1; // animate circle2
    fill(255,0,0); // fill red
    ellipse(cx2,cy2,r2*2,r2*2); // draw circle2
    
    cy3 = cy3 + speed1; // speed of circle3
    fill(255,0,0); // fill red
    ellipse(cx3,cy3,r3*2,r3*2); // draw circle3
    
    cy4 = cy4 + speed1; // speed of circle4
    fill(255,0,0); // fill red
    ellipse(cx4,cy4,r4*2,r4*2); // draw circle4
  
    if (cy1 > 1101) // if circle1 has passed screen
    {
      float relocate1 = random(60,200); // reposition its x location
      cx1 = relocate1;
      cy1 = 100;
    }
    
    if (cy2 > 1101) // if circle2 has passed screen
    {
      float relocate2 = random(300,450); // reposition its x location
      cx2 = relocate2;
      cy2 = 100;
    }
    
    if (cy3 > 1101) // if circle3 has passed screen
    {
      float relocate3 = random(550,700); // reposition its x location
      cx3 = relocate3;
      cy3 = 100;
    }
    
    if (cy4 > 1101) // if circle4 passes screen
    {
      float relocate4 = random(800,940); // reposition its x location
      cx4 = relocate4;
      cy4 = 100;
    }
    
    boolean hit1 = check(cx1,cy1,r1,sx,sy,sw,sh);
    if (hit1)
    {
      mode = 3;
    }
    boolean hit2 = check(cx2,cy2,r2,sx,sy,sw,sh);
    if (hit2)
    {
      mode = 3;
    }
    boolean hit3 = check(cx3,cy3,r3,sx,sy,sw,sh);
    if (hit3)
    {
      mode = 3;
    }
    boolean hit4 = check(cx4,cy4,r4,sx,sy,sw,sh);
    if (hit4)
    {
      mode = 3;
    }
    if (65 - (timer/1000) < 1) // when two minutes are up
    {
      if (hit1 == false && hit2 == false && hit3 == false && hit4 == false)
      {
        mode = 2; // you win
      }
    }
    // timer information
    fill(255,255,255);
    textSize(38);
    textAlign(LEFT);
    text("Time Remaining: " + (65 - (timer/1000)),20,42);
   }
   if (mode == 2) // if user wins
   {
     if (startGame == false)
     {
       music.rewind();
       music.pause();
       won.play();
       startGame = true;
     }
     textSize(160);
     textAlign(CENTER);
     fill(255,255,255);
     text("YOU WIN!",width/2,height/2);
     
     textSize(80);
     textAlign(CENTER);
     fill(255,255,255);
     text("Press E to exit",width/2,800);
   }
   if (mode == 3) // if user loses
   {
     if (startGame == false)
     {
       music.rewind();
       music.pause();
       lose.play();
       startGame = true;
     }
     textSize(160);
     textAlign(CENTER);
     fill(255,255,255);
     text("YOU LOSE!",width/2,height/2);
     
     textSize(80);
     textAlign(CENTER);
     fill(255,255,255);
     text("Press E to exit",width/2,800);
   }
}

boolean check(float cx1, float cy1, float r1, float sx, float sy, float sw, float sh)
{
  float testX = cx1; // temporary variables to set edges for testing
  float testY = cy1;
  
  if (cx1 < sx) // test left edge
  {
    testX = sx;
  }
  else if (cx1 > (sx+sw)) // right edge
  {
    testX = sx + sw;
  }
  if (cy1 < sy) // top edge
  {
    testY = sy;
  }
  else if (cy1 > (sy+sh)) // bottom edge
  {
    testY = sy + sh;
  }
  
  float distX = cx1 - testX; // get distance from closest edges
  float distY = cy1 - testY;
  float distance = sqrt((distX*distX) + (distY*distY));
  
  if (distance <= r1)
  {
    return true;
  }
  return false;
}  

void keyPressed() // to leave the game
{
  if (mode == 2 || mode == 3)
  {
    if (key == 'E' || key == 'e')
    {
      exit();
    }
  }
}
