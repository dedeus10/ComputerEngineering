/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Register
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : screenRegister.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : this screen registers departments, employees and dishes 
--
--
--------------------------------------------------------------------------------

*/


package frontend;

import backend.Departamento;
import backend.Funcionario;
import backend.FuncionarioAvancado;
import backend.Pratos;
import java.awt.BorderLayout;
import java.awt.EventQueue;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JDesktopPane;
import javax.swing.JInternalFrame;
import javax.swing.JLayeredPane;
import javax.swing.JToolBar;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.table.DefaultTableModel;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Color;
import java.awt.Font;
import javax.swing.border.BevelBorder;
import javax.swing.JList;
import javax.swing.AbstractListModel;
import javax.swing.JScrollPane;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.CompoundBorder;
import javax.swing.border.TitledBorder;
import javax.swing.border.LineBorder;
import javax.swing.JLabel;
import javax.swing.JTextField;
import java.util.ArrayList;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.SwingConstants;
import javax.swing.DropMode;
import javax.swing.JRadioButton;
import javax.swing.JMenuBar;
import javax.swing.JComboBox;
import javax.swing.JCheckBox;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import javax.swing.JPasswordField;

public class screenRegister extends JFrame {
	ArrayList<Departamento> ListaDep;
	ArrayList<Pratos> ListaPratos;
	ArrayList<Funcionario> ListaFunc;

//---------------CARREGA TABELA DE DEPARTMENTOS----------//	
	public void LoadTableDep() {
		DefaultTableModel modelo = new DefaultTableModel(new Object[] { "Código", "Nome" }, 0);

		for (int i = 0; i < ListaDep.size(); i++) {
			Object linha[] = new Object[] { ListaDep.get(i).getCodigo(), ListaDep.get(i).getNome() };
			modelo.addRow(linha);
		}
		tbl_dep_dpts.setModel(modelo);
	}

//---------------CARREGA TABELA DE PRATOS--------------//	
	public void LoadTablePratos() {
		DefaultTableModel modelo = new DefaultTableModel(new Object[] { "Código", "Nome", "Preço" }, 0);

		for (int i = 0; i < ListaPratos.size(); i++) {
			Object linha[] = new Object[] { ListaPratos.get(i).getCodigo(), ListaPratos.get(i).getNome(),
					ListaPratos.get(i).getPreco() };
			modelo.addRow(linha);
		}
		tbl_pratos.setModel(modelo);
	}

//--------------------------------------------------//

//---------------CARREGA TABELA DE FUNCIONARIOS--------------//	
	public void LoadTableFunc() {
		DefaultTableModel modelo = new DefaultTableModel(new Object[] { "Nome", "Idade", "CPF", "Dept." }, 0);

		for (int i = 0; i < ListaFunc.size(); i++) {
			Object linha[] = new Object[] { ListaFunc.get(i).getNome(), ListaFunc.get(i).getIdade(),
					ListaFunc.get(i).getCpf(), ListaFunc.get(i).getDept(), };
			modelo.addRow(linha);
		}
		tbl_func.setModel(modelo);
	}

	// --------------------------------------------------//

	private JTable tbl_dep_dpts;
	private JTextField c_dep_codigo;
	private JTextField c_dep_nome;

	private JButton btn_dep_salvar;
	private JButton btn_dep_novo;
	private JButton btn_dep_cancelar;
	private JButton btn_dep_editar;
	private JButton btn_dep_excluir;

	private JButton btn_pratos_editar;
	private JButton btn_pratos_excluir;
	private JButton btn_pratos_novo;
	private JButton btn_pratos_salvar;
	private JButton btn_pratos_cancelar;

	private JButton btn_func_salvar;
	private JButton btn_func_cancelar;
	private JButton btn_func_novo;
	private JButton btn_func_excluir;
	private JButton btn_func_editar;

	String modo = "Navegar";
	private JTextField txt_pratos_cod;
	private JTextField txt_pratos_nome;
	private JTable tbl_pratos;
	private JTextField txt_pratos_desc;
	private JLabel lbl_dep_base;
	private JTextField txt_dep_base;
	private JPanel Funcionarios;
	private JPanel panel_3;
	private JLabel lbl_func_nome;
	private JTextField txt_func_nome;
	private JTextField txt_func_idade;
	private JTextField txt_func_cpf;
	private JTextField txt_func_login;
	private JComboBox comboBox_func;
	private JTable tbl_func;
	private JCheckBox checkBox_func;
	private JButton btn_dep_voltar;
	private JLabel lbl_PreoR;
	private JTextField txt_pratos_prec;
	private JButton btnNewButton;
	private JButton btnNewButton_1;
	private JPasswordField txt_func_senha;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					screenRegister frame = new screenRegister();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 * 
	 * @throws IOException
	 */
	public screenRegister() throws IOException {
		// Cria a Lista de departamentos
		ListaDep = new ArrayList();

		// Cria a Lista de Pratos
		ListaPratos = new ArrayList();

		// Cria a Lista de Pratos
		ListaFunc = new ArrayList();

		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 438, 530);
		getContentPane().setLayout(null);

		JTabbedPane tabbedPane = new JTabbedPane(JTabbedPane.TOP);
		tabbedPane.setBounds(0, 0, 434, 492);
		getContentPane().add(tabbedPane);

		JPanel Departamentos = new JPanel();
		tabbedPane.addTab("Departamentos", null, Departamentos, null);
		Departamentos.setLayout(null);

		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(10, 11, 397, 127);
		Departamentos.add(scrollPane);

//----------------------------- TABELA DE DEPARTAMENTOS -------------------------//		
		tbl_dep_dpts = new JTable();
		tbl_dep_dpts.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				int index = tbl_dep_dpts.getSelectedRow();

				if (index >= 0 && index < ListaDep.size()) {
					Departamento D = ListaDep.get(index);
					c_dep_codigo.setText(String.valueOf(D.getCodigo()));
					c_dep_nome.setText(D.getNome());
					txt_dep_base.setText(String.valueOf(D.getSal_base()));

					modo = "Selecao";
					manipulaInterface();
				}

			}
		});
		tbl_dep_dpts.setModel(new DefaultTableModel(new Object[][] {}, new String[] { "C\u00F3digo", "Nome" }) {
			Class[] columnTypes = new Class[] { Integer.class, String.class };

			public Class getColumnClass(int columnIndex) {
				return columnTypes[columnIndex];
			}
		});
		scrollPane.setViewportView(tbl_dep_dpts);

		JPanel panel_2 = new JPanel();
		panel_2.setBorder(new TitledBorder(new LineBorder(new Color(0, 0, 0)), "Departamento", TitledBorder.LEADING,
				TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_2.setBounds(10, 198, 397, 255);
		Departamentos.add(panel_2);
		panel_2.setLayout(null);
//-----------------------------------------------------------------------------//

//------------------------ LABEL DO CODIGO DEPARTAMENTO ----------------------//		
		JLabel lblCdigo = new JLabel("C\u00F3digo:");
		lblCdigo.setBounds(10, 27, 46, 14);
		panel_2.add(lblCdigo);
//-----------------------------------------------------------------------------//

//------------------------ CAIXA DE TEXTO DO CODIGO DEPARTAMENTO ----------------//		
		c_dep_codigo = new JTextField();
		c_dep_codigo.setEditable(false);
		c_dep_codigo.setBounds(85, 24, 86, 20);
		panel_2.add(c_dep_codigo);
		c_dep_codigo.setColumns(10);
//----------------------------------------------------------------------------//		

//-------------------- LABEL NOME DEPARTAMENTO ----------------------------------///		
		JLabel lblNome = new JLabel("Nome:");
		lblNome.setBounds(10, 61, 46, 14);
		panel_2.add(lblNome);
//-------------------------------------------------------------------------------------//

//------------------ CAIXA DE TEXTO DO NOME DEPARTAMENTO ---------------------------------//		
		c_dep_nome = new JTextField();
		c_dep_nome.setEditable(false);
		c_dep_nome.setBounds(85, 55, 222, 20);
		panel_2.add(c_dep_nome);
		c_dep_nome.setColumns(10);
//--------------------------------------------------------------------------------//		

//--------------------BOTÃO SALVAR DA ABA DEPARTAMENTO-----------------------------//		
		btn_dep_salvar = new JButton("Salvar");
		btn_dep_salvar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int cod = Integer.parseInt(c_dep_codigo.getText());
				int base = Integer.parseInt(txt_dep_base.getText());

				if (modo.equals("Novo")) {
					Departamento D = new Departamento(cod, c_dep_nome.getText(), base);
					ListaDep.add(D);
					comboBox_func.addItem(c_dep_nome.getText());

					FileWriter arq_departamentos = null;

					try {
						arq_departamentos = new FileWriter("C:\\Users\\dedeus\\Desktop\\JavaGUI\\departamentos.txt",
								true);
					} catch (IOException e3) {
						// TODO Auto-generated catch block
						e3.printStackTrace();
					}
					PrintWriter gravarArq = new PrintWriter(arq_departamentos);

					gravarArq.println("\n\n");
					gravarArq.println("+----------------------------+");
					gravarArq.print("DEPARTAMENTO: ");
					gravarArq.println(c_dep_nome.getText());
					gravarArq.print("Código: ");
					gravarArq.println(c_dep_codigo.getText());
					gravarArq.print("Sálario Base: ");
					gravarArq.println(txt_dep_base.getText());

					try {
						arq_departamentos.close();
					} catch (IOException e5) {
						// TODO Auto-generated catch block
						e5.printStackTrace();
					}
					gravarArq.close();

				} else if (modo.equals("Editar")) {
					int index = tbl_dep_dpts.getSelectedRow();
					ListaDep.get(index).setCodigo(cod);
					ListaDep.get(index).setNome(c_dep_nome.getText());
					ListaDep.get(index).setSal_base(base);
				}
				LoadTableDep();

				c_dep_codigo.setText("");
				c_dep_nome.setText("");
				txt_dep_base.setText("");
				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_dep_salvar.setEnabled(false);
		btn_dep_salvar.setBounds(40, 199, 89, 23);
		panel_2.add(btn_dep_salvar);
//---------------------------------------------------------------------------//

//-----------------BOTÃO CANCELAR DA ABA DEPARTAMENTO-----------------------------//		
		btn_dep_cancelar = new JButton("Cancelar");
		btn_dep_cancelar.setEnabled(false);
		btn_dep_cancelar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				c_dep_codigo.setText("");
				c_dep_nome.setText("");
				txt_dep_base.setText("");
				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_dep_cancelar.setBounds(173, 199, 89, 23);
		panel_2.add(btn_dep_cancelar);

		lbl_dep_base = new JLabel("Sal. Base R$:");
		lbl_dep_base.setBounds(10, 98, 76, 14);
		panel_2.add(lbl_dep_base);

		txt_dep_base = new JTextField();
		txt_dep_base.setEditable(false);
		txt_dep_base.setBounds(85, 95, 86, 20);
		panel_2.add(txt_dep_base);
		txt_dep_base.setColumns(10);

		btn_dep_voltar = new JButton("Voltar");
		btn_dep_voltar.setBounds(298, 199, 89, 23);
		panel_2.add(btn_dep_voltar);
		btn_dep_voltar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenMenu windowMenu = new screenMenu();
				windowMenu.setVisible(true);
				dispose();
			}
		});
//---------------------------------------------------------------------------//		

//-----------------BOTÃO NOVO DA ABA DEPARTAMENTO-----------------------------//
		btn_dep_novo = new JButton("Novo");
		btn_dep_novo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				c_dep_codigo.setText("");
				c_dep_nome.setText("");
				txt_dep_base.setText("");

				modo = "Novo";
				manipulaInterface();

			}
		});
		btn_dep_novo.setBounds(10, 149, 89, 23);
		Departamentos.add(btn_dep_novo);
//----------------------------------------------------------------//

//----------------- BOTÃO ECLUIR DA ABA DEPARTAMENTO-----------------------------//		 
		btn_dep_excluir = new JButton("Excluir");
		btn_dep_excluir.setEnabled(false);
		btn_dep_excluir.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				int index = tbl_dep_dpts.getSelectedRow();
				if (index >= 0 && index < ListaDep.size()) {
					ListaDep.remove(index);
					comboBox_func.removeItemAt(index);
				}
				c_dep_codigo.setText("");
				c_dep_nome.setText("");
				txt_dep_base.setText("");
				LoadTableDep();

				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_dep_excluir.setBounds(318, 149, 89, 23);
		Departamentos.add(btn_dep_excluir);
//----------------------------------------------------------------//		 

//----------------BOTÃO EDITAR DA ABA DEPARTAMENTOS--------------//		 
		btn_dep_editar = new JButton("Editar");
		btn_dep_editar.setEnabled(false);
		btn_dep_editar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modo = "Editar";
				manipulaInterface();
			}
		});
		btn_dep_editar.setBounds(164, 149, 89, 23);
		Departamentos.add(btn_dep_editar);
		// -----------------------------------------------------------------------------//

		// -----------------FUNCIONARIOS----------------------------------------------//
		Funcionarios = new JPanel();
		Funcionarios.setLayout(null);
		tabbedPane.addTab("Funcion\u00E1rios", null, Funcionarios, null);

		panel_3 = new JPanel();
		panel_3.setLayout(null);
		panel_3.setBorder(new TitledBorder(new LineBorder(new Color(0, 0, 0)), "Funcion\u00E1rios",
				TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_3.setBounds(10, 198, 397, 266);
		Funcionarios.add(panel_3);

		JScrollPane scrollPane_2 = new JScrollPane();
		scrollPane_2.setBounds(0, 11, 419, 127);
		Funcionarios.add(scrollPane_2);

		tbl_func = new JTable();
		tbl_func.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				int index = tbl_func.getSelectedRow();

				if (index >= 0 && index < ListaFunc.size()) {
					Funcionario F = ListaFunc.get(index);
					txt_func_nome.setText(F.getNome());
					txt_func_idade.setText(String.valueOf(F.getIdade()));
					txt_func_cpf.setText(F.getCpf());
					comboBox_func.setSelectedItem(String.valueOf(F.getDept()));

					modo = "SelecaoF";
					manipulaInterface();
				}
			}
		});
		scrollPane_2.setViewportView(tbl_func);
		tbl_func.setModel(new DefaultTableModel(new Object[][] {}, new String[] { "Nome", "Idade", "CPF", "Dept." }) {
			Class[] columnTypes = new Class[] { String.class, Integer.class, Integer.class, String.class };

			public Class getColumnClass(int columnIndex) {
				return columnTypes[columnIndex];
			}

			boolean[] columnEditables = new boolean[] { false, false, false, false };

			public boolean isCellEditable(int row, int column) {
				return columnEditables[column];
			}
		});
		tbl_func.getColumnModel().getColumn(0).setResizable(false);
		tbl_func.getColumnModel().getColumn(1).setResizable(false);
		tbl_func.getColumnModel().getColumn(2).setResizable(false);
		tbl_func.getColumnModel().getColumn(3).setResizable(false);

		lbl_func_nome = new JLabel("Nome:");
		lbl_func_nome.setBounds(10, 27, 46, 14);
		panel_3.add(lbl_func_nome);

		txt_func_nome = new JTextField();
		txt_func_nome.setEditable(false);
		txt_func_nome.setColumns(10);
		txt_func_nome.setBounds(64, 27, 222, 20);
		panel_3.add(txt_func_nome);

		btn_func_salvar = new JButton("Salvar");
		btn_func_salvar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int idade = Integer.parseInt(txt_func_idade.getText());
				String cBox = (String) comboBox_func.getSelectedItem();

				FileWriter arq_funcio = null;

				try {
					arq_funcio = new FileWriter("C:\\Users\\dedeus\\Desktop\\JavaGUI\\funcionarios.txt", true);
				} catch (IOException e3) {
					// TODO Auto-generated catch block
					e3.printStackTrace();
				}
				PrintWriter gravarArq = new PrintWriter(arq_funcio);

				gravarArq.println("\n\n");
				gravarArq.println("+----------------------------+");
				gravarArq.print("FUNCIONÁRIO: ");
				gravarArq.println(txt_func_nome.getText());
				gravarArq.print("Idade: ");
				gravarArq.println(txt_func_idade.getText());
				gravarArq.print("CPF: ");
				gravarArq.println(txt_func_cpf.getText());
				gravarArq.print("Dept.: ");
				gravarArq.println(comboBox_func.getSelectedItem());
				if (checkBox_func.isSelected()) {
					gravarArq.print("Possui Acesso ao Sistema");
				} else
					gravarArq.print("NÃO Possui Acesso ao Sistema!!!");

				try {
					arq_funcio.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				gravarArq.close();

				if (modo.equals("NovoF")) {
					if (checkBox_func.isSelected()) {
						System.out.println("ola");
						FuncionarioAvancado FA = new FuncionarioAvancado(txt_func_nome.getText(), idade,
								txt_func_cpf.getText(), cBox, txt_func_login.getText(), txt_func_senha.getText());
						ListaFunc.add(FA);

						FileWriter arq_login;
						try {
							arq_login = new FileWriter("C:\\Users\\dedeus\\Desktop\\JavaGUI\\login.txt", true);
							PrintWriter gravarArqLog = new PrintWriter(arq_login);
							gravarArqLog.println(txt_func_login.getText());
							gravarArqLog.println(txt_func_senha.getText());
							arq_login.close();
							gravarArq.close();
						} catch (IOException e2) {
							// TODO Auto-generated catch block
							e2.printStackTrace();
						}

					} else {
						Funcionario F = new Funcionario(txt_func_nome.getText(), idade, txt_func_cpf.getText(), cBox);
						ListaFunc.add(F);
					}

				} else if (modo.equals("EditarF")) {
					int index = tbl_func.getSelectedRow();
					ListaFunc.get(index).setNome(txt_func_nome.getText());
					ListaFunc.get(index).setIdade(idade);
					ListaFunc.get(index).setCpf(txt_func_cpf.getText());
					ListaFunc.get(index).setDept(cBox);
				}

				LoadTableFunc();
				txt_func_cpf.setText("");
				txt_func_idade.setText("");
				txt_func_nome.setText("");
				txt_func_login.setText("");
				txt_func_senha.setText("");

				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_func_salvar.setEnabled(false);
		btn_func_salvar.setBounds(52, 232, 89, 23);
		panel_3.add(btn_func_salvar);

		btn_func_cancelar = new JButton("Cancelar");
		btn_func_cancelar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				txt_func_cpf.setText("");
				txt_func_idade.setText("");
				txt_func_nome.setText("");
				txt_func_login.setText("");
				txt_func_senha.setText("");

				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_func_cancelar.setEnabled(false);
		btn_func_cancelar.setBounds(182, 232, 89, 23);
		panel_3.add(btn_func_cancelar);

		comboBox_func = new JComboBox();
		comboBox_func.setBounds(64, 193, 143, 20);
		panel_3.add(comboBox_func);

		JLabel lbl_func_idade = new JLabel("Idade:");
		lbl_func_idade.setBounds(10, 63, 46, 14);
		panel_3.add(lbl_func_idade);

		txt_func_idade = new JTextField();
		txt_func_idade.setEditable(false);
		txt_func_idade.setBounds(64, 60, 55, 20);
		panel_3.add(txt_func_idade);
		txt_func_idade.setColumns(10);

		JLabel lbl_func_cpf = new JLabel("CPF:");
		lbl_func_cpf.setBounds(10, 97, 46, 14);
		panel_3.add(lbl_func_cpf);

		txt_func_cpf = new JTextField();
		txt_func_cpf.setEditable(false);
		txt_func_cpf.setBounds(64, 94, 143, 20);
		panel_3.add(txt_func_cpf);
		txt_func_cpf.setColumns(10);

		JLabel lbl_func_dep = new JLabel("Dept.");
		lbl_func_dep.setBounds(10, 196, 46, 14);
		panel_3.add(lbl_func_dep);

		JLabel lbl_func_login = new JLabel("Login:");
		lbl_func_login.setBounds(10, 128, 46, 14);
		panel_3.add(lbl_func_login);

		txt_func_login = new JTextField();
		txt_func_login.setEditable(false);
		txt_func_login.setBounds(64, 125, 86, 20);
		panel_3.add(txt_func_login);
		txt_func_login.setColumns(10);

		JLabel lbl_func_senha = new JLabel("Senha:");
		lbl_func_senha.setBounds(10, 160, 46, 14);
		panel_3.add(lbl_func_senha);

		checkBox_func = new JCheckBox("Acesso ao Sistema ?");
		checkBox_func.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				if (checkBox_func.isSelected() && modo == "NovoF") {
					txt_func_login.setEditable(true);
					txt_func_senha.setEditable(true);
				} else {
					txt_func_login.setEditable(false);
					txt_func_senha.setEditable(false);
				}

			}
		});
		checkBox_func.setHorizontalAlignment(SwingConstants.CENTER);
		checkBox_func.setBounds(213, 139, 156, 23);
		panel_3.add(checkBox_func);

		btnNewButton_1 = new JButton("Voltar");
		btnNewButton_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenMenu windowMenu = new screenMenu();
				windowMenu.setVisible(true);
				dispose();
			}
		});
		btnNewButton_1.setBounds(295, 232, 89, 23);
		panel_3.add(btnNewButton_1);

		txt_func_senha = new JPasswordField();
		txt_func_senha.setEditable(false);
		txt_func_senha.setBounds(64, 156, 86, 20);
		panel_3.add(txt_func_senha);

		btn_func_novo = new JButton("Novo");
		btn_func_novo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				txt_func_cpf.setText("");
				txt_func_idade.setText("");
				txt_func_nome.setText("");
				txt_func_login.setText("");
				txt_func_senha.setText("");

				modo = "NovoF";
				manipulaInterface();

			}
		});

		btn_func_novo.setBounds(10, 149, 89, 23);
		Funcionarios.add(btn_func_novo);

		btn_func_excluir = new JButton("Excluir");
		btn_func_excluir.setEnabled(false);
		btn_func_excluir.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int index = tbl_func.getSelectedRow();
				if (index >= 0 && index < ListaFunc.size()) {
					ListaFunc.remove(index);
				}
				LoadTableFunc();

				txt_func_cpf.setText("");
				txt_func_idade.setText("");
				txt_func_nome.setText("");
				txt_func_login.setText("");
				txt_func_senha.setText("");

				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_func_excluir.setBounds(318, 149, 89, 23);
		Funcionarios.add(btn_func_excluir);

		btn_func_editar = new JButton("Editar");
		btn_func_editar.setEnabled(false);
		btn_func_editar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modo = "EditarF";
				manipulaInterface();
			}
		});
		btn_func_editar.setBounds(164, 149, 89, 23);
		Funcionarios.add(btn_func_editar);
//---------------------------------------------------------------//

//----------------------- INICIO DA ABA DE PRATOS -----------------//		 

		JPanel Pratos = new JPanel();
		tabbedPane.addTab("Pratos", null, Pratos, null);
		Pratos.setLayout(null);

		JPanel panel_1 = new JPanel();
		panel_1.setBounds(10, 198, 397, 266);
		panel_1.setLayout(null);
		panel_1.setBorder(new TitledBorder(new LineBorder(new Color(0, 0, 0)), "Pratos", TitledBorder.LEADING,
				TitledBorder.TOP, null, new Color(0, 0, 0)));
		Pratos.add(panel_1);

		JLabel lbl_pratos_cod = new JLabel("C\u00F3digo:");
		lbl_pratos_cod.setBounds(10, 27, 46, 14);
		panel_1.add(lbl_pratos_cod);

		txt_pratos_cod = new JTextField();
		txt_pratos_cod.setEditable(false);
		txt_pratos_cod.setColumns(10);
		txt_pratos_cod.setBounds(66, 24, 86, 20);
		panel_1.add(txt_pratos_cod);

		JLabel lbl_pratos_nome = new JLabel("Nome:");
		lbl_pratos_nome.setBounds(10, 61, 46, 14);
		panel_1.add(lbl_pratos_nome);

		txt_pratos_nome = new JTextField();
		txt_pratos_nome.setEditable(false);
		txt_pratos_nome.setColumns(10);
		txt_pratos_nome.setBounds(66, 58, 222, 20);
		panel_1.add(txt_pratos_nome);

