
/*
--------------------------------------------------------------------------------
--                                                                            --
--                         INTELIGÊNCIA ARTIFICIAL                            --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Breadth Search
-- File		   : DemoSearch.java		
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- Created     : 2 Abr 2019
--
--------------------------------------------------------------------------------
*/

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;

// TODO: Auto-generated Javadoc
/**
 * The Class DemoSearch.
 */
public class DemoSearch {

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int it = 0; // Contador de iteracoes
		int token = 1; // ID do Node
		long initTime, totalTime;// Usado para tempo de computacao

		// Parametrizacao da bsuca
		final int PRIEST = 3;
		final int CANNIBAL = 3;

		// Definicao dos arquivos texto
		FileWriter arq_trace = null;
		FileWriter arq_bestWay = null;
		try {
			arq_bestWay = new FileWriter("bestWay.txt");
			arq_trace = new FileWriter("trace.txt");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PrintWriter trace = new PrintWriter(arq_trace);
		PrintWriter bestWay = new PrintWriter(arq_bestWay);
		trace.printf("------ Execution Trace ------ \n");

		// Cria grafo node Head "A"
		Node Head = new Node(0, PRIEST, CANNIBAL, true);

		// Objeto que expande nodes
		NodeExpands ex = new NodeExpands(Head);

		trace.printf("--N° of Priest:" + PRIEST + "\n");
		trace.printf("--N° of Cannibals:" + CANNIBAL + "\n");

		// Cria fila FIFO (First in - First Out)
		Queue FIFO = new LinkedList();

		// Pega tempo inicial de processamento
		initTime = System.currentTimeMillis();

		// Adiciona Node Head na FIFO
		FIFO.add(Head);

		// Se a FIFO nao ta vazia continua
		while (!(FIFO.isEmpty())) {
			System.out.println("Iteration: " + it + "\n");

			// Cria node temporario - Node atual
			Node temp = new Node();

			// Cria iterator para printar a FIFO
			Iterator indice = FIFO.iterator();

			// Cria node temporario - para printar FIFO
			Node n = new Node();
			System.out.println("------------- FIFO Nodes --------- \n");
			while (indice.hasNext()) {
				n = (Node) indice.next();
				System.out.println(n.printNode() + "\n");
			}

			// Retira da FIFO node atual
			temp = (Node) FIFO.remove();
			System.out.println("Removed node: " + temp.printNode() + "\n");

			// Testa se e' o Goal, se sim remove todos da fila
			if (temp.getPriest() == PRIEST && temp.getCannibal() == CANNIBAL && temp.getPosition() == false) {
				System.err.println("Goal is located \n");
				totalTime = System.currentTimeMillis() - initTime;
				System.err.println("##### Grafo Print ###### \n" + temp);
				System.err.println("Total time for computation: " + totalTime + "ms");
				bestWay.printf("##### Grafo Print ###### \n" + temp);
				bestWay.printf("\n --Total time for computation: " + totalTime + "ms");
				trace.printf("\n Goal is Located");

				try {
					arq_bestWay.close();
					arq_trace.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				FIFO.removeAll(FIFO);
			} else {

				trace.printf("\n##Estado Atual: " + temp.printNode());
				for (int i = 0; i < 5; i++) { // Linha

					// Tenta criar um node valido
					Node aux = new Node();
					aux = ex.createNode(temp, i, token, PRIEST, CANNIBAL);
					if (aux != null) {
						// Insere na fila
						FIFO.add(aux);
						trace.printf("Novo estado: " + aux.printNode());
						token++;
					}
				}
			}
			it++;
		}
	}
}