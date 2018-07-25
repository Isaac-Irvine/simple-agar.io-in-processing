// client

import processing.net.*; 
import processing.serial.*;

// size of world
int worldSizeX = 10000;
int worldSizeY = 10000;

// screen res and center
// must be updated in setup as well
int screenX = 1000;
int screenY = 600;
int centerX = screenX / 2;
int centerY = screenY / 2;

// starting mass (area) of ball
int mass = 400;
// size (radius) of ball. recaulated every frame based on mass
float size = 0;
// speed
float speed = 0;

// ball postion
float x, y;
// where the top left of the world is relitive to the screen
float worldX, worldY;


Client theClient;

// 0: x, 1: y, 2: r, 3: g, 4: b.
ArrayList<float[]> foods = new ArrayList();

// players ball
Ball ball1 = new Ball();

void setup() {
  x = worldSizeX / 2;
  y = worldSizeY / 2;
  size(1000, 600);
  theClient = new Client(this, "localhost", 8888);
  getWorld();
  makeDots();
}
void getWorld() {
  XML worldData = askData("wantWorld");
}

XML askData(String ask){
  XML askXML = parseXML("<nothing></nothing>");
  askXML.setString("askType", ask);
  theClient.write(askXML.toString());
  String dataIn = "";
  while (!dataIn.endsWith("{__ The End __}")) {
    delay(10);
    dataIn += theClient.readString();
  }
  dataIn = dataIn.substring(0,dataIn.length()-15);
  return parseXML(dataIn);
}
void makeDots() {
  // makes dots to fill the world
  float area = worldSizeX * worldSizeY;
  for (int i = 0; i < area/4000; i++) {
    addNewRandomPoint();
  }
}
void addNewRandomPoint() {
  // randomly makes and places a dot in the world
  float[] food = {random(worldSizeX), random(worldSizeY), random(100, 240), random(100, 240), random(100, 240)};
  foods.add(food);
}
void draw() {
  // runs every frame
  background(0);
  //testKeys();

  ball1.moveToMouse();
  ball1.eatCheck();
  drawWorld();
  ball1.drawBall();
  addNewRandomPoint();
  showScore();
}


void drawWorld() {
  fill(255);
  // world relitive to screen. this keeps the ball in the center of the screen
  worldX = -ball1.x + centerX;
  worldY = -ball1.y + centerY;
  stroke(255, 0, 0);
  rect(worldX, worldY, worldSizeX, worldSizeY);

  // draw grid
  float offsetX = (worldX % 40) - width/2;
  float offsetY = (worldY % 40) - height/2;
  stroke(200);
  for (float x = offsetX; x < width; x += 40) {
    line(x, 0, x, height);
  }
  for (float y = offsetY; y < height; y += 40) {
    line(0, y, width, y);
  }

  // draw the food
  stroke(0);
  for (float[] food : foods) {
    // checking if food would be visable
    if (food[0] + worldX >= -10 && food[0] + worldX - 10 < width && food[1] + worldY >= -10 && food[1] + worldY - 10 < height) {
      fill(food[2], food[3], food[4]);
      ellipse(food[0] + worldX, food[1] + worldY, 10, 10);
    }
  }
}

void showScore() {
  textSize(20);
  fill(0, 102, 153);
  text("Score: " + (int)ball1.score, 10, height - 10);
}

// not in use
void testKeys() {
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        y += 10;
      } else if (keyCode == DOWN) {
        y -= 10;
      }
    }
  }
}


class Ball {
  int[] ballColor = {0, 0, 0};
  // starting mass (area) of ball
  int mass = 400;
  // size (radius) of ball. recaulated every time mass changes
  float size;
  // speed
  float speed;
  float score;

  // ball postion
  float x, y;
  Ball() {
    // generate random color
    for (int c = 0; c < 3; c++) ballColor[c] = (int)random(50, 255);
    // calulate size and speed
    addMass(0);
    x = random(worldSizeX);
    y = random(worldSizeY);
  }
  void addMass(float amount) {
    this.mass += amount;
    // works out size and speed based on mass
    this.size = sqrt(mass / PI);
    this.speed = 20 / sqrt(size);
    this.score = round(this.mass / 400);
  }
  void moveToMouse() {
    // works out angle of mouse relitive to ball
    float angle = 0;
    angle = atan2(worldY + y - mouseY, worldX + x - mouseX);

    x += -cos(angle) * speed;
    y += -sin(angle) * speed;


    // make sure you cant go off the end of the world
    if (x - size/2 < 0) {
      x = size/2;
    }
    if (x + size/2 > worldSizeX) {
      x =  worldSizeX - size/2;
    }
    if (y - size/2 < 0) {
      y = size/2;
    }
    if (y + size/2 > worldSizeY) {
      y = worldSizeY - size/2;
    }

    // if ball is bigger than world
    if (size >= min(worldSizeX, worldSizeY)) {
      println("wtf!!");
      size = min(worldSizeX, worldSizeY) - 1;
    }
  }
  void eatCheck() {
    // checks if ball is on food, if so it eats it

    // food that needs to be removed from list
    ArrayList<float[]> foodsToRemove = new ArrayList();

    for (float[] food : foods) {
      // if ball covers center of food
      if (sq(food[0] - x) + sq(food[1] - y) < sq(size/2)) {
        foodsToRemove.add(food);
        this.addMass(400);
      }
    }
    // remove all the eaten food
    for (float[] food : foodsToRemove) {
      foods.remove(food);
    }
  }
  void drawBall() {
    /// draws ball
    if (onScreen()) {
      fill(ballColor[0], ballColor[1], ballColor[2]);
      ellipse(worldX + x, worldY + y, size, size);
    }
  }
  boolean onScreen() {
    // is the ball visable on the screen
    if (worldX + x + size >= 0 && worldX + x - size < width && worldY + y + size >= 0 && worldY + y - size < height) {
      return true;
    } else {
      return false;
    }
  }
}
