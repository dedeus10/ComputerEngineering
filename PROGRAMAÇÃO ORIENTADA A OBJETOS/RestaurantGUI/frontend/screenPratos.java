/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Pratos
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : screenPratos.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : This screen show yours plates registered
--
--
--------------------------------------------------------------------------------

*/


package frontend;

import backend.Pratos;
import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import javax.swing.SwingConstants;
import java.awt.Color;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class screenPratos extends JFrame {

	private JPanel contentPane;
	ArrayList<Pratos> ListaP;
	private JTable tbl_menu;

	// ---------------CARREGA TABELA DE PRATOS--------------//
	public void LoadTablePratos() {

		DefaultTableModel modelo = new DefaultTableModel(new Object[] { "Cod", "Nome", "Desc.", "Preço" }, 0);

		for (int i = 0; i < ListaP.size(); i++) {
			Object linha[] = new Object[] { ListaP.get(i).getCodigo(), ListaP.get(i).getNome(),
					ListaP.get(i).getDescricao(), ListaP.get(i).getPreco() };
			modelo.addRow(linha);
		}
		tbl_menu.setModel(modelo);
	}

	// --------------------------------------------------//

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					screenPratos frame = new screenPratos();
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
	public screenPratos() {

		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 490, 484);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);

		JPanel panel = new JPanel();
		panel.setBounds(10, 11, 454, 51);
		panel.setBackground(new Color(30, 144, 255));
		contentPane.add(panel);
		panel.setLayout(null);

		JLabel lbl_menu = new JLabel("Menu");
		lbl_menu.setForeground(Color.WHITE);
		lbl_menu.setHorizontalAlignment(SwingConstants.CENTER);
		lbl_menu.setFont(new Font("Tahoma", Font.BOLD, 18));
		lbl_menu.setBounds(10, 11, 434, 29);
		panel.add(lbl_menu);

		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(10, 73, 454, 328);
		contentPane.add(scrollPane);

		tbl_menu = new JTable();
		scrollPane.setViewportView(tbl_menu);
		tbl_menu.setModel(
				new DefaultTableModel(new Object[][] {}, new String[] { "Cod.", "Nome", "Desc.", "Pre\u00E7o" }) {
					Class[] columnTypes = new Class[] { Integer.class, String.class, String.class, Float.class };

					public Class getColumnClass(int columnIndex) {
						return columnTypes[columnIndex];
					}

					boolean[] columnEditables = new boolean[] { false, false, false, false };

					public boolean isCellEditable(int row, int column) {
						return columnEditables[column];
					}
				});

		JButton btnVoltar = new JButton("Voltar");
		btnVoltar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenMenu windowMenu = new screenMenu();
				windowMenu.setVisible(true);
				dispose();
			}
		});
		btnVoltar.setBounds(186, 412, 89, 23);
		contentPane.add(btnVoltar);
		tbl_menu.getColumnModel().getColumn(0).setResizable(false);
		tbl_menu.getColumnModel().getColumn(1).setResizable(false);
		tbl_menu.getColumnModel().getColumn(2).setResizable(false);
		tbl_menu.getColumnModel().getColumn(3).setResizable(false);

//-------------------Lê do txt-------------------------------//		
		String nome = "C:\\Users\\dedeus\\Desktop\\JavaGUI\\Pratos.txt";
		FileReader arq1 = null;
		try {
			arq1 = new FileReader(nome);
		} catch (FileNotFoundException e2) {
			JOptionPane.showMessageDialog(null, "Sem Pratos!", "Denied", JOptionPane.WARNING_MESSAGE);
			e2.printStackTrace();
			
		}
		BufferedReader lerArq = new BufferedReader(arq1);

		ListaP = new ArrayList();
		int cod = 0;
		String name = "";
		String des = "";
		int i = 0;
		float preco;
		String linha = "Teste";
		while (linha != null) {

			try {
				linha = lerArq.readLine();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				JOptionPane.showMessageDialog(null, "Sem Pratos!", "Denied", JOptionPane.WARNING_MESSAGE);
				e1.printStackTrace();
			}
			if (linha != null) {
				if (i == 0) {
					cod = Integer.parseInt(linha);
					i++;
				} else if (i == 1) {
					name = linha;
					i++;
				} else if (i == 2) {
					des = linha;
					i++;

				} else if (i == 3) {
					preco = Float.parseFloat(linha);
					Pratos P = new Pratos(cod, name, des, preco);
					ListaP.add(P);
					i = 0;
				}
			}

		}

		try {
			arq1.close();
		} catch (IOException e1) {
			JOptionPane.showMessageDialog(null, "Erro ao fechar arquivo!", "Denied", JOptionPane.WARNING_MESSAGE);
			e1.printStackTrace();
		}
		LoadTablePratos();

	}
}
