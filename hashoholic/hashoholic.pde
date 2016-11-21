import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.util.function.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
import java.util.*;

ConfigurationBuilder cb = new ConfigurationBuilder();
Twitter twitterInstance;
Query queryForTwitter;

ArrayList tweets;
ArrayList<String> url = new ArrayList<String>();
ArrayList<PImage> pic = new ArrayList<PImage>();
//String[] url = new String[100];
//PImage[] pic = new PImage[5];
int counter = 0;
int x = 0;
int y = 0;
int nameX = 10;
int nameY= 10;
int k = 0;

void setup() {
  
  size(1000, 1000);
  background(0);
  frameRate(100);
  
  //Credentials
  cb.setDebugEnabled(true);
  cb.setOAuthConsumerKey("DcUeHEdczixliws57OUri2sYi");
  cb.setOAuthConsumerSecret("5wl1Scpbt4dUM4IASQxrLrGxExeMb1ZE6q95rcMR73BjM4iuDm");
  cb.setOAuthAccessToken("798873694177214465-OQMUPm98frvFQumfbMyLbkmh2B7W2Ls");
  cb.setOAuthAccessTokenSecret("PU422R45tOsPHd1MPfUVvoon9kQxRRT1hy4H7rpxwmNPU");
  cb.setIncludeEntitiesEnabled(true);

  twitterInstance = new TwitterFactory(cb.build()).getInstance();
  
  queryForTwitter = new Query("#rainbow AND filter:images");
  queryForTwitter.setCount(100);

  fetchTweets();
  
}

void draw() {
  drawTweets();
}

void drawTweets() {
  image(pic.get(k), x, y, 100, 100);
  x += 100;
  if (x > 900) {
    x = 0;
    y += 100;
  }
  if (y > 900) {
    noLoop();
  }
  k++;
  if (k == url.size()) {
    k = 0;
  }
//  for (int i = 0; i < url.size(); i++) {
////    println(pic);
////    delay(1000);
//  }
}

void fetchTweets() {
  try {
    QueryResult result = twitterInstance.search(queryForTwitter);
    tweets = (ArrayList) result.getTweets();
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      MediaEntity[] media = t.getMediaEntities();
      if (media != null) {
//        String user = t.getUser().getName();
//        String msg = t.getText();
//        text(user, nameX, nameY, 90, 00);
//        nameX += 200;
//        if (nameX > 800) {
//          nameX = 10;
//          nameY += 200;
//        }
        for(MediaEntity m : media) { //search trough your entities
          url.add(m.getMediaURL());
          pic.add(loadImage(url.get(counter)));
          counter++;
        }
      }
    }
    println(pic);
  } catch (TwitterException te) {
    println("Couldn't connect: " + te);
  } // end of catch TwitterException
} // end of tweets()