//-----------------BOTÃO SALVAR PRATOS -------------------------------//		 
		btn_pratos_salvar = new JButton("Salvar");
		btn_pratos_salvar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int cod = Integer.parseInt(txt_pratos_cod.getText());
				float preco = Float.parseFloat(txt_pratos_prec.getText());
				if (modo.equals("NovoP")) {
					Pratos P = new Pratos(cod, txt_pratos_nome.getText(), txt_pratos_desc.getText(), preco);
					ListaPratos.add(P);
					P.setListaPratos(ListaPratos);

					FileWriter arq;
					try {
						arq = new FileWriter("C:\\Users\\dedeus\\Desktop\\JavaGUI\\Pratos.txt", true);
						PrintWriter gravarArq = new PrintWriter(arq);

						gravarArq.println(cod);
						gravarArq.println(txt_pratos_nome.getText());
						gravarArq.println(txt_pratos_desc.getText());
						gravarArq.println(preco);
						arq.close();
					} catch (IOException e2) {
						// TODO Auto-generated catch block
						e2.printStackTrace();
					}

				} else if (modo.equals("EditarP")) {
					int index = tbl_pratos.getSelectedRow();
					ListaPratos.get(index).setCodigo(cod);
					ListaPratos.get(index).setNome(txt_pratos_nome.getText());
					ListaPratos.get(index).setDescricao(txt_pratos_desc.getText());
					ListaPratos.get(index).setPreco(preco);
					;
				}
				LoadTablePratos();

				txt_pratos_cod.setText("");
				txt_pratos_nome.setText("");
				txt_pratos_desc.setText("");
				txt_pratos_prec.setText("");
				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_pratos_salvar.setEnabled(false);
		btn_pratos_salvar.setBounds(40, 216, 89, 23);
		panel_1.add(btn_pratos_salvar);
