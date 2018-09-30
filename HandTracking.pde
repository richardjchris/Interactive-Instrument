import java.util.*;
import processing.video.*;

public class HandTracking {
  
  Contour convexHull;
  private PVector RectCenter;
  //private PVector hullCenter;
  ArrayList<Contour> polygons;
  
  ArrayList<PVector> defectPoints;
  ArrayList<Float> depths;
  ArrayList<PVector> handPoints;
  
  private int rectx;
  private int recty;
  private int rect_width;
  private int rect_height;
  private int id = 0;
  int hullRange;
  boolean taken = false;
  
  HandTracking(int x, int y, int r_width, int r_height) {
    rectx = x;
    recty = y;
    rect_width = r_width;
    rect_height = r_height;
    RectCenter = new PVector(rectx+(rect_width/2), recty+(rect_height/2));
  }
  
  int getX() {
    return rectx;
  }
  
  int getY() {
    return recty;
  }
  
  int get_width() {
    return rect_width;
  }
  
  int get_height() {
    return rect_height;
  }
  
  int get_ID() {
    return id;
  }
  
  PVector getCenter() {
    return RectCenter;
  }
  
  void setID(int new_id) {
    id = new_id;
  }
  
  //returns the size of the area
  float size() {
    return (rect_width * rect_height);
  }
  
  //This takes another hand object and 'becomes' the current object
  void become(HandTracking other) {
    rectx = other.getX();
    recty = other.getY();
    rect_width = other.get_width();
    rect_height = other.get_height();
    RectCenter.set(rectx+(rect_width/2), recty+(rect_height/2));
  }
  
  // This renders the box
  void renderBox() {
    noFill();
    stroke(255, 255, 255);
    strokeWeight(2);
    rect(rectx, recty, rect_width, rect_height);
    
    fill(255, 0, 0);
    ellipse(RectCenter.x, RectCenter.y, 10, 10);
    
    /*textAlign(CENTER);
    textSize(64);
    fill(0, 255, 0);
    text(id, rectx + rect_width*0.5, recty +rect_height-10);*/
  }
   
}
