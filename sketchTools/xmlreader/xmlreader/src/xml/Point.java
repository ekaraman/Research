package xml;

public class Point {
	
	
	private String id;
	private double x;
	private double y;
	private long time;
	
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public Point() {}
	
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public double getX() {
		return x;
	}
	
	public void setX(double x) {
		this.x = x;
	}
	
	public double getY() {
		return y;
	}
	public void setY(double y) {
		this.y = y;
	}
	public long getTime() {
		return time;
	}
	
	public void setTime(long time) {
		this.time = time;
	}
	
	@Override
	public String toString() {
		return "id:" + id +  " x:" + x + " y:" + y + " time:" + time;
	}
	
}