//--------------------------------------------------------------------//

//----------------BOTÃO CANCELAR PRATOS ----------------------------/		 
		btn_pratos_cancelar = new JButton("Cancelar");
		btn_pratos_cancelar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				txt_pratos_cod.setText("");
				txt_pratos_nome.setText("");
				txt_pratos_desc.setText("");
				txt_pratos_prec.setText("");
				modo = "Navegar";
				manipulaInterface();

			}
		});
		btn_pratos_cancelar.setEnabled(false);
		btn_pratos_cancelar.setBounds(163, 216, 89, 23);
		panel_1.add(btn_pratos_cancelar);
//----------------------------------------------------------------//

//---------------LABEL DESCRIÇÃO DOS PRATOS---------------------//		 
		JLabel lbl_pratos_desc = new JLabel("Desc.");
		lbl_pratos_desc.setBounds(10, 167, 46, 14);
		panel_1.add(lbl_pratos_desc);

//--------------CAIXA DE TEXTO DA DESCRIÇÃO DOS PRATOS----------//		 
		txt_pratos_desc = new JTextField();
		txt_pratos_desc.setHorizontalAlignment(SwingConstants.LEFT);
		txt_pratos_desc.setEditable(false);
		txt_pratos_desc.setBounds(66, 143, 307, 62);
		panel_1.add(txt_pratos_desc);
		txt_pratos_desc.setColumns(20);

		lbl_PreoR = new JLabel("Pre\u00E7o:R$");
		lbl_PreoR.setBounds(10, 105, 72, 14);
		panel_1.add(lbl_PreoR);

		txt_pratos_prec = new JTextField();
		txt_pratos_prec.setEditable(false);
		txt_pratos_prec.setBounds(66, 102, 89, 20);
		panel_1.add(txt_pratos_prec);
		txt_pratos_prec.setColumns(10);

		btnNewButton = new JButton("Voltar");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				screenMenu windowMenu = new screenMenu();
				windowMenu.setVisible(true);
				dispose();
			}
		});
		btnNewButton.setBounds(284, 216, 89, 23);
		panel_1.add(btnNewButton);

		JScrollPane scrollPane_1 = new JScrollPane();
		scrollPane_1.setBounds(10, 11, 397, 127);
		Pratos.add(scrollPane_1);

