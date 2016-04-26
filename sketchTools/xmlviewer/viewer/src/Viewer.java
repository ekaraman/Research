import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Stroke;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.geom.Line2D;
import java.io.File;
import java.util.List;

import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.filechooser.FileNameExtensionFilter;

import panel.InkDrawPanel;


public class Viewer{

	/** Main: make a Frame, add a FileTree */
	public static void main(String[] av) {
		
		Util.setupLookAndFeel();
		JFrame frame = new JFrame("Sketch Viewer");
		frame.setForeground(Color.black);
		frame.setBackground(Color.lightGray);
		Container cp = frame.getContentPane();
		frame.setSize(new Dimension(600,600));	
		frame.setLayout(new BorderLayout());

		final Stroke stroke = new BasicStroke(3.0f ,BasicStroke.CAP_ROUND, BasicStroke.JOIN_MITER );
		final InkDrawPanel idp = new InkDrawPanel();  

		Util.freezeSize(idp, new Dimension(600,600));	
		cp.add(idp, BorderLayout.CENTER);
		
		ButtonPanel bp = new ButtonPanel(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				
				JFileChooser fileopen = new JFileChooser(".");
				FileNameExtensionFilter filter = new FileNameExtensionFilter("xml files", "xml");
				fileopen.addChoosableFileFilter(filter);

				int ret = fileopen.showDialog(null, "Open file");

				if (ret == JFileChooser.APPROVE_OPTION) {
					idp.clearInk();
					File file = fileopen.getSelectedFile();
					System.out.println("Loading " + file.getPath());
					try {
						List<Line2D> lines = XmlReader.parseLines(file.getPath());
						for (Line2D l : lines){
							idp.addShape(l, stroke, Color.blue);
						}
						idp.repaint();
					} catch (Exception e1) {
						e1.printStackTrace();
					} 
				}	
			}
		});

		Util.freezeSize(bp, new Dimension(600,25));
		cp.add(bp, BorderLayout.SOUTH);
		frame.setVisible(true);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}



}

