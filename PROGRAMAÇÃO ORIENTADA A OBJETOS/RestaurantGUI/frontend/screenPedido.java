/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Pedido
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : screenPedido.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : Screen of control order, place request
--
--
--------------------------------------------------------------------------------

*/

package frontend;

import java.awt.BorderLayout;
import java.util.Random;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.SwingConstants;
import java.awt.Font;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.awt.Color;
import javax.swing.JComboBox;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;

import backend.Pratos;

import javax.swing.UIManager;
import javax.swing.border.CompoundBorder;
import javax.swing.border.BevelBorder;
import javax.swing.border.LineBorder;
import javax.swing.JTextField;
import javax.swing.JTextPane;
import javax.swing.JSpinner;
import javax.swing.JTextArea;
import javax.swing.JFormattedTextField;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ItemListener;
import java.awt.event.ItemEvent;

public class screenPedido extends JFrame {
	ArrayList<Pratos> ListaPedido;
	private JPanel contentPane;
	private JTextField txt_total;
	JComboBox cBox_prato1;
	JComboBox cBox_prato2;
	JComboBox cBox_prato3;
	JComboBox cbox_refri;
	JComboBox cbox_agua;
	JComboBox cbox_cerveja;
	JSpinner spin_agua = new JSpinner();
	JSpinner spin_refri = new JSpinner();
	JSpinner spin_cerveja = new JSpinner();
	private float precoTotal;

	final double PRECO_COCA = 8.0;
	final double PRECO_FANTA = 7.0;
	final double PRECO_SPRITE = 7.0;
	final double PRECO_AGUA_GAS = 4.0;
	final double PRECO_AGUA_nGAS = 3.0;
	final double PRECO_BRAHMA = 8.0;
	final double PRECO_BUDW = 10.0;
	final double PRECO_QUILMES = 12.0;
	private JTextField txt_preco_prato1;
	private JTextField txt_preco_prato2;
	private JTextField txt_preco_prato3;

	// ---------------CARREGA TABELA DE PRATOS--------------//
	public void LoadCBoxs() {

		cBox_prato1.addItem("<Selecione>");
		cBox_prato2.addItem("<Selecione>");
		cBox_prato3.addItem("<Selecione>");
		cbox_agua.addItem("<Selecione>");
		cbox_refri.addItem("<Selecione>");
		cbox_cerveja.addItem("<Selecione>");
		for (int i = 0; i < ListaPedido.size(); i++) {
			cBox_prato1.addItem(ListaPedido.get(i).getNome());
			cBox_prato2.addItem(ListaPedido.get(i).getNome());
			cBox_prato3.addItem(ListaPedido.get(i).getNome());
		}
		cbox_agua.addItem("Com gás");
		cbox_agua.addItem("Sem gás");
		cbox_refri.addItem("Coca-Cola");
		cbox_refri.addItem("Fanta Laranja");
		cbox_refri.addItem("Sprite");
		cbox_cerveja.addItem("Brahma");
		cbox_cerveja.addItem("Budweiser");
		cbox_cerveja.addItem("Quilmes");

	}

