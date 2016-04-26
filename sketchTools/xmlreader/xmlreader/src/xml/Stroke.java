package xml;

import java.util.ArrayList;
import java.util.List;

public class Stroke implements PointOwner{

	private List<Point> points = new ArrayList<Point>();	
	private String sketch_id;
	private String id;
	
	public List<Point> getPoints() {
		return points;
	}

	public void setSketch_id(String sketch_id) {
		this.sketch_id = sketch_id;
	}

	public String getSketch_id() {
		return sketch_id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return id;
	}

}
