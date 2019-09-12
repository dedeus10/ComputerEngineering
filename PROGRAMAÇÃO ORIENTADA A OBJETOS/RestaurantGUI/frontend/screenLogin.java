/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                        --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Login
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : screenLogin.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : First screen of project restaurantGUI, login screen
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

import backend.Pratos;

import java.awt.Color;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import java.awt.HeadlessException;
import java.awt.List;

import javax.swing.SwingConstants;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JTextField;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberInputStream;
import java.util.ArrayList;

import javax.swing.JPasswordField;

public class screenLogin extends JFrame {

	private JPanel contentPane;
	private JTextField txt_id;
	private JPasswordField txt_passwd;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					screenLogin frame = new screenLogin();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	// Função que verifica se o usuario existe
	public boolean checkLogin(String login, String senha) throws IOException {

		if (login.equals("admin") && senha.equals("admin")) {
			return true;
		}

		// -------------------Lê do txt-------------------------------//
		String nome = "C:\\Users\\dedeus\\Desktop\\JavaGUI\\login.txt";
		FileReader arq1 = new FileReader(nome);
		BufferedReader lerArq = new BufferedReader(arq1);

		int i = 0;
		int login_ok = 0;
		String linha = "";
		while (linha != null) {

			linha = lerArq.readLine();
			if (linha != null) {
				if (i == 0) {
					if (login.equals(linha)) {
						login_ok = 1;
					}
					i++;
				} else if (i == 1) {
					if (login_ok == 1 && senha.equals(linha)) {
						arq1.close();
						lerArq.close();
						return true;
					}
					i = 0;
				}
			}

		}
		lerArq.close();
		arq1.close();
		return false;
	}

	/**
	 * Create the frame.
	 */
	public screenLogin() {
		setResizable(false);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 411, 407);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);

		JPanel panel = new JPanel();
		panel.setBackground(Color.BLUE);
		panel.setBounds(0, 0, 481, 72);
		contentPane.add(panel);
		panel.setLayout(null);

		JLabel lblNewLabel = new JLabel("Login de Acesso");
		lblNewLabel.setHorizontalAlignment(SwingConstants.CENTER);
		lblNewLabel.setForeground(Color.WHITE);
		lblNewLabel.setFont(new Font("Microsoft YaHei", Font.PLAIN, 24));
		lblNewLabel.setBounds(0, 11, 406, 50);
		panel.add(lblNewLabel);

		JPanel panel_1 = new JPanel();
		panel_1.setBounds(0, 77, 404, 302);
		contentPane.add(panel_1);
		panel_1.setLayout(null);

		JButton btn_entrar = new JButton("Entrar");
		btn_entrar.setBackground(new Color(58, 65, 84));
		btn_entrar.setForeground(Color.WHITE);
		btn_entrar.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent arg0) {
				btn_entrar.setBackground(new Color(235, 235, 235));
				btn_entrar.setForeground(new Color(58, 65, 84));
			}

			@Override
			public void mouseExited(MouseEvent e) {
				btn_entrar.setBackground(new Color(58, 65, 84));
				btn_entrar.setForeground(Color.WHITE);
			}

		});

		btn_entrar.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btn_entrar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					if (checkLogin(txt_id.getText(), new String(txt_passwd.getPassword()))) {
						JOptionPane.showMessageDialog(null, "Bem vindo!");
						screenMenu windowOne = new screenMenu();
						windowOne.setVisible(true);
						dispose();

					} else {
						JOptionPane.showMessageDialog(null, "Acesso Negado!", "Denied", JOptionPane.WARNING_MESSAGE);
						txt_id.setText("");
						txt_passwd.setText("");
					}
				} catch (HeadlessException e) {

					e.printStackTrace();
				} catch (IOException e) {

					e.printStackTrace();
				}
			}
		});

		btn_entrar.setBounds(10, 208, 384, 30);
		panel_1.add(btn_entrar);

		JButton btn_Sair = new JButton("Sair");
		btn_Sair.setBackground(new Color(217, 81, 51));
		btn_Sair.setForeground(Color.WHITE);
		btn_Sair.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btn_Sair.setBackground(new Color(235, 235, 235));
				btn_Sair.setForeground(new Color(217, 81, 51));
			}

			@Override
			public void mouseExited(MouseEvent e) {
				btn_Sair.setBackground(new Color(217, 81, 51));
				btn_Sair.setForeground(Color.WHITE);
			}
		});
		btn_Sair.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.exit(0);
			}
		});
		btn_Sair.setBounds(10, 250, 384, 30);
		panel_1.add(btn_Sair);

		JLabel lbl_Id = new JLabel("ID:");
		lbl_Id.setFont(new Font("Tahoma", Font.PLAIN, 12));
		lbl_Id.setBounds(10, 79, 46, 14);
		panel_1.add(lbl_Id);

		JLabel lbl_Senha = new JLabel("Senha:");
		lbl_Senha.setFont(new Font("Tahoma", Font.PLAIN, 12));
		lbl_Senha.setBounds(10, 108, 46, 14);
		panel_1.add(lbl_Senha);

		txt_id = new JTextField();
		txt_id.setBounds(66, 77, 223, 20);
		panel_1.add(txt_id);
		txt_id.setColumns(10);

		txt_passwd = new JPasswordField();
		txt_passwd.setBounds(66, 106, 223, 20);
		panel_1.add(txt_passwd);
	}
}