//-------------- TABELA DOS PRATOS --------------------------//		 
		tbl_pratos = new JTable();
		tbl_pratos.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent arg0) {
				int index = tbl_pratos.getSelectedRow();

				if (index >= 0 && index < ListaPratos.size()) {
					Pratos P = ListaPratos.get(index);
					txt_pratos_cod.setText(String.valueOf(P.getCodigo()));
					txt_pratos_nome.setText(P.getNome());
					txt_pratos_desc.setText(P.getDescricao());
					txt_pratos_prec.setText(String.valueOf(P.getPreco()));

					modo = "SelecaoP";
					manipulaInterface();
				}
			}
		});
		scrollPane_1.setViewportView(tbl_pratos);
		tbl_pratos.setModel(
				new DefaultTableModel(new Object[][] {}, new String[] { "C\u00F3digo", "Nome", "Pre\u00E7o" }) {
					Class[] columnTypes = new Class[] { Integer.class, String.class, Float.class };

					public Class getColumnClass(int columnIndex) {
						return columnTypes[columnIndex];
					}

					boolean[] columnEditables = new boolean[] { false, false, false };

					public boolean isCellEditable(int row, int column) {
						return columnEditables[column];
					}
				});
		tbl_pratos.getColumnModel().getColumn(0).setResizable(false);
		tbl_pratos.getColumnModel().getColumn(1).setResizable(false);
		tbl_pratos.getColumnModel().getColumn(2).setResizable(false);
//-=-----------------------------------------------------------------------//		 
//-----------------------BOTAO NOVO DOS PRATOS--------------------------//		 
		btn_pratos_novo = new JButton("Novo");
		btn_pratos_novo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				txt_pratos_cod.setText("");
				txt_pratos_nome.setText("");
				txt_pratos_desc.setText("");
				txt_pratos_prec.setText("");
				modo = "NovoP";

				manipulaInterface();
			}
		});
		btn_pratos_novo.setBounds(10, 149, 89, 23);
		Pratos.add(btn_pratos_novo);
//---------------------------------------------------------------------------//

//----------------------BOTAO EXCLUIR PRATOS ------------------------------///		 
		btn_pratos_excluir = new JButton("Excluir");
		btn_pratos_excluir.setEnabled(false);
		btn_pratos_excluir.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int index = tbl_pratos.getSelectedRow();
				if (index >= 0 && index < ListaPratos.size()) {
					ListaPratos.remove(index);
				}
				LoadTablePratos();
				txt_pratos_nome.setText("");
				txt_pratos_cod.setText("");
				txt_pratos_desc.setText("");
				txt_pratos_prec.setText("");
				modo = "Navegar";
				manipulaInterface();
			}
		});
		btn_pratos_excluir.setBounds(318, 149, 89, 23);
		Pratos.add(btn_pratos_excluir);
//---------------------------------------------------------------------------//

//-----------------------BOTAO EDITAR PRATOS --------------------------------//
		btn_pratos_editar = new JButton("Editar");
		btn_pratos_editar.setEnabled(false);
		btn_pratos_editar.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modo = "EditarP";
				manipulaInterface();
			}
		});
		btn_pratos_editar.setBounds(165, 149, 89, 23);
		Pratos.add(btn_pratos_editar);
	}
//----------------------------------------------------------------------------//

//---------------------------FUNÇÃO QUE MANIPULA A INTERFACE ----------------//	
	public void manipulaInterface() {
		switch (modo) {
		case "Navegar":
			btn_dep_cancelar.setEnabled(false);
			btn_dep_salvar.setEnabled(false);
			c_dep_codigo.setEditable(false);
			c_dep_nome.setEditable(false);
			txt_dep_base.setEditable(false);
			btn_dep_novo.setEnabled(true);
			btn_dep_editar.setEnabled(false);
			btn_dep_excluir.setEnabled(false);

			btn_pratos_cancelar.setEnabled(false);
			btn_pratos_salvar.setEnabled(false);
			txt_pratos_cod.setEditable(false);
			txt_pratos_nome.setEditable(false);
			txt_pratos_desc.setEditable(false);
			txt_pratos_prec.setEditable(false);
			btn_pratos_novo.setEnabled(true);
			btn_pratos_editar.setEnabled(false);
			btn_pratos_excluir.setEnabled(false);

			btn_func_cancelar.setEnabled(false);
			btn_func_salvar.setEnabled(false);
			txt_func_idade.setEditable(false);
			txt_func_cpf.setEditable(false);
			txt_func_nome.setEditable(false);
			txt_func_login.setEditable(false);
			txt_func_senha.setEditable(false);
			btn_func_novo.setEnabled(true);
			btn_func_editar.setEnabled(false);
			btn_func_excluir.setEnabled(false);

			break;

		case "Novo":
			btn_dep_cancelar.setEnabled(true);
			btn_dep_salvar.setEnabled(true);
			c_dep_codigo.setEditable(true);
			c_dep_nome.setEditable(true);
			txt_dep_base.setEditable(true);
			btn_dep_novo.setEnabled(false);
			btn_dep_editar.setEnabled(false);
			btn_dep_excluir.setEnabled(false);

			break;

		case "Editar":
			btn_dep_cancelar.setEnabled(true);
			btn_dep_salvar.setEnabled(true);
			c_dep_codigo.setEditable(true);
			c_dep_nome.setEditable(true);
			txt_dep_base.setEditable(true);
			btn_dep_novo.setEnabled(true);
			btn_dep_editar.setEnabled(false);
			btn_dep_excluir.setEnabled(false);
			break;

		case "Excluir":
			btn_dep_cancelar.setEnabled(false);
			btn_dep_salvar.setEnabled(false);
			c_dep_codigo.setEditable(false);
			c_dep_nome.setEditable(false);
			txt_dep_base.setEditable(false);
			btn_dep_novo.setEnabled(true);
			btn_dep_editar.setEnabled(false);
			btn_dep_excluir.setEnabled(false);
			break;

		case "Selecao":
			btn_dep_cancelar.setEnabled(false);
			btn_dep_salvar.setEnabled(false);
			c_dep_codigo.setEditable(false);
			c_dep_nome.setEditable(false);
			txt_dep_base.setEditable(false);
			btn_dep_novo.setEnabled(true);
			btn_dep_editar.setEnabled(true);
			btn_dep_excluir.setEnabled(true);
			break;

		case "NovoP":
			btn_pratos_cancelar.setEnabled(true);
			btn_pratos_salvar.setEnabled(true);
			txt_pratos_nome.setEditable(true);
			txt_pratos_cod.setEditable(true);
			txt_pratos_desc.setEditable(true);
			txt_pratos_prec.setEditable(true);
			btn_pratos_novo.setEnabled(false);
			btn_pratos_editar.setEnabled(false);
			btn_pratos_excluir.setEnabled(false);

			break;

		case "EditarP":
			btn_pratos_cancelar.setEnabled(true);
			btn_pratos_salvar.setEnabled(true);
			txt_pratos_cod.setEditable(true);
			txt_pratos_nome.setEditable(true);
			txt_pratos_desc.setEditable(true);
			txt_pratos_prec.setEditable(true);
			btn_pratos_novo.setEnabled(true);
			btn_pratos_editar.setEnabled(false);
			btn_pratos_excluir.setEnabled(false);
			break;

		case "SelecaoP":
			btn_pratos_cancelar.setEnabled(false);
			btn_pratos_salvar.setEnabled(false);
			txt_pratos_cod.setEditable(false);
			txt_pratos_nome.setEditable(false);
			txt_pratos_desc.setEditable(false);
			txt_pratos_prec.setEditable(false);
			btn_pratos_novo.setEnabled(true);
			btn_pratos_editar.setEnabled(true);
			btn_pratos_excluir.setEnabled(true);
			break;

		case "NovoF":
			btn_func_cancelar.setEnabled(true);
			btn_func_salvar.setEnabled(true);

			txt_func_nome.setEditable(true);
			txt_func_idade.setEditable(true);
			txt_func_cpf.setEditable(true);
			// txt_func_login.setEditable(true);
			// txt_func_senha.setEditable(true);

			btn_func_novo.setEnabled(false);
			btn_func_editar.setEnabled(false);
			btn_func_excluir.setEnabled(false);

			break;

		case "EditarF":
			btn_func_cancelar.setEnabled(true);
			btn_func_salvar.setEnabled(true);

			txt_func_nome.setEditable(true);
			txt_func_idade.setEditable(true);
			txt_func_cpf.setEditable(true);
			// txt_func_login.setEditable(true);
			// txt_func_senha.setEditable(true);

			btn_func_novo.setEnabled(true);
			btn_func_editar.setEnabled(false);
			btn_func_excluir.setEnabled(false);
			break;

		case "SelecaoF":
			btn_func_cancelar.setEnabled(false);
			btn_func_salvar.setEnabled(false);

			txt_func_nome.setEditable(false);
			txt_func_idade.setEditable(false);
			txt_func_cpf.setEditable(false);
			// txt_func_login.setEditable(false);
			// txt_func_senha.setEditable(false);

			btn_func_novo.setEnabled(true);
			btn_func_editar.setEnabled(true);
			btn_func_excluir.setEnabled(true);
			break;

		default:
			System.out.println("Errou");
		}

	}
}
