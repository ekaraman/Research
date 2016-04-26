import java.awt.Dimension;

import javax.swing.JPanel;
import javax.swing.UIManager;


public class Util {

	public static void freezeSize(JPanel panel, Dimension size){
		panel.validate();
		panel.setMinimumSize(size);
		panel.setMaximumSize(size);
		panel.setPreferredSize(size);
	}
	
	public static void setupLookAndFeel(){
		try{
			if(System.getProperty("os.name").toLowerCase().contains("linux"))
				UIManager.setLookAndFeel("com.sun.java.swing.plaf.gtk.GTKLookAndFeel");
			else
				UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
}
