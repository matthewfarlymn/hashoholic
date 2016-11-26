//import twitter4j.*;
//import twitter4j.api.*;
//import twitter4j.auth.*;
//import twitter4j.conf.*;
//import twitter4j.json.*;
//import twitter4j.management.*;
//import twitter4j.util.*;
//import twitter4j.util.function.*;
//import java.util.*;

//ConfigurationBuilder cb = new ConfigurationBuilder();
//Twitter twitterInstance;
//Query queryForTwitter;

//ArrayList tweets;
//ArrayList<Long> imgID = new ArrayList<Long>();
//ArrayList<String> imgURL = new ArrayList<String>();
//ArrayList<PImage> pic = new ArrayList<PImage>();
////String[] url = new String[100];
////PImage[] pic = new PImage[5];
//int counter = 0;
//int x = 0;
//int y = 0;
//int nameX = 10;
//int nameY= 10;
//boolean initialTweetsLoaded = false;

//void setup() {
  
//  size(1000, 1000);
//  background(0);
//  frameRate(2);
  
//  //Credentials
//  cb.setDebugEnabled(true);
//  cb.setOAuthConsumerKey("DcUeHEdczixliws57OUri2sYi");
//  cb.setOAuthConsumerSecret("5wl1Scpbt4dUM4IASQxrLrGxExeMb1ZE6q95rcMR73BjM4iuDm");
//  cb.setOAuthAccessToken("798873694177214465-OQMUPm98frvFQumfbMyLbkmh2B7W2Ls");
//  cb.setOAuthAccessTokenSecret("PU422R45tOsPHd1MPfUVvoon9kQxRRT1hy4H7rpxwmNPU");
//  cb.setIncludeEntitiesEnabled(true);

//  twitterInstance = new TwitterFactory(cb.build()).getInstance();

//  queryForTwitter = new Query("#sunset AND filter:images");
//  queryForTwitter.setCount(100);

//  // fetchTweets();
  
//  thread("refreshTweets");
  
//}

//void draw() {
//  if (initialTweetsLoaded)
//  {
//    drawTweets();
//  }
//  else
//  {
//    fill(255);
//    text("Loading Tweets...", 250, 250);
//  }
//}

//void drawTweets() {
//  image(pic.get(counter), x, y, 250, 250);
//  x += 250;
//  if (x > 900) {
//    x = 0;
//    y += 250;
//  }
//  if (y > 900) {
//    x = 0;
//    y = 0;
//  }
//  counter++;
//  if (counter == pic.size()) {
//    counter = 0;
//  }
//}

//void fetchTweets() {
//  try {
//    QueryResult result = twitterInstance.search(queryForTwitter);
//    tweets = (ArrayList) result.getTweets();
//    for (int i = 0; i < tweets.size(); i++) {
//      Status t = (Status) tweets.get(i);
//      //println(t.getMediaEntities());
//      MediaEntity[] media = t.getMediaEntities();
//      if (media != null) {
//        //String user = t.getUser().getName();
//        //String msg = t.getText();
//        //text(user, nameX, nameY, 90, 00);
//        //nameX += 200;
//        //if (nameX > 800) {
//        //  nameX = 10;
//        //  nameY += 200;
//        //}
//        for(MediaEntity m : media) { //search trough your entities
//          imgURL.add(m.getMediaURL());
//        }
//      }
//    }
//    removeDuplicateTweets();
//    println(imgURL);
//  } catch (TwitterException te) {
//    println("Couldn't connect: " + te);
//  } // end of catch TwitterException
// } //// end of tweets()

//void removeDuplicateTweets() {
//  Set<String> removeDuplicates = new LinkedHashSet<String>(imgURL);
//  imgURL.clear();
//  imgURL.addAll(removeDuplicates);
//  for (int i = 0; i < imgURL.size(); i++) {
//    pic.add(loadImage(imgURL.get(i)));
//    println(pic);
//  }
//  initialTweetsLoaded = true;
//}

//void refreshTweets() {
//  while(true) {
//    fetchTweets();
//    println("Searching more Tweets");
//    delay(30000);
//  }
//}