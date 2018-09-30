//This only trackings the contours and neceassary areas that are identified
import gab.opencv.*;
import java.awt.Rectangle;
import org.opencv.imgproc.Imgproc;
import java.util.*;

public class MainTracking {
  
  ArrayList<PVector> currentCenters = new ArrayList<PVector>();
  LinkedList<HandTracking> handObjects = new LinkedList<HandTracking>();
  ArrayList<Contour> contours;
  int handCount = 0;
  
  MainTracking() {
    
  }
  
  //This is the primary updater of the class
  void trackingUpdate() {
    findContours();
    createBox();
    for (HandTracking hand : handObjects) {
      hand.renderBox();
    }
    setAllCenters();
  }
  
  //Finds and outputs all known contours detected in binary mask
  void findContours() {
    contours = opencv.findContours(false, true);
  }
  
  // Creates the tracking objects that output a box of the primary tracking subjects
  void createBox() {
    LinkedList<HandTracking> currentHands = new LinkedList<HandTracking>();
    if (contours.size() != 0) {
      
      // Making new Boxes
      for (Contour contour : contours) {
        HandTracking newHand = new HandTracking(contour.getBoundingBox().x, contour.getBoundingBox().y, contour.getBoundingBox().width, contour.getBoundingBox().height);
        //newHand.renderBox();
        currentHands.add(newHand);
      }
      
        
      // remove rect bound if it is small
      for (int i = currentHands.size()-1; i >= 0; i--) {
        if (currentHands.get(i).size() < 28000) {
          currentHands.remove(i);
        }
      }
        
      // OPTION 1 =  IF there are no hands in the array
      if (handObjects.isEmpty() && currentHands.size() > 0) {
        for (HandTracking hand : currentHands) {
          hand.id = handCount;
          handObjects.add(hand);
          handCount++;
        }
      } else if (handObjects.size() <= currentHands.size()) {
        //OPTION 2 = Matches whatever hands are the same
        for (HandTracking hand : handObjects) {
          float recordD = 100;
          HandTracking matched = null;
          for (HandTracking chand : currentHands) {
            PVector centerB = hand.getCenter();
            PVector centerCB = chand.getCenter();
            
            float d = PVector.dist(centerB, centerCB);
            if (d < recordD && !chand.taken) {
              recordD = d;
              matched = chand;
            }
          }
          if (matched != null) {
            matched.taken = true;
            hand.become(matched);
          }
        }
          
        //OPTION 3 = Make new hands from leftovers
        for(HandTracking hand : currentHands) {
          if (!hand.taken) {
            hand.setID(handCount);
            handObjects.add(hand);
            handCount++;
          }
        }
      } else if (handObjects.size() > currentHands.size()) {
        for (HandTracking hand : handObjects) {
          hand.taken = false;
        }
        
        //OPTION 2 = Matches whatever hands are the same
        for (HandTracking chand : currentHands) {
          float recordD = 100;
          HandTracking matched = null;
          for (HandTracking hand : handObjects) {
            PVector centerB = hand.getCenter();
            PVector centerCB = chand.getCenter();
            
            float d = PVector.dist(centerB, centerCB);
            if (d < recordD && !hand.taken) {
              recordD = d;
              matched = hand;
            }
          }
          if (matched != null) {
            matched.taken = true;
            matched.become(chand);
          }
        }
          
        for (int i = handObjects.size() - 1; i >= 0; i--) {
          
          HandTracking h = handObjects.get(i);
          if (!h.taken) {
            handObjects.remove(i);
          }
        }    
      }
    }
  }
  
  //This sets all the centers tracked into the current array for usage for the rest of the program
  void setAllCenters() {
    ArrayList<PVector> presentCenters = new ArrayList<PVector>();
    for (HandTracking hand : handObjects) {
      presentCenters.add(hand.getCenter());
    }
    currentCenters = presentCenters;
  }
  
  // This is called in the case that all objects need to be cleared
  void resetAll() {
    handObjects.clear();
    handCount = 0;
  }
  
}
