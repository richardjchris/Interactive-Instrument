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
  
  void trackingUpdate() {
    findContours();
    createBox();
    for (HandTracking hand : handObjects) {
      hand.renderBox();
    }
    setAllCenters();
  }
  
  void findContours() {
    contours = opencv.findContours(false, true);
  }
  
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
        if (currentHands.get(i).size() < 3000) {
          currentHands.remove(i);
        }
      }
      
      /* check that both arrays are not empty
      if (handObjects.isEmpty() && currentHands.isEmpty()) {
        println("Both are empty");
      } else {
        println("current hands are not empty");
      }*/
        
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
          float recordD = 1000;
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
          float recordD = 1000;
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
  
  void updateCurrent() {
  }
  
  void removeOld() {
    
  }
  
  void removeOldCenter() {
    
  }
  
  boolean isNear(PVector hand1, PVector hand2) {
    double sideX = 0;
    double sideY = 0;
    if (hand1.x >= hand2.x) {
      sideX = hand1.x - hand2.x;
    } else if (hand1.x <= hand2.x) {
      sideX = hand2.x - hand1.x;
    }
    
    if (hand1.y >= hand2.y) {
      sideY = hand1.y - hand2.y;
    } else if (hand1.y <= hand2.y) {
      sideY = hand2.y - hand1.y;
    }
  
    double hypotenuse = Math.sqrt(Math.pow(sideX, 2) + Math.pow(sideY, 2));
    if (hypotenuse > 20) {
      return true;
    }
    
    return false;
  }
  
  void setAllCenters() {
    for (HandTracking hand : handObjects) {
      currentCenters.add(hand.getCenter());
    }
  }
  
  void resetAll() {
    handObjects.clear();
    handCount = 0;
  }
  
}
