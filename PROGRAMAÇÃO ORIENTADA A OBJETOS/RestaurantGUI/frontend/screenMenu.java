/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Menu de acesso
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : screenMenu.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : Screen of access menu (Order, Register and plates) 
--
--
--------------------------------------------------------------------------------

*/

package frontend;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.GridBagLayout;
import com.jgoodies.forms.layout.FormLayout;
import com.jgoodies.forms.layout.ColumnSpec;
import com.jgoodies.forms.layout.RowSpec;
import com.jgoodies.forms.layout.FormSpecs;
import java.awt.GridLayout;
import java.awt.CardLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class screenMenu extends JFrame {

	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					screenMenu frame = new screenMenu();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public screenMenu() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 407);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);

		JPanel panel = new JPanel();
		panel.setBackground(new Color(0, 0, 255));
		panel.setBounds(10, 11, 414, 60);
		contentPane.add(panel);
		panel.setLayout(null);

		JLabel lblMenuDeAcesso = new JLabel(" Menu de Acesso");
		lblMenuDeAcesso.setForeground(Color.WHITE);
		lblMenuDeAcesso.setFont(new Font("Tahoma", Font.PLAIN, 16));
		lblMenuDeAcesso.setHorizontalAlignment(SwingConstants.CENTER);
		lblMenuDeAcesso.setBounds(10, 11, 394, 38);
		panel.add(lblMenuDeAcesso);

		JButton btn_pratos = new JButton("Pratos");
		btn_pratos.setFont(new Font("Tahoma", Font.BOLD, 16));
		btn_pratos.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenPratos windowPratos;

				windowPratos = new screenPratos();
				windowPratos.setVisible(true);

				dispose();
			}
		});
		btn_pratos.setBackground(new Color(58, 65, 84));
		btn_pratos.setForeground(Color.WHITE);
		btn_pratos.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btn_pratos.setBackground(new Color(235, 235, 235));
				btn_pratos.setForeground(new Color(58, 65, 84));
			}

			@Override
			public void mouseExited(MouseEvent e) {
				btn_pratos.setBackground(new Color(58, 65, 84));
				btn_pratos.setForeground(Color.WHITE);
			}
		});
		btn_pratos.setBounds(94, 300, 246, 51);
		contentPane.add(btn_pratos);

		JButton btn_tables = new JButton("Pedido");
		btn_tables.setFont(new Font("Tahoma", Font.BOLD, 16));
		btn_tables.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenPedido windowMesas;

				windowMesas = new screenPedido();
				windowMesas.setVisible(true);

				dispose();
			}
		});
		btn_tables.setBackground(new Color(58, 65, 84));
		btn_tables.setForeground(Color.WHITE);
		btn_tables.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btn_tables.setBackground(new Color(235, 235, 235));
				btn_tables.setForeground(new Color(58, 65, 84));
			}

			@Override
			public void mouseExited(MouseEvent e) {
				btn_tables.setBackground(new Color(58, 65, 84));
				btn_tables.setForeground(Color.WHITE);
			}
		});
		btn_tables.setBounds(94, 137, 246, 51);
		contentPane.add(btn_tables);

		JButton btn_cadastro = new JButton("Cadastro");
		btn_cadastro.setFont(new Font("Tahoma", Font.BOLD, 16));
		btn_cadastro.setBackground(new Color(58, 65, 84));
		btn_cadastro.setForeground(Color.WHITE);
		btn_cadastro.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				screenRegister windowRegister;
				try {
					windowRegister = new screenRegister();
					windowRegister.setVisible(true);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				dispose();
			}
		});
		btn_cadastro.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btn_cadastro.setBackground(new Color(235, 235, 235));
				btn_cadastro.setForeground(new Color(58, 65, 84));
			}

			@Override
			public void mouseExited(MouseEvent e) {
				btn_cadastro.setBackground(new Color(58, 65, 84));
				btn_cadastro.setForeground(Color.WHITE);
			}
		});
		btn_cadastro.setBounds(94, 218, 246, 51);
		contentPane.add(btn_cadastro);
	}

}
