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

ConfigurationBuilder cb = new ConfigurationBuilder();
Twitter twitterInstance;
Query twitterQuery;

ControlP5 searchInput;

boolean onload = true;
boolean loading = false;
boolean blackout = true;
boolean searching = false;
boolean looping = true;
String query;
String currentQuery;
ArrayList tweets;
ArrayList<String> url = new ArrayList<String>();
ArrayList<PImage> pic = new ArrayList<PImage>();
int alpha = 200;
int imgX = 0;
int imgY = 0;
int counter = 0;

void setup() {
  
  size(1000, 1100);
  background(0);
  frameRate(2);
  
  PFont font = createFont("arial", 40);
  
  searchInput = new ControlP5(this);
  
  int y = 20;
  int spacing = 60;
  searchInput.addTextfield("#")
             .setPosition(50,1020)
             .setSize(500,60)
             .setFont(font)
             .setFocus(true)
             .setColor(color(0))
             .setColorBackground(color(255))
             .getCaptionLabel()
             .align(ControlP5.LEFT_OUTSIDE, CENTER)
             .getStyle().setPaddingLeft(-10);
  y += spacing;
  textFont(font);
  
  //Credentials
  cb.setDebugEnabled(true);
  cb.setOAuthConsumerKey("DcUeHEdczixliws57OUri2sYi");
  cb.setOAuthConsumerSecret("5wl1Scpbt4dUM4IASQxrLrGxExeMb1ZE6q95rcMR73BjM4iuDm");
  cb.setOAuthAccessToken("798873694177214465-OQMUPm98frvFQumfbMyLbkmh2B7W2Ls");
  cb.setOAuthAccessTokenSecret("PU422R45tOsPHd1MPfUVvoon9kQxRRT1hy4H7rpxwmNPU");
  cb.setIncludeEntitiesEnabled(true);

  twitterInstance = new TwitterFactory(cb.build()).getInstance();
  
  thread("refreshTweets");
  
}

void draw() {
  if (loading) {
    if (blackout) {
      fill(0);
      rect(0, 0, 1000, 1000);
      blackout = false;
    }
    drawTweets();
  } else if (searching) {
    fill(0, alpha);
    alpha-=200;
    rect(0, 0, 1000, 1000);
    fill(255);
    text("Searching Tweets for #" + query, 250, 250);
    blackout = true;
  } else if (onload) {
    fill(255);
    text("Start Searching Tweets", 250, 250);
    if (query != null) {
      fill(0);
      rect(0, 0, 1000, 1000);
      onload = false;
      searching = true;
    }
  }
}

void drawTweets() {
  if (query != currentQuery) {
    url.clear();
    pic.clear();
    counter = 0;
    imgX = 0;
    imgY = 0;
    loading = false;
    searching = true;
  } else if (pic.size() != 0) {
    if (counter >= pic.size()) {
      counter = 0;
    }
    if (imgX > 900) {
      imgX = 0;
      imgY += 250;
    }
    if (imgY >= 900) {
      imgX = 0;
      imgY = 0;
    }
    fill(0, 25);
    rect(0, 0, 1000, 1000);
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
      //println(t.getMediaEntities());
      MediaEntity[] media = t.getMediaEntities();
      if (media != null) {
        for(MediaEntity m : media) { //search trough your entities
          url.add(m.getMediaURL());
        }
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
  //println(url);
  for (int i = 0; i < url.size(); i++) {
    pic.add(loadImage(url.get(i)));
  }
  loading = true;
  searching = false;
  alpha = 200;
}

void refreshTweets() {
  while(looping) {
    url.clear();
    pic.clear();
    if (query != null) {
      println("Searching Tweets");
      fetchTweets();
      delay(10000);
    } else {
      delay(1000);
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    query = theEvent.getStringValue().replaceAll("[^A-Za-z]", "");
    println(query);
  }
}