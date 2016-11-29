import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;
import java.util.*;
import controlP5.*;
import processing.video.*;
import processing.sound.*;

ControlP5 searchInput;
Movie intro;
SoundFile pop;

ConfigurationBuilder cb = new ConfigurationBuilder();
Twitter twitterInstance;
Query twitterQuery;

XML xml;
PImage icon;
boolean looping = true;
boolean onload = true;
boolean loading = false;
boolean blackout = true;
boolean searching = false;
boolean notification = false;
boolean error = false;
String consumerKey;
String consumerSecret;
String accessToken;
String accessTokenSecret;
String query;
String currentQuery;
ArrayList tweets;
ArrayList<String> url = new ArrayList<String>();
ArrayList<PImage> pic = new ArrayList<PImage>();
int alpha = 250;
int seconds = 1;
int imgX = 0;
int imgY = 0;
int counter = 0;

void setup() {
  
  size(1250, 850);
  background(85, 172, 238);
  frameRate(2);
  
  PFont font = createFont("arial", 40);
  
  searchInput = new ControlP5(this);
  
  int y = 20;
  int spacing = 60;
  searchInput.addTextfield("Enter #")
             .setPosition(465, 770)
             .setSize(500, 60)
             .setFont(font)
             .setFocus(true)
             .setColor(color(0))
             .setColorBackground(color(255))
             .getCaptionLabel()
             .align(ControlP5.LEFT_OUTSIDE, CENTER)
             .getStyle().setPaddingLeft(-20);
  y += spacing;
  textFont(font);
  
  intro = new Movie(this, "intro.mp4");
  intro.loop();
  
  icon = loadImage("icon.png");
  
  pop = new SoundFile(this, "pop.wav");
  
  xml = loadXML("credentials.xml");
  XML[] credentials = xml.getChildren("oauth");
  
  for (int i = 0; i < credentials.length; i++) {
    consumerKey = credentials[i].getString("consumerKey");
    consumerSecret = credentials[i].getString("consumerSecret");
    accessToken = credentials[i].getString("accessToken");
    accessTokenSecret = credentials[i].getString("accessTokenSecret");
  }
  
  //Credentials
  cb.setDebugEnabled(true);
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessTokenSecret);
  cb.setIncludeEntitiesEnabled(true);

  twitterInstance = new TwitterFactory(cb.build()).getInstance();
  
  thread("refreshTweets");
  
}

void draw() {
  if (loading) {
    if (mouseX < 250) {
      frameRate(1);
    } else if (mouseX > 250 && mouseX < 500) {
      frameRate(2);
    } else if (mouseX > 500 && mouseX < 750) {
      frameRate(3);
    } else if (mouseX > 750 && mouseX < 1000) {
      frameRate(4);
    }  else {
      frameRate(5);
    }
    if (blackout) {
      fill(0, alpha);
      noStroke();
      rect(0, 0, 1250, 750);
      blackout = false;
    }
    drawTweets();
  } else if (searching) {
    if (error) {
      fill(255);
      textAlign(CENTER, CENTER);
      text("Search returned no images.", 0, 675, 1250, 60);
      error = false;
      searching = false;
      loading = true;
    }
    if (notification) {
      fill(255);
      textAlign(CENTER, CENTER);
      text("Please wait until current search completes.", 0, 675, 1250, 60);
      notification = false;
    }
    frameRate(1);
    pop.play();
    pop.rate(1.50);
    fill(0, alpha);
    alpha-=250;
    noStroke();
    rect(0, 0, 1250, 750);
    fill(85, 172, 238);
    rect(575.5, 412.5, 100, 50);
    image(icon, 575, 200, 100, 100);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Searching Twitter\nfor #" + query + " Images\n" + seconds +"s", 0, 125, 1250, 500);
    seconds++;
    blackout = true;
  } else if (onload) {
    if (query != null) {
      fill(85, 172, 238);
      noStroke();
      rect(0, 0, 1250, 750);
      onload = false;
      searching = true;
    } else {
      frameRate(30);
      image(intro, 0, 0, 1333, 750);
      image(icon, 575, 225, 100, 100);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Start Searching Twitter\nfor #tagged Images", 0, 125, 1250, 500);
    }
  }
}

void drawTweets() {
  if (!query.equals(currentQuery)) {
    println(query + currentQuery);
    url.clear();
    pic.clear();
    counter = 0;
    imgX = 0;
    imgY = 0;
    seconds = 1;
    loading = false;
    searching = true;
    alpha = 250;
  } else if (pic.size() != 0) {
    if (counter >= pic.size()) {
      counter = 0;
    }
    if (imgX > 1000) {
      imgX = 0;
      imgY += 250;
    }
    if (imgY >= 750) {
      imgX = 0;
      imgY = 0;
    }
    fill(0, 25);
    noStroke();
    rect(0, 0, 1250, 750);
    image(pic.get(counter), imgX, imgY, 250, 250);
    imgX += 250;
    counter++;
  }
}

void fetchTweets() {
  try {
    currentQuery = query;
    twitterQuery = new Query("#" + currentQuery + " AND filter:images");
    twitterQuery.setCount(100);
    QueryResult result = twitterInstance.search(twitterQuery);
    tweets = (ArrayList) result.getTweets();
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      MediaEntity[] media = t.getMediaEntities();
      for(MediaEntity m : media) { //search trough your entities
        url.add(m.getMediaURL());
      }
    }
    removeDuplicates();
  } catch (TwitterException te) {
    println("Couldn't connect: " + te);
  } // end of catch TwitterException
 } //// end of tweets()

void removeDuplicates() {
  Set<String> removeDuplicates = new LinkedHashSet<String>(url);
  url.clear();
  url.addAll(removeDuplicates);
  for (int i = 0; i < url.size(); i++) {
    pic.add(loadImage(url.get(i)));
  }
  if (pic.size() != 0) {
    loading = true;
    searching = false;
    alpha = 250;
  } else {
    error = true;
  }
}

void refreshTweets() {
  while(looping) {
    if (query != null) {
      url.clear();
      pic.clear();
      println("Searching Tweets");
      fetchTweets();
      delay(15000);
    } else {
      delay(1000);
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    if(!searching) {
      query = theEvent.getStringValue().replaceAll("[^A-Za-z0-9]", "");
      println(query);
    } else {
      notification = true;
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}