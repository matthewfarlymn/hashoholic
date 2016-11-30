// importing libraries all necessary libraries
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

// creating a textfield for search input
ControlP5 searchInput;

// creating a movie for intro video
Movie intro;

// creating a sound for search counter
SoundFile pop;

// creating a configuration builder for twitter properties
ConfigurationBuilder cb;

// creating a twitter instance to be used for twitter factory
Twitter twitterInstance;

// creating a query to be used for twitter search query
Query twitterQuery;

// declaring all global variables to be used
PImage icon;
XML xml;
XML[] credentials;
String consumerKey;
String consumerSecret;
String accessToken;
String accessTokenSecret;
String query;
String currentQuery;
int alpha = 250;
int seconds = 1;
int imgX = 0;
int imgY = 0;
int counter = 0;
boolean looping = true;
boolean onload = true;
boolean loading = false;
boolean blackout = true;
boolean searching = false;
boolean notification = false;
boolean error = false;
ArrayList tweets;
ArrayList<String> url = new ArrayList<String>();
ArrayList<PImage> pic = new ArrayList<PImage>();

// setup function will generate the initial window
void setup() {
  
  // setting dimensions of window
  size(1250, 850);
  
  // setting window background color
  background(85, 172, 238);
  
  // setting window framerate
  frameRate(2);
  
  // registering font to be used as default
  PFont font = createFont("arial", 40);
  textFont(font);
  
  // registering new textfield for search input
  searchInput = new ControlP5(this);
  
  // setting textfield properties to be displayed in window
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
  int y = 20;
  int spacing = 60;
  y += spacing;
  
  // registering new movie to be used for intro set to loop
  intro = new Movie(this, "intro.mp4");
  intro.loop();
  
  // loading icon image to be used for onload and search screens
  icon = loadImage("icon.png");
  
  // registering new sound file to be used for seconds counter
  pop = new SoundFile(this, "pop.wav");
  
  // loading external xml file data
  xml = loadXML("credentials.xml");
  
  // extracting all children from the oauth tag and placing them in the credentaials array
  credentials = xml.getChildren("oauth");
  
  // a for loop which will retreive all string data from the credentials array
  // for the lenght of the array and save string data to corresponding variables
  for (int i = 0; i < credentials.length; i++) {
    consumerKey = credentials[i].getString("consumerKey");
    consumerSecret = credentials[i].getString("consumerSecret");
    accessToken = credentials[i].getString("accessToken");
    accessTokenSecret = credentials[i].getString("accessTokenSecret");
  }
  
  // registering new configuration builder for twitter4j library
  cb = new ConfigurationBuilder();
  
  //Credentials for twitter using the data retrieved from xml file
  cb.setDebugEnabled(true);
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessTokenSecret);
  cb.setIncludeEntitiesEnabled(true);
  
  // registering new twitter factory for twitter4j library
  twitterInstance = new TwitterFactory(cb.build()).getInstance();
  
  // loops the function refreshTweets simultaniously as draw 
  // to continuously search for new tweets
  thread("refreshTweets");
  
}

// draw function continuously loops to display information in window
void draw() {
  
  // verifies if loading is true
  if (loading) {
    
    // adjusts frame rate based on the x position of the mouse
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
    
    // verifies if blackout is true
    if (blackout) {
      
      // adds a rectangle to the window to blackout previous content
      fill(0, alpha);
      noStroke();
      rect(0, 0, 1250, 750);
      blackout = false;
    }
    
    // runs drawTweets function
    drawTweets();
  
  // verifies if searching is true
  } else if (searching) {
    
    // verifies if error is true
    if (error) {
      
      // displays error message in window
      fill(242, 90, 92);
      rect(0, 670, 1250, 80);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Search returned no images.", 0, 675, 1250, 60);
      error = false;
      searching = false;
      loading = true;
      
    }
    
    // verifies if notification is true
    if (notification) {
      
      // displays notification in window
      fill(242, 90, 92);
      rect(0, 670, 1250, 80);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Please wait until current search completes.", 0, 675, 1250, 60);
      notification = false;
      
    }
    
    // adjusts window frame rate to be 1
    frameRate(1);
    
    // plays pop sound with increased pitch
    pop.play();
    pop.rate(1.50);
    
    // adds a rectangle to the window to blackout previous content
    fill(0, alpha);
    alpha-=250;
    noStroke();
    rect(0, 0, 1250, 750);
    
    // displays search message with seconds counter increasing each frame
    // indicating duration of search
    fill(85, 172, 238);
    rect(575.5, 412.5, 100, 50);
    image(icon, 575, 200, 100, 100);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Searching Twitter\nfor #" + query + " Images\n" + seconds +"s", 0, 125, 1250, 500);
    seconds++;
    blackout = true;
    
  // verifies if onload is true
  } else if (onload) {
    
    // verifies if query is not equal to null
    if (query != null) {
      
      // adds a rectangle to the window to blackout previous content
      fill(85, 172, 238);
      noStroke();
      rect(0, 0, 1250, 750);
      onload = false;
      searching = true;
      
    // if query is null  
    } else {
      
      // adjusts window frame rate to be 30
      frameRate(30);
      
      // play intro video with intro message
      image(intro, 0, 0, 1333, 750);
      image(icon, 575, 225, 100, 100);
      fill(255);
      textAlign(CENTER, CENTER);
      text("Start Searching Twitter\nfor #tagged Images", 0, 125, 1250, 500);
      
    }
    
  }
  
}

