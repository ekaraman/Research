package xml;

import java.util.Collections;
import java.util.Comparator;

import xml.Point;

public class Util {

	public static void sortInTime(PointOwner po) {
		
		Collections.sort(po.getPoints(), new Comparator<Point>() {
			public int compare(Point p1, Point p2){
				return new Long(p1.getTime()).compareTo(new Long(p2.getTime()));
			}
		});		
	}

}
