package xml;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


import org.jdom.DataConversionException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

@SuppressWarnings("unchecked")
public class Sketch implements PointOwner{

	private List<Point> pointList;
	private List<Primitive> primitiveList;
	private List<Stroke> strokeList;
	private Document doc;
	
	public Sketch(String xmlPath) throws JDOMException, IOException {
		pointList =  new ArrayList<Point>();
		primitiveList = new ArrayList<Primitive>();
		strokeList = new ArrayList<Stroke>();
		read(xmlPath);
	}
	
	public String getFileName(){
		return doc.getBaseURI();
	}
	
	public List<Point> getPoints() {
		return pointList;
	}

	public List<Primitive> getPrimitives() {
		return primitiveList;
	}	

	public List<Stroke> getStrokes() {
		return strokeList;
	}
	
	
	private void read(String xmlPath) throws JDOMException, IOException{
		SAXBuilder parser = new SAXBuilder();      	
       	doc = parser.build(new File(xmlPath));
       	clearLists();
		parsePoints();
		parsePrimitives();
		parseStrokes();
	}	
	
	private void clearLists() {
		pointList.clear();
		primitiveList.clear();
		strokeList.clear();	
	}


	private void parseStrokes() {
       	Element root = doc.getRootElement();	       
       	List<Element> strokeElements = root.getChildren("stroke");     	
       	for (Element se : strokeElements){
       		Stroke s = parseStroke(se);
       		strokeList.add(s);
       	}  
	}

	private Stroke parseStroke(Element se) {
		Stroke stroke = new Stroke();
		stroke.setId(se.getAttribute("id").getValue());		
		List<Element> argList = se.getChildren("arg");
		for (Element argElement : argList){
			if (argElement.getAttribute("type").getValue().equalsIgnoreCase("point")){
				String currentPointId = argElement.getValue();
				stroke.getPoints().add(getPoint(currentPointId));
			}			
		}			
   		Util.sortInTime(stroke);
		return stroke;
	}

	private void parsePoints() throws JDOMException, IOException{
       	Element root = doc.getRootElement();
		List<Element> pointElements = root.getChildren("point");     	
       	for (Element p : pointElements){
       		Point point = parsePoint(p);
       		pointList.add(point);
       	}
		Util.sortInTime(this);
	}
	
	private Point parsePoint(Element pe) throws DataConversionException {
		Point point = new Point();
		point.setId(pe.getAttribute("id").getValue());
		point.setX(pe.getAttribute("x").getFloatValue());
		point.setY(pe.getAttribute("y").getFloatValue());
		point.setTime(pe.getAttribute("time").getLongValue());
		return point;
	}
	
	private void parsePrimitives() throws JDOMException, IOException{
       	Element root = doc.getRootElement();	       
       	List<Element> labelElements = root.getChildren("label");     	
       	for (Element le : labelElements){
       		Primitive p = parsePrimitive(le);
       		primitiveList.add(p);
       	} 
	}	
	
	
	private Primitive parsePrimitive(Element pe) {

		Primitive primitive = new Primitive();
		primitive.setId(pe.getAttribute("id").getValue());
		PrimitiveType type = parsePrimitiveType(pe.getAttribute("primitiveType").getValue());
		primitive.setType(type);
		List<Element> argList = pe.getChildren("arg");
		for (Element argElement : argList){
			if (argElement.getAttribute("type").getValue().equalsIgnoreCase("point")){
				String currentPointId = argElement.getValue();
				// Since duplicate points exists in primitives (bug), we make sure it is not in the current list.
				if (!primitive.getPoints().contains(getPoint(currentPointId))){
					primitive.getPoints().add(getPoint(currentPointId));
				}				
			}			
		}
       	Util.sortInTime(primitive);
		return primitive;
	}

	private Point getPoint(String pointId) {
		for (Point p : pointList){
			if (p.getId().equalsIgnoreCase(pointId)){
				return p;
			}
		}
		throw new RuntimeException("Point id " + pointId + " couldn't be found");
	}

	private PrimitiveType parsePrimitiveType(String value) {
		return PrimitiveType.fromString(value);
	}

	public static void main(String[] args) throws JDOMException, IOException {
		Sketch sketch = new Sketch("test.xml");
		sketch.getFileName();
		sketch.getPrimitives();
		sketch.getStrokes();
		List<Point> pts = sketch.getPoints();
		for (Point p : pts){
			System.out.println(p);
		}
	}

	

}
