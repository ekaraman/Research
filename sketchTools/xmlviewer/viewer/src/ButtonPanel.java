import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;


public class ButtonPanel extends JPanel {

	private static final long serialVersionUID = 1L;

	public ButtonPanel(ActionListener listener) {
		super(new GridLayout(1,3));
		setBackground(Color.lightGray);	
		JButton button = new JButton("Choose File...");
		button.addActionListener(listener);
		add(new JLabel());
		add(button);
		add(new JLabel());
	}
	
	
}
