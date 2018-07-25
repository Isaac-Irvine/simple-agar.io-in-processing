// server


// askTypes
// "wantWorld" -- is new to the server and wants a copy of the world
// "eatenFood" and sent foodID -- the food eaten
// "eatBall" and sent ballID -- ball eaten
// "movedTo" and sent ballID, newX and newY -- where the ball is now 
// "sizeChange" and sent ballID and newMass -- the mass of the ball
// "newBall" and sent mass, x and y -- new ball made, wants ID assigned
// "leaving" and sends list of ballIDs -- used for when the client is leaving in order to deleat all there balls

// replyTypes
// "worldData" and sends world size and all the food locations and locations of all the other balls
// "update" and sends food eaten, new food and the location of all the balls and if there is new ones or old ones gone

import processing.net.*;

// size of world
int worldSizeX = 10000;
int worldSizeY = 10000;

// where the top left of the world is relitive to the screen
float worldX, worldY;

// 0: x, 1: y,
ArrayList<float[]> foods = new ArrayList();


Server theServer;

void setup() {
  println("Starting");
  size(200, 200);
  // Starts a myServer on port 5204
  theServer = new Server(this, 8888); 
  makeDots();
}

void draw() {
  // Get the next available client
  Client thisClient = theServer.available();
  // If the client is not null, and says something, display what it said
  if (thisClient !=null) {
    XML whatClientSaid = parseXML(thisClient.readString());
    // making blank
    XML reply = parseXML("<nothing></nothing>");
    if (whatClientSaid != null) {
      String askingFor = whatClientSaid.getString("askType");
      println(askingFor);
      if (askingFor.equals("wantWorld")) {
        println("giving World");
        reply.setString("replayType", "worldData");
        reply = getWorldSummery(reply);
      } else if(askingFor == "eatenFood"){
      
      } else if (askingFor == "eatBall"){
      
      } else if (askingFor == "movedTo"){
      
      } else if (askingFor == "sizeChange"){
      
      } else if (askingFor == "newBall"){
      
      } else if (askingFor == "leaving"){
      
      }
      String replyToSend = reply.toString();
      replyToSend += "{__ The End __}";
      thisClient.write(replyToSend);
    }
  }
  
  // updates
  XML update = getUpdates();
  theServer.write(update.toString());
}

XML getUpdates(){
  return parseXML("<nothing></nothing>");
}

XML getWorldSummery(XML theXML) {
  XML world = theXML.addChild("WorldSize");
  XML worldSize = world.addChild("WorldSize");
  worldSize.setInt("worldSizeX", worldSizeX);
  worldSize.setInt("worldSizeY", worldSizeY);
  XML foodList = world.addChild("food");
  for (float[] food : foods) {
    XML foodListBit = foodList.addChild("food");
    foodListBit.setFloat("x", food[0]);
    foodListBit.setFloat("y", food[1]);
  }
  return theXML;
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
