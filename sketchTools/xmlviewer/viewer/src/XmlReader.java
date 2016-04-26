import java.awt.geom.Line2D;
import java.awt.geom.Point2D;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


import org.jdom.DataConversionException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

@SuppressWarnings("unchecked")
public class XmlReader {
	
	public static List<Line2D> parseLines(String xmlPath) throws IOException, JDOMException{
		
		List<Line2D> lines = new ArrayList<Line2D>();
		List<Point2D> points = parsePoints(xmlPath);
		List<Integer> nptsPerStroke = getNumPointsPerStroke(xmlPath);
		int nPts;
		int totalPts = 0;
		for (int i=0; i<nptsPerStroke.size(); i++){
			nPts = nptsPerStroke.get(i);
			for (int j=0; j<nPts-1; j++){
				lines.add(new Line2D.Float(points.get(totalPts + j), points.get(totalPts + j+1)));
			}
			totalPts += nPts;
		}
		

		return lines;		
	}

	private static List<Integer> getNumPointsPerStroke(String xmlPath) throws JDOMException, IOException{
		List<Integer> result = new ArrayList<Integer>();
		SAXBuilder parser = new SAXBuilder();      	
       	Document doc = parser.build(xmlPath);
       	Element root = doc.getRootElement();
       	List<Element> strokeElements = root.getChildren("stroke");     	
       	for (Element p : strokeElements){
       		result.add(p.getChildren().size());
       	}
		return result;
	}
	

	public static List<Point2D> parsePoints(String xmlPath) throws IOException, JDOMException {
		
		List<Point2D> points = new ArrayList<Point2D>();		
		SAXBuilder parser = new SAXBuilder();      	
       	Document doc = parser.build(xmlPath);
       	Element root = doc.getRootElement();
       	List<Element> pointElements = root.getChildren("point");     	
       	for (Element p : pointElements){
       		Point2D.Float point = parsePoint(p);
       		points.add(point);
       	}
		return points;
	}

	private static Point2D.Float parsePoint(Element point) throws DataConversionException{
		Point2D.Float p = new Point2D.Float();
		p.x = point.getAttribute("x").getFloatValue();
		p.y = point.getAttribute("y").getFloatValue();
		return p;
	}
	
}
