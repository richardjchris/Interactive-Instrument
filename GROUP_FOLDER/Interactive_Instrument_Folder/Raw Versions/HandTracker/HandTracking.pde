// This tracks the hand
import gab.opencv.*;
import java.awt.Rectangle;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfInt4;
import org.opencv.core.MatOfPoint;
import java.util.*;
import processing.video.*;

public class HandTracking {
  
  Contour convexHull;
  
  //ArrayList<Contour> contours;
  //ArrayList<Contour> limitContours = new ArrayList<Contour>();
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
  
  HandTracking(int x, int y, int r_width, int r_height/*, ArrayList<Contour> passedContours*/) {
    rectx = x;
    recty = y;
    rect_width = r_width;
    rect_height = r_height;
    //contours = passedContours;
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
  
  void contourFocus() {
    
  }
  
  float size() {
    return (rect_width * rect_height);
  }
  
  void become(HandTracking other) {
    rectx = other.getX();
    recty = other.getY();
    rect_width = other.get_width();
    rect_height = other.get_height();
    //contours = other.contours;
    //id = other.id;
    RectCenter.set(rectx+(rect_width/2), recty+(rect_height/2));
  }
  
  void updatePosition(int x, int y, int r_width, int r_height) {
    rectx = x;
    recty = y;
    rect_width = r_width;
    rect_height = r_height;
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
    
    textAlign(CENTER);
    textSize(64);
    fill(0, 255, 0);
    text(id, rectx + rect_width*0.5, recty +rect_height-10);
  }
  
  /*void renderHand() {
    if (contours.size() != 0) {
      
      stroke(255, 0, 0);
      beginShape();
      for (Contour contour : contours) { 
        for (PVector point : contour.getPolygonApproximation().getPoints()) {
          if (boundRange(point) == true) {
            vertex(point.x, point.y);
          }
        }
        endShape();
      }
      noFill();
      stroke(255, 0, 0);
      convexHull.draw();
      
      stroke(0, 0, 255);
      fill(255);
      for (PVector p : defectPoints) {
         ellipse(p.x, p.y, 20,20);
      }
      
      pushStyle();
      fill(255);
      stroke(255, 0, 0);
      ellipse(hullCenter.x, hullCenter.y, 30, 30);
    
      popStyle();
      
      stroke(0,0,255);
      noFill();
      beginShape();
      for(PVector p : handPoints){
        vertex(p.x,p.y);
      }
      endShape(CLOSE);
      
      pushStyle();
      fill(255);
      stroke(255, 0, 0);
      ellipse(hullCenter.x, hullCenter.y, 30, 30);
      popStyle();
      
      pushStyle();
      noFill();
      stroke(0, 0, 255);
      ellipse(hullCenter.x, hullCenter.y, hullRange*2, hullRange*2);
      popStyle();
    }
  }
  
  boolean boundRange(PVector point) {
  
    double sideX = 0;
    double sideY = 0;
    if (point.x >= hullCenter.x) {
      sideX = point.x - hullCenter.x;
    } else if (point.x <= hullCenter.x) {
      sideX = hullCenter.x - point.x;
    }
    
    if (point.y >= hullCenter.y) {
      sideY = point.y - hullCenter.y;
    } else if (point.y <= hullCenter.y) {
      sideY = hullCenter.y - point.y;
    }
  
    double hypotenuse = Math.sqrt(Math.pow(sideX, 2) + Math.pow(sideY, 2));
    if (hullRange > hypotenuse) {
      return true;
    }
    
    return false;
  }
  
  //This outputs a limitedrange of contours
  
  //This will draw the hand contours
  void calContour() {
    Contour contour = contours.get(0);
    //convex hull is the envelope around the enclosure of points.
    convexHull = contour.getPolygonApproximation().getConvexHull();
    
    hullCenter = new PVector(convexHull.getBoundingBox().x + convexHull.getBoundingBox().width/2, 
    convexHull.getBoundingBox().y + convexHull.getBoundingBox().height/2);
    hullRange = 80;
    
    MatOfInt hull = new MatOfInt();
    MatOfPoint points = new MatOfPoint(contours.get(0).pointMat);
    //println(points);
    Imgproc.convexHull(points, hull);
    
    MatOfInt4 defects = new MatOfInt4();
    Imgproc.convexityDefects(points, hull, defects);
    
    defectPoints  = new ArrayList<PVector>();
    depths =  new ArrayList<Float>(); 
    
    
    ArrayList<Integer> defectIndices = new ArrayList<Integer>();
    
    for (int i = 0; i < defects.height(); i++) {
      int startIndex = (int)defects.get(i, 0)[0];
      int endIndex = (int)defects.get(i, 0)[1];
      int defectIndex = (int)defects.get(i, 0)[2];
      if (defects.get(i, 0)[3] > 10000) {
        defectIndices.add( defectIndex );
        defectPoints.add(contour.getPoints().get(defectIndex));
        depths.add((float)defects.get(i, 0)[3]);
      }
    }
    
    Integer[] handIndices = new Integer[defectIndices.size() + hull.height()];
    for (int i = 0 ; i < hull.height(); i++) {
      handIndices[i] = (int)hull.get(i, 0)[0];
    }
    
    for(int d = 0; d < defectIndices.size(); d++){
      handIndices[d + hull.height()] = defectIndices.get(d);
    }
  
    //This defines the vertices for each hand point vector
    Arrays.sort(handIndices);
    handPoints = new ArrayList<PVector>();
    for(int i = 0; i < handIndices.length; i++){
      handPoints.add(contour.getPoints().get(handIndices[i]));
    }
  }*/
   
}
