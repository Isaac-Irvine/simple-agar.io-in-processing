// size of world
int worldSizeX = 10000;
int worldSizeY = 10000;

// screen res and center
int screenX = 600;
int screenY = 400;
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

// 0: x, 1: y, 2: r, 3: g, 4: b.
ArrayList<float[]> foods = new ArrayList();

void setup(){
  x = worldSizeX / 2;
  y = worldSizeY / 2;
  size(600, 400);
  makeDots();
}
void makeDots(){
  // makes dots to fill the world
  float area = worldSizeX * worldSizeY;
  for (int i = 0; i < area/4000; i++){
    addNewRandomPoint();
  }
}
void addNewRandomPoint(){
  // randomly makes and places a dot in the world
  float[] food = {random(worldSizeX), random(worldSizeY), random(100, 240), random(100, 240), random(100, 240)};
  foods.add(food);
}
void draw(){
  // runs every frame
  background(0);
  //testKeys();
  move();
  eatCheck();
  calulateSize();
  drawWorld();
  addNewRandomPoint();
  showScore();
}

void calulateSize(){
  // works out size and speed based on mass
  size = sqrt(mass / PI);
  speed = 20 / sqrt(size);
}

void drawWorld(){
  fill(255);
  // world relitive to screen. this keeps the ball in the center of the screen
  worldX = -x + centerX;
  worldY = -y + centerY;
  rect(worldX, worldY, worldSizeX, worldSizeY);
  
  // draw the food
  stroke(0);
  for (float[] food : foods){
    // checking if food would be visable
    if (food[0] + worldX >= -10 && food[0] + worldX - 10 < width && food[1] + worldY >= -10 && food[1] + worldY - 10 < height){
      fill(food[2], food[3], food[4]);
      ellipse(food[0] + worldX, food[1] + worldY, 10, 10);
    }
  }
  /// draws ball
  fill(255,128,128);
  ellipse(worldX + x, worldY + y, size, size);
}
void move(){
  // works out angle of mouse relitive to ball
  float angle = 0;
  angle = atan2(worldY + y - mouseY, worldX + x - mouseX);
  y -= sin(angle) * speed;
  x -= cos(angle) * speed;
}

void eatCheck(){
  // checks if ball is on food, if so it eats it
  
  // food that needs to be removed from list
  ArrayList<float[]> foodsToRemove = new ArrayList();
  
  for (float[] food : foods){
    // if ball covers center of food
    if (sq(food[0] - x) + sq(food[1] - y) < sq(size/2)){
      foodsToRemove.add(food);
      mass += 400;
    }
  }
  // remove all the eaten food
  for (float[] food : foodsToRemove){
    foods.remove(food);
  }
}
void showScore(){
  textSize(20);
  fill(0, 102, 153);
  text("Score: " + mass / 400, 10, height - 10); 
}
// not in use
void testKeys() {
  if(keyPressed){
    if (key == CODED) {
      if (keyCode == UP) {
        y += 10;
      } else if (keyCode == DOWN) {
        y -= 10;
      }
    }
  }
}
