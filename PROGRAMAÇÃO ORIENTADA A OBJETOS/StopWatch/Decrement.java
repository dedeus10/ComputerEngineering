/*

	UNIVERSIDADE FEDERAL DE SANTA MARIA
		CENTRO DE TECNOLOGIA
	CURSO DE ENGENHARIA DE COMPUTAÇÃO

		Programação Orientada a Objetos

	Autor: Luis Felipe de Deus
	Data:15/10/18
	Atualização: 17/10/18

    Obejtivo: Criar uma aplicação com interface gráfica, de um cronometro que decrementa dado 
    um valor iniciar fornecido pelo usuario
    A interface deve ter:
    2x JButtons - Iniciar e Parar o Cronometro
    1x JLabel - Apresenta o cronometro sendo decrementado
    1x JTextField - Para o usuario fornecer o tempo em segundos


*/

//Importa pacotes
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Timer;
import java.util.TimerTask;
import javax.swing.*;

public class Decrement {

    // Variables
    private boolean running = false;
    private int counter = 0;
    private Timer tm;
    private boolean zero = false;
    private boolean finish = false;

    // Aplicação
    public void startAplication() {
        // Created Window
        JFrame.setDefaultLookAndFeelDecorated(true);
        JFrame janela = new JFrame("StopWatch");
        janela.setSize(300, 200);
        janela.setAlwaysOnTop(true);
        janela.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        janela.setLayout(new BorderLayout());

        // Created Label of counter
        JLabel contagemTempo = new JLabel("00:00:00");
        contagemTempo.setFont(new Font(contagemTempo.getName(), Font.PLAIN, 80));
        janela.add(contagemTempo, BorderLayout.CENTER);

        // Created Painel
        JPanel painel = new JPanel();
        painel.setLayout(new GridLayout(2, 1));

        // Created Buttons and user interation
        JButton btnInit = new JButton("INIT");
        JButton btnStop = new JButton("STOP !");
        JLabel lbValue = new JLabel("Time (s): ");
        JTextField textBox = new JTextField(8);

        // Button Action Init
        btnInit.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                if (!running) {
                    tm = new Timer();
                    running = true;
                    zero = false;
                    tm.scheduleAtFixedRate(new TimerTask() {

                        @Override
                        public void run() {
                            if (counter > 0) {
                                counter--;
                                int seg = counter % 60;
                                int min = counter / 60;
                                int hora = min / 60;
                                min %= 60;
                                contagemTempo.setText(String.format("%02d:%02d:%02d", hora, min, seg));
                            } else {
                                tm.cancel();
                                running = false;
                                counter = 0;
                                contagemTempo.setFont(new Font(contagemTempo.getName(), Font.PLAIN, 40));
                                contagemTempo.setText("END OF TIME !!!");
                            }
                        }
                    }, 0, 1000);

                }

            }
        });

        // Button Action Stop
        btnStop.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                if (running) {
                    tm.cancel();
                    running = false;
                    counter = 0;
                }
                if (!zero) {
                    zero = true;
                    contagemTempo.setText("00:00:00");
                }
                contagemTempo.setFont(new Font(contagemTempo.getName(), Font.PLAIN, 80));
            }
        });

        // Get value of time
        textBox.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                counter = Integer.parseInt(textBox.getText());

                int mini = counter / 60;
                int segi = counter % 60;
                contagemTempo.setText(String.format("00:%02d:%02d", mini, segi));

            }
        });

        // Add in painel
        painel.add(btnInit);
        painel.add(btnStop);
        painel.add(lbValue);
        painel.add(textBox);

        janela.add(painel, BorderLayout.WEST);
        janela.pack();
        janela.setVisible(true);
    }

    public static void main(String[] args) {

        Decrement dec = new Decrement();
        dec.startAplication(); // Chama Aplicação

    }

}
