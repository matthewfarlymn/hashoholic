//import twitter4j.util.*;
//import twitter4j.*;
//import twitter4j.management.*;
//import twitter4j.api.*;
//import twitter4j.util.function.*;
//import twitter4j.conf.*;
//import twitter4j.json.*;
//import twitter4j.auth.*;
//import java.util.*;
//
//ConfigurationBuilder cb = new ConfigurationBuilder();
//Twitter twitterInstance;
//Query queryForTwitter;
//
//ArrayList tweets;
//int i = 0;
//PImage[] pic = new PImage[99];
//int x = 0;
//int y = 0;
//
//void setup() {
//  
//  //Credentials
//  cb.setDebugEnabled(true);
//  cb.setOAuthConsumerKey("DcUeHEdczixliws57OUri2sYi");
//  cb.setOAuthConsumerSecret("5wl1Scpbt4dUM4IASQxrLrGxExeMb1ZE6q95rcMR73BjM4iuDm");
//  cb.setOAuthAccessToken("798873694177214465-OQMUPm98frvFQumfbMyLbkmh2B7W2Ls");
//  cb.setOAuthAccessTokenSecret("PU422R45tOsPHd1MPfUVvoon9kQxRRT1hy4H7rpxwmNPU");
//  cb.setIncludeEntitiesEnabled(true);
//
//  //Now we’ll make the main Twitter object that we can use to do pretty much anything you can do on the twitter website
//  //– get status updates, run search queries, find follower information, etc. This Twitter object gets built by something
//  //called the TwitterFactory, which needs our configuration information that we set above:
//  twitterInstance = new TwitterFactory(cb.build()).getInstance();
//  
//  //Now that we have a Twitter object, we want to build a query to search via the Twitter API for a specific term or phrase.
//  // This is code that will not always work – sometimes the Twitter API might be down, or our search might not return any results,
//  //or we might not be connected to the internet. The Twitter object in twitter4j handles those types of conditions by throwing back
//  //an exception to us; we need to have a try/catch structure ready to deal with that if it happens:
//  queryForTwitter = new Query("#nature");
////  queryForTwitter.setCount(1);
//
//  size(600, 600);
//  fetchTweets();
//}
//
//void draw() {
//  background(0);
//  drawTweets();
//}
//
//void drawTweets() {
//  for (i = 0; i < tweets.size(); i++) {
//      Status t = (Status) tweets.get(i);
//      String user = t.getUser().getName();
//      String msg = t.getText();
//      MediaEntity[] media = t.getMediaEntities();
//      for(MediaEntity m : media) { //search trough your entities
//        System.out.println(m.getMediaURL()); //get your url!
//        String url = m.getMediaURL(); //save your url!
//        pic[i] = loadImage(url);
//        image(pic[i], x, y, 100, 100);
//        x += 100;
//        if (x > 600) {
//          x = 0;
//          y += 100;
//        }
//      }
////      text(user + ": " + msg, 20, 15 + i * 48 - mouseY, width - 20, 40);
////      println(user + ": " + msg);
////      Date d = t.getCreatedAt();
////      println("Tweet by " + user + " at " + d + ": " + msg);
////      Break the tweet into words
////      String[] input = msg.split(" ");
////      for (int j = 0; j < input.length; j++) {
////        Put each word into the words ArrayList
////        words.add(input[j]);
////      }
//      if (i < tweets.size()) {
//        noLoop();
//      }
//    }
//    println(pic);
//}
//
//void fetchTweets() {
//  
//  //Try making the query request.
//  try {
//    QueryResult result = twitterInstance.search(queryForTwitter);
//    tweets = (ArrayList) result.getTweets();
//  } catch (TwitterException te) {
//    println("Couldn't connect: " + te);
//  } // end of catch TwitterException
//} // end of tweets()
//
//
////void draw() {
////  //Draw a faint black rectangle over what is currently on the stage so it fades over time.
////  fill(0,1);
////  rect(0,0,width,height);
////  
////  //Draw a word from the list of words that we've built
////  if (words.size() != 0) {
////    int i = (frameCount % words.size());
////    String word = words.get(i);
////    
////    //Put it somewhere random on the stage, with a random size and colour
////    fill(255,random(50,150));
////    textSize(random(10,30));
////    text(word, random(width), random(height));
////    
////    if (i == words.size()-1) {
////      noLoop();
////    }
////  } else {
////    println("Nothing here");
////    noLoop();
////  }
////}