// drawTweets function displays images based on queried tweets
void drawTweets() {
  
  // verifies if query is not equal to currentQuery
  if (!query.equals(currentQuery)) {
    
    // clears url and pic arrays
    url.clear();
    pic.clear();
    
    // sets all necessary variables back to default settings
    counter = 0;
    imgX = 0;
    imgY = 0;
    seconds = 1;
    alpha = 250;
    loading = false;
    searching = true;
    
  // verifies if pic array has more than 0 items in it
  } else if (pic.size() != 0) {
    
    // verifies if counter is greater than or equal to the amount of items in the pic array
    // if true the counter resets to 0
    if (counter >= pic.size()) {
      counter = 0;
    }
    
    // verifies if imgX is greater than or equal to 1000px
    // if true imgX resets to 0 and imgY increases by 250px
    if (imgX > 1000) {
      imgX = 0;
      imgY += 250;
    }
    
    // verifies if imgY is greater than or equal to 750px
    // if true imgY and imgX reset to 0
    if (imgY >= 750) {
      imgX = 0;
      imgY = 0;
    }
    
    // adds a rectangle to the window to create fade effect
    fill(0, 25);
    noStroke();
    rect(0, 0, 1250, 750);
    
    // displays current image in loop at the co-ordinates of imgX and imgY
    image(pic.get(counter), imgX, imgY, 250, 250);
    
    // moves the image over by 250px each loop and increases counter by 1
    imgX += 250;
    counter++;
    
  }

}

// fetchTweets function searches 100 tweets for images based on user query
void fetchTweets() {
  
  // test connection with twitter
  try {
    
    // sets currentQuery as query
    currentQuery = query;
    
    // creats a new hashtag search query for images based on the currentQuery
    twitterQuery = new Query("#" + currentQuery + " AND filter:images");
    
    // confirms query from 100 tweets
    twitterQuery.setCount(100);
    
    // creates a query result for result based on a twitter search instance
    QueryResult result = twitterInstance.search(twitterQuery);
    
    // generates an array list of tweet data
    tweets = (ArrayList) result.getTweets();
    
    // a for loop which will extract each tweet as a status
    for (int i = 0; i < tweets.size(); i++) {
      
      // creates a status based on the extracted tweet data
      Status t = (Status) tweets.get(i);
      
      // creates an array of the media data located within each status
      MediaEntity[] media = t.getMediaEntities();
      
      // a for loop which extracts the url data and places it in the url arraylist
      for(MediaEntity m : media) { //search trough your entities
        url.add(m.getMediaURL());
      }
      
    }
    
    // runs removeDuplicates function
    removeDuplicates();
  
  // verifies if test connection fails and prints message to console log
  } catch (TwitterException te) { 
    println("Couldn't connect: " + te);
  }
  
}


// removeDuplicates function checks the final url arraylist for duplicates
void removeDuplicates() {
  
  // checks url arraylist for duplicates and removes all duplicates found
  Set<String> removeDuplicates = new LinkedHashSet<String>(url);
  
  // clears url arraylist before adding newly generated array of items
  url.clear();
  
  // adds all items from removeDuplicates into empty url arraylist
  url.addAll(removeDuplicates);
  
  // for loop loads url arraylist items as images into  pic arraylist
  // based on how many items exist in the url arraylist
  for (int i = 0; i < url.size(); i++) {
    pic.add(loadImage(url.get(i)));
  }
  
  // verifies if the pic arraylist is not empty
  if (pic.size() != 0) {
    alpha = 250;
    loading = true;
    searching = false;
    
  // if pic arraylist is 0
  } else {
    error = true;
  }
  
}

// refreshTweets functions will run previous query every 15 seconds
// or new user query during its next attempt 
void refreshTweets() {
  
  // verifies if looping is set to true
  while(looping) {
    
    // verifies if query is not null
    if (query != null) {
      
      // clears url and pic arraylists
      url.clear();
      pic.clear();
      
      // runs fetchTweets function and sets delay for 15 seconds
      fetchTweets();
      delay(15000);
      
    // if query is null will continue to loop on a delay of 1 second
    } else {
      delay(1000);
    }
    
  }

}

// controlEvent function will run each time the input field is updated using the enter key
void controlEvent(ControlEvent theEvent) {
  
  // verifies if the input field is valid
  if(theEvent.isAssignableFrom(Textfield.class)) {
    
    // verifies if searching is false
    if(!searching) {
      
      // removes all special symbols and spaces from input
      // leaving only a to z characters or numbers as the new query
      query = theEvent.getStringValue().replaceAll("[^A-Za-z0-9]", "");
    
    // if searching true user receives and notification
    } else {
      notification = true;
    }
  
  }

}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}