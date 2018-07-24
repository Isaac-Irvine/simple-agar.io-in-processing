// server


// commands
// "new" -- is new to the server and wants a copy of the world
// "eat [foodID]" -- the food eaten
// "eatBall [ballID]" -- ball eaten
// "move [ballID] [x] [y]" where the ball is now 
// "size [ballID][mass]" the mass of the ball
// "newBall [mass] [x] [y]" new ball made, wants ID assigned

import processing.net.*;

// size of world
int worldSizeX = 10000;
int worldSizeY = 10000;

// where the top left of the world is relitive to the screen
float worldX, worldY;

// 0: x, 1: y,
ArrayList<float[]> foods = new ArrayList();


Server myServer;

void setup() {
  size(200, 200);
  // Starts a myServer on port 5204
  myServer = new Server(this, 5204); 
  makeDots();
  println(getWorldSummery());
}

void draw() {
  // Get the next available client
  Client thisClient = myServer.available();
  // If the client is not null, and says something, display what it said
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if (whatClientSaid != null) {
      if (whatClientSaid == "new") {
        thisClient.write(getWorldSummery());
      } else if(whatClientSaid.substring(0,4) == "eat "){
        
      }
    }
  }
}

String getWorldSummery() {
  XML world = parseXML("<nothing></nothing>");
  XML worldSize = world.addChild("WorldSize");
  worldSize.setInt("worldSizeX", worldSizeX);
  worldSize.setInt("worldSizeY", worldSizeY);
  XML foodList = world.addChild("food");
  for (float[] food : foods) {
    XML foodListBit = foodList.addChild("food");
    foodListBit.setFloat("x", food[0]);
    foodListBit.setFloat("y", food[1]);
  }
  return world.toString();
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
  float[] food = {random(worldSizeX), random(worldSizeY)};
  foods.add(food);
}