	// --------------------------------------------------//
	/**
	 * Launch the application.
	 */

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					screenPedido frame = new screenPedido();
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
	public screenPedido() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 534);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);

		JPanel panel = new JPanel();
		panel.setBackground(new Color(30, 144, 255));
		panel.setBounds(10, 11, 399, 40);
		contentPane.add(panel);
		panel.setLayout(null);

		JLabel lblPedido = new JLabel("Pedido");
		lblPedido.setForeground(new Color(255, 255, 255));
		lblPedido.setFont(new Font("Tahoma", Font.BOLD, 18));
		lblPedido.setHorizontalAlignment(SwingConstants.CENTER);
		lblPedido.setBounds(10, 0, 379, 40);
		panel.add(lblPedido);

		JPanel panel_1 = new JPanel();
		panel_1.setBorder(new TitledBorder(new LineBorder(new Color(0, 0, 0)), "Pratos", TitledBorder.LEADING,
				TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_1.setBounds(10, 76, 399, 172);
		contentPane.add(panel_1);
		panel_1.setLayout(null);

		cBox_prato1 = new JComboBox();
		cBox_prato1.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent arg0) {
				String nome = (String) cBox_prato1.getSelectedItem();
				if (nome == "<Selecione>") {
					txt_preco_prato1.setText("");
				} else {
					for (int i = 0; i < ListaPedido.size(); i++) {
						if (nome == ListaPedido.get(i).getNome()) {
							txt_preco_prato1.setText(String.valueOf(ListaPedido.get(i).getPreco()));
							i = ListaPedido.size();
						}
					}
				}
			}
		});
		cBox_prato1.setBounds(85, 28, 197, 20);
		panel_1.add(cBox_prato1);

		cBox_prato3 = new JComboBox();
		cBox_prato3.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent e) {
				String nome = (String) cBox_prato3.getSelectedItem();
				if (nome == "<Selecione>") {
					txt_preco_prato3.setText("");
				} else {
					for (int i = 0; i < ListaPedido.size(); i++) {
						if (nome == ListaPedido.get(i).getNome()) {
							txt_preco_prato3.setText(String.valueOf(ListaPedido.get(i).getPreco()));
							i = ListaPedido.size();
						}
					}
				}

			}
		});
		cBox_prato3.setBounds(85, 116, 197, 20);
		panel_1.add(cBox_prato3);

		JLabel lbl_prato3 = new JLabel("3\u00B0 Prato:");
		lbl_prato3.setBounds(20, 115, 55, 23);
		panel_1.add(lbl_prato3);

		cBox_prato2 = new JComboBox();
		cBox_prato2.addItemListener(new ItemListener() {
			public void itemStateChanged(ItemEvent e) {
				String nome = (String) cBox_prato2.getSelectedItem();
				if (nome == "<Selecione>") {
					txt_preco_prato2.setText("");
				} else {
					for (int i = 0; i < ListaPedido.size(); i++) {
						if (nome == ListaPedido.get(i).getNome()) {
							txt_preco_prato2.setText(String.valueOf(ListaPedido.get(i).getPreco()));
							i = ListaPedido.size();
						}
					}
				}
			}
		});
		cBox_prato2.setBounds(85, 72, 197, 20);
		panel_1.add(cBox_prato2);

		JLabel lbl_prato2 = new JLabel("2\u00B0 Prato:");
		lbl_prato2.setBounds(20, 71, 55, 23);
		panel_1.add(lbl_prato2);

		JLabel lbl_prato1 = new JLabel("1\u00B0 Prato:");
		lbl_prato1.setBounds(20, 27, 55, 23);
		panel_1.add(lbl_prato1);

		txt_preco_prato1 = new JTextField();
		txt_preco_prato1.setEditable(false);
		txt_preco_prato1.setBounds(318, 28, 71, 20);
		panel_1.add(txt_preco_prato1);
		txt_preco_prato1.setColumns(10);

		txt_preco_prato2 = new JTextField();
		txt_preco_prato2.setEditable(false);
		txt_preco_prato2.setColumns(10);
		txt_preco_prato2.setBounds(318, 72, 71, 20);
		panel_1.add(txt_preco_prato2);

		txt_preco_prato3 = new JTextField();
		txt_preco_prato3.setEditable(false);
		txt_preco_prato3.setColumns(10);
		txt_preco_prato3.setBounds(318, 116, 71, 20);
		panel_1.add(txt_preco_prato3);

		JLabel lblR_1 = new JLabel("R$:");
		lblR_1.setBounds(292, 31, 46, 14);
		panel_1.add(lblR_1);

		JLabel label = new JLabel("R$:");
		label.setBounds(292, 75, 46, 14);
		panel_1.add(label);

		JLabel label_1 = new JLabel("R$:");
		label_1.setBounds(292, 119, 46, 14);
		panel_1.add(label_1);

		JPanel panel_2 = new JPanel();
		panel_2.setBorder(new TitledBorder(new LineBorder(new Color(0, 0, 0)), "Bebidas", TitledBorder.LEADING,
				TitledBorder.TOP, null, null));
		panel_2.setBounds(10, 254, 399, 143);
		contentPane.add(panel_2);
		panel_2.setLayout(null);

		JLabel lbl_cerveja = new JLabel("Cerveja:");
		lbl_cerveja.setBounds(20, 105, 82, 27);
		panel_2.add(lbl_cerveja);

		cbox_cerveja = new JComboBox();
		cbox_cerveja.setBounds(112, 108, 132, 20);
		panel_2.add(cbox_cerveja);

		JLabel lbl_qtd_cerveja = new JLabel("Qtd.");
		lbl_qtd_cerveja.setBounds(266, 111, 46, 14);
		panel_2.add(lbl_qtd_cerveja);

		JLabel lbl_agua = new JLabel("\u00C1gua:");
		lbl_agua.setBounds(20, 64, 82, 27);
		panel_2.add(lbl_agua);

		cbox_agua = new JComboBox();
		cbox_agua.setBounds(112, 67, 132, 20);
		panel_2.add(cbox_agua);

		JLabel lbl_qtd_agua = new JLabel("Qtd.");
		lbl_qtd_agua.setBounds(266, 70, 46, 14);
		panel_2.add(lbl_qtd_agua);

		JLabel lbl_refri = new JLabel("Refrigerante:");
		lbl_refri.setBounds(20, 18, 82, 27);
		panel_2.add(lbl_refri);

		cbox_refri = new JComboBox();
		cbox_refri.setBounds(112, 21, 132, 20);
		panel_2.add(cbox_refri);

		JLabel lbl_qtd_refri = new JLabel("Qtd.");
		lbl_qtd_refri.setBounds(266, 24, 46, 14);
		panel_2.add(lbl_qtd_refri);

		// JSpinner spin_refri = new JSpinner();
		spin_refri.setBounds(304, 21, 29, 20);
		panel_2.add(spin_refri);

		// JSpinner spin_agua = new JSpinner();
		spin_agua.setBounds(304, 67, 29, 20);
		panel_2.add(spin_agua);

		// JSpinner spin_cerveja = new JSpinner();
		spin_cerveja.setBounds(304, 108, 29, 20);
		panel_2.add(spin_cerveja);

		JLabel lbl_total = new JLabel("Total:");
		lbl_total.setFont(new Font("Tahoma", Font.BOLD, 14));
		lbl_total.setBounds(10, 408, 61, 40);
		contentPane.add(lbl_total);

		txt_total = new JTextField();
		txt_total.setEditable(false);
		txt_total.setBounds(81, 420, 86, 20);
		contentPane.add(txt_total);
		txt_total.setColumns(10);

		JLabel lblR = new JLabel("R$");
		lblR.setBounds(60, 423, 46, 14);
		contentPane.add(lblR);

		JButton btn_pedido = new JButton("Efetuar Pedido");
		btn_pedido.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				getPedido();
			}
		});
		btn_pedido.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				JOptionPane.showMessageDialog(null, "Pedido Efetuado!");
				txt_preco_prato1.setText("");
				txt_preco_prato2.setText("");
				txt_preco_prato3.setText("");
				txt_total.setText("");
				cBox_prato1.setSelectedIndex(0);
				cBox_prato2.setSelectedIndex(0);
				cBox_prato3.setSelectedIndex(0);
				cbox_agua.setSelectedIndex(0);
				cbox_cerveja.setSelectedIndex(0);
				cbox_refri.setSelectedIndex(0);
				spin_agua.setValue(0);
				spin_refri.setValue(0);
				spin_cerveja.setValue(0);

			}
		});
		btn_pedido.setBounds(10, 459, 118, 23);
		contentPane.add(btn_pedido);

		JButton btn_cancelar = new JButton("Cancelar");
		btn_cancelar.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				txt_preco_prato1.setText("");
				txt_preco_prato2.setText("");
				txt_preco_prato3.setText("");
				txt_total.setText("");
				cBox_prato1.setSelectedIndex(0);
				cBox_prato2.setSelectedIndex(0);
				cBox_prato3.setSelectedIndex(0);
				cbox_agua.setSelectedIndex(0);
				cbox_cerveja.setSelectedIndex(0);
				cbox_refri.setSelectedIndex(0);
				spin_agua.setValue(0);
				spin_refri.setValue(0);
				spin_cerveja.setValue(0);
			}
		});
		btn_cancelar.setBounds(182, 459, 86, 23);
		contentPane.add(btn_cancelar);

		JButton btn_voltar = new JButton("Voltar");
		btn_voltar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenMenu windowMenu = new screenMenu();
				windowMenu.setVisible(true);
				dispose();
			}
		});
		btn_voltar.setBounds(323, 459, 86, 23);
		contentPane.add(btn_voltar);

		JButton btnCacularPedido = new JButton("Calcular Pedido");
		btnCacularPedido.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {

				precoTotal = 0;

				if (cBox_prato1.getSelectedIndex() != 0) {
					float p1 = Float.parseFloat(txt_preco_prato1.getText());
					precoTotal += p1;
				}
				if (cBox_prato2.getSelectedIndex() != 0) {
					float p2 = Float.parseFloat(txt_preco_prato2.getText());
					precoTotal += p2;
				}
				if (cBox_prato3.getSelectedIndex() != 0) {
					float p3 = Float.parseFloat(txt_preco_prato3.getText());
					precoTotal += p3;
				}

				// REFRIGERANTES
				if (cbox_refri.getSelectedIndex() == 1) {
					int value = (int) spin_refri.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_COCA * (float) value);

				} else if (cbox_refri.getSelectedIndex() == 2 || cbox_refri.getSelectedIndex() == 3) {
					int value = (int) spin_refri.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_FANTA * (float) value);

				}
				// ----------------------------------------------------//

				// AGUA
				if (cbox_agua.getSelectedIndex() == 1) {
					int value = (int) spin_agua.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_AGUA_GAS * (float) value);

				} else if (cbox_agua.getSelectedIndex() == 2) {
					int value = (int) spin_agua.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_AGUA_nGAS * (float) value);

				}

				// CERVEJA
				if (cbox_cerveja.getSelectedIndex() == 1) {
					int value = (int) spin_cerveja.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_BRAHMA * (float) value);

				} else if (cbox_cerveja.getSelectedIndex() == 2) {
					int value = (int) spin_cerveja.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_BUDW * (float) value);

				} else if (cbox_cerveja.getSelectedIndex() == 3) {
					int value = (int) spin_cerveja.getValue();
					if (value != 0)
						precoTotal += ((float) PRECO_QUILMES * (float) value);

				}

				txt_total.setText(String.valueOf(precoTotal));

			}
		});
		btnCacularPedido.setBounds(217, 419, 141, 23);
		contentPane.add(btnCacularPedido);

		// -------------------Lê do txt-------------------------------//
		String nome = "C:\\Users\\dedeus\\Desktop\\JavaGUI\\Pratos.txt";
		FileReader arq1 = null;
		try {
			arq1 = new FileReader(nome);
		} catch (FileNotFoundException e1) {
			JOptionPane.showMessageDialog(null, "Sem Pratos!", "Denied", JOptionPane.WARNING_MESSAGE);
			e1.printStackTrace();
		}
		BufferedReader lerArq = new BufferedReader(arq1);

		ListaPedido = new ArrayList();
		// float preco = 0;
		String name = "";

		int i = 0;
		String linha = "Teste";
		while (linha != null) {

			if (linha != null) {
				try {
					linha = lerArq.readLine();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				if (i == 1) {
					name = linha;
					i++;

				} else if (i == 3) {
					float preco = Float.parseFloat(linha);
					Pratos P = new Pratos(0, name, "", preco);
					ListaPedido.add(P);
					i = 0;
				} else {
					i++;
				}

			}

		}

		try {
			arq1.close();
		} catch (IOException e1) {
			JOptionPane.showMessageDialog(null, "Erro ao fechar arquivo!", "Denied", JOptionPane.WARNING_MESSAGE);
			e1.printStackTrace();
		}
		LoadCBoxs();

	}

	public void getPedido() {

		FileWriter arq_pedido = null;

		try {
			arq_pedido = new FileWriter("C:\\Users\\dedeus\\Desktop\\JavaGUI\\pedido.txt", true);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PrintWriter gravarArq = new PrintWriter(arq_pedido);

		Random gerador = new Random();
		gravarArq.println("\n\n");
		gravarArq.println("+----------------------------------------+");
		gravarArq.print("+------PEDIDO EFETUADO N:");
		gravarArq.print(gerador.nextInt(100));
		gravarArq.println("------+");

		gravarArq.print("|----- Prato 1: ");
		if (cBox_prato1.getSelectedItem() != "<Selecione>") {
			gravarArq.println(cBox_prato1.getSelectedItem());
		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|----- Prato 2: ");
		if (cBox_prato2.getSelectedItem() != "<Selecione>") {
			gravarArq.println(cBox_prato2.getSelectedItem());

		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|----- Prato 3: ");
		if (cBox_prato3.getSelectedItem() != "<Selecione>") {
			gravarArq.println(cBox_prato3.getSelectedItem());
		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|----- Refrig.: ");
		if (cbox_refri.getSelectedItem() != "<Selecione>") {
			gravarArq.print(cbox_refri.getSelectedItem());
			gravarArq.print(" x");
			gravarArq.println(spin_refri.getValue());

		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|----- Agua: ");
		if (cbox_agua.getSelectedItem() != "<Selecione>") {
			gravarArq.print(cbox_agua.getSelectedItem());
			gravarArq.print(" x");
			gravarArq.println(spin_agua.getValue());
		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|----- Cerveja: ");
		if (cbox_cerveja.getSelectedItem() != "<Selecione>") {
			gravarArq.print(cbox_cerveja.getSelectedItem());
			gravarArq.print(" x");
			gravarArq.println(spin_cerveja.getValue());
		} else {
			gravarArq.println("-");
		}

		gravarArq.print("|-----TOTAL DO PEDIDO: R$");
		gravarArq.print(txt_total.getText());
		gravarArq.println(" ---+");

		try {
			arq_pedido.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		gravarArq.close();

	}

}
