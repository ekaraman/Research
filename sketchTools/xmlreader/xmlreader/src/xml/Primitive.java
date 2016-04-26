package xml;

import java.util.ArrayList;
import java.util.List;

public class Primitive implements PointOwner{

	private String id;
	private List<Point> points =  new ArrayList<Point>();
	private PrimitiveType type;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public List<Point> getPoints() {
		return points;
	}
	public void setPoints(List<Point> points) {
		this.points = points;
	}
	public PrimitiveType getType() {
		return type;
	}
	public void setType(PrimitiveType type) {
		this.type = type;
	}
}
