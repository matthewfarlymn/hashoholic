//import http.requests.*; // the http lib
// 
//PFont InstagramFont;  // in case you need it
//PImage[] userphoto = new PImage[11];     // to hold the incoming image
//int x = 0;
//int y = 0;
//
//void setup() {
//  size(1500, 1000);
//  background(0);
//  getGrams();
//}
// 
//void getGrams() {
//  GetRequest get = new GetRequest("https://api.instagram.com/v1/tags/ireland/media/recent?access_token=1595128186.5a41c48.738b501b6f574f60bc59bff946d451f4");
//  get.send(); // program will wait untill the request is completed
// 
//  // now we need to deal with the data.
//  // First, we convert it to an "internal" JSON object
//  JSONObject content = parseJSONObject(get.getContent()); 
// 
//  // Next, we get from that an array of all the posts in the returned data object
//  JSONArray data = content.getJSONArray("data"); 
// 
//  for (int i = 0; i < 11; i++) { 
//    // Let's get the first chunk of that data into another object called first
//    JSONObject first = data.getJSONObject(i); 
//   
//    // To test, let's get out the filter from that chunk, because that's a string not an object
//    // String filter = first.getString("filter");
//   
//    // Let's find the images object in the first chunk of data
//    JSONObject images = first.getJSONObject("images");
//    
//    // and let's get the standard_resolution version of the image in the images object
//    JSONObject standard_resolution = images.getJSONObject("standard_resolution");
//    
//    // finally, let's get the string with the URL in it
//    String URL = standard_resolution.getString("url");
//    
//    // Removing all characters after the "?" and using the first portion
//    URL = URL.substring(0, URL.indexOf('?'));
//    
//    // Print it to the console, open champagne etc
//    println("URL = " + URL);
//   
//    // Load in the image at that URL
//    userphoto[i] = loadImage(URL);
//    
//  }
//}
// 
//void draw() {
//  if (frameCount % 1000 == 0) {
//    println("Getting grams...");
//    getGrams();
//  }
//  imageMode(CORNER);
//  if (userphoto != null) {
//    for (int i = 0; i < 11; i++) {
//      image(userphoto[i], x, y, 300, 300);
//      x += 300;
//      if (x > displayWidth) {
//        x = 0;
//        y += 300;
//      }
//      if (i < 11) {
//        noLoop();
//      }
//    }
//  } else {
//    println("userphoto null");
//  }
//}
