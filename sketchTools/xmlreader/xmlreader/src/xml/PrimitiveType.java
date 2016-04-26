package xml;

public enum PrimitiveType {
	
    LINE(1, "Line"),
    ARC(2, "Arc"),
    ELLIPSE(3, "Bezier"),
    CIRCLE(4, "Ellipse"),
    BEZIER(5, "Circle");
    
 
    private final int id;
    private final String label;
 
    PrimitiveType(final int id, final String label) {
        this.id = id;
        this.label = label;
    }
 
    public int getId() {
        return id;
    }
 
    public String toString() {
        return label;
    }
 
    public static PrimitiveType fromString(final String str) {
        for (PrimitiveType e : PrimitiveType.values()) {
            if (e.toString().equalsIgnoreCase(str)) {
                return e;
            }
        }
        return null;
    }
 
    public static PrimitiveType fromId(final int id) {
        for (PrimitiveType e : PrimitiveType.values()) {
            if (e.id == id) {
                return e;
            }
        }
        return null;
    }
}