import java.beans.Customizer;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;
import java.util.PriorityQueue;

// TODO: Auto-generated Javadoc
/**
 * The Class AStar.
 */
public class AStar {
	
	/** The prio queue. */
	static PriorityQueue<Block> prioQueue;
	
	/** The closed cells. */
	static ArrayList<Block> closedCells;
	
	/** The cube. */
	static Block[][][] cube;

	/**
	 * A star search.
	 *
	 * @param blockedCells the blocked cells
	 * @param startCells the start cells
	 * @param goalCells the goal cells
	 * @param cubeTam the cube tam
	 * @param nBlocked the n blocked
	 */
	public void AStar_search(ArrayList<Block> blockedCells, LinkedList<Block> startCells, LinkedList<Block> goalCells,
			int cubeTam, int nBlocked) {

		prioQueue = new PriorityQueue<>((Block c1, Block c2) -> {
			if (c1.getTotal_cost() > c2.getTotal_cost())
				return 1;
			else if (c1.getTotal_cost() < c2.getTotal_cost())
				return -1;
			else
				return 0;
		});

		// Cria duas celulas que irão receber da lista de celulas start-goal
		Block cellStart = new Block(0, 0, 0);
		Block cellGoal = new Block(0, 0, 0);

		//Cria uma lista de celulas fechadas
		closedCells = new ArrayList<Block>();
		//Cria Hash, As chaves sao os custos G, os valores sao o tempo de computacao
		Map<Integer, Float> Gxtime = new HashMap<Integer, Float>();
		//Cria Hash, As chaves sao os custos G, os valores sao as N vezes que o custo foi o Goal
		Map<Integer, Integer> Ntime = new HashMap<Integer, Integer>();

		// Definicao dos arquivos texto
		FileWriter arq_trace = null;
		FileWriter arq_costTime = null;
		FileWriter arq_mediaTime = null;

		try {
			arq_trace = new FileWriter("trace.txt");
			arq_costTime = new FileWriter("costXTime.txt");
			arq_mediaTime = new FileWriter("mediaTime.txt");

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		PrintWriter trace = new PrintWriter(arq_trace);
		PrintWriter costTime = new PrintWriter(arq_costTime);
		PrintWriter mediaTime = new PrintWriter(arq_mediaTime);
		trace.printf("------ Execution Trace ------ \n");
		trace.printf("Tamanho do Cubo: " + cubeTam + "\n");
		trace.printf("N° de Celulas: " + (cubeTam * cubeTam * cubeTam) + "\n");
		trace.printf("Celulas Bloqueadas: " + nBlocked + "\n");
		trace.printf("Numero de estados Start-Goal: " + goalCells.size() + "\n");

		costTime.printf("------ Execution Data ------ \n");
		costTime.printf(" Block   ;G(n) ;Tempo (ms) \n");

		long initTime, totalTime;// Usado para tempo de computacao
		long initTimeCod, totalTimeCod;// Usado para tempo de computacao
		int greatKey = 0;
		// Pega tempo inicial de processamento
		initTimeCod = System.currentTimeMillis();

		while (!(goalCells.isEmpty())) {

			System.out.println("\n##### AStar Inicio ####");
			// Limpa filas
			closedCells.clear();
			prioQueue.clear();

			// Remove as celulas a serem analisadas
			cellStart = startCells.remove();
			cellGoal = goalCells.remove();

			// Cria cubo
			System.out.println("\n########  Create Cube  #########");
			createCube(cubeTam, cellGoal, blockedCells);
			printCube(cube, cubeTam);

			// Pega tempo inicial de processamento
			initTime = System.currentTimeMillis();

			// Testa se a celula de inicio e' bloqueada
			if (cube[cellStart.x][cellStart.y][cellStart.z].isBlocked()
					|| cube[cellGoal.x][cellGoal.y][cellGoal.z].isBlocked()) {
				costTime.printf("[" + cellGoal.x + "," + cellGoal.y + "," + cellGoal.z + "]  ;  0  ;  0\n");
			} else {
				// Adiciona custo total = custo heuristico
				cube[cellStart.x][cellStart.y][cellStart.z].total_cost = cube[cellStart.x][cellStart.y][cellStart.z].heuristic_cost;
				// Adiciona celula de inicio
				prioQueue.add(cube[cellStart.x][cellStart.y][cellStart.z]);
			}

			while (!(prioQueue.isEmpty())) {
				//Remove head da Priority Queue
				Block temp = prioQueue.poll();
				System.out.println("\nRemoved block:" + temp);
				trace.printf("\nRemoved block:" + temp + "\n");
				
				// Verifica se e' o goal
				if (temp.x == cellGoal.x && temp.y == cellGoal.y && temp.z == cellGoal.z) {
					System.err.println("Goal is located !!!\n\n");
					trace.printf("Goal is located !!!\n\n");
					
					//Calcula tempo total de computacao
					totalTime = System.currentTimeMillis() - initTime;
					//Salva informações em arquivo
					costTime.printf("[" + cellGoal.x + "," + cellGoal.y + "," + cellGoal.z + "]  ;  "
							+ cube[cellGoal.x][cellGoal.y][cellGoal.z].g_cost + "  ;  " + totalTime + "\n");

					// Armazena nas Hash's o numero de ocasioes que o valor do custo G foi Goal
					// E o tempo medio de computacao
					int index = cube[cellGoal.x][cellGoal.y][cellGoal.z].g_cost;
					if (index > greatKey)
						greatKey = index;

					if (Gxtime.containsKey(index)) {
						float acc = (totalTime + Gxtime.get(index));
						Integer n = (Ntime.get(index) + 1);
						Gxtime.put(index, acc);
						Ntime.put(index, n);
						//System.out.println("Index:" + index + "| media time:" + media + "\n");
					} else {
						Gxtime.put(index, (float) totalTime);
						//System.out.println("Inde:" + index + "| Total time:" + totalTime + "\n");
						Ntime.put(index, 1);
					}

					// printClosedQueue(closedCells);
					// Limpa fila
					prioQueue.clear();
					break;
				} else {

					// Adiciona na lista de fechados
					closedCells.add(temp);
					
					//Efetua movimentacoes no Cubo
					
					//Direita -  (x - 1)
					moveCube(0, temp, cubeTam);
					//Esquerda - (x + 1)
					moveCube(1, temp, cubeTam);
					//Costas - (y - 1)
					moveCube(2, temp, cubeTam);
					//Frente - (y + 1)
					moveCube(3, temp, cubeTam);
					//Baixo - (z - 1)
					moveCube(4, temp, cubeTam);
					//Cima - (z + 1)
					moveCube(5, temp, cubeTam);
					

				}

				// printPriorityQueue();

			}
		}

		DecimalFormat dec = new DecimalFormat("###,###,##0.00");
		// Salva informacoes
		//Manipula Hash's para saber a media de tempo de computacao por custo G
		mediaTime.printf("Custo G(n) ; N° Amostras ; Tempo Médio (ms) \n");
		for (int i = 0; i <= greatKey; i++) {
			if (Gxtime.containsKey(i)) {
				float media = Gxtime.get(i) / (float) Ntime.get(i);
				mediaTime.printf("    " + i + "      ;     " + Ntime.get(i) + "       ;   " + dec.format(media) + "\n");
			}

		}

		totalTimeCod = System.currentTimeMillis() - initTimeCod;
		trace.printf("Total Time for Computation: " + totalTimeCod + "ms");
		costTime.printf("Total Time for Computation: " + totalTimeCod + "ms \n\r");
		float timeM = (float)((float)(totalTimeCod / 1000) / 60);
		costTime.printf("Total Time for Computation: " + dec.format(timeM) + " min");
		
		//Fecha os arquivos
		try {
			arq_costTime.close();
			arq_trace.close();
			arq_mediaTime.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * Move cube.
	 * Efetivamente navega entre as celulas do cubo
	 * @param direction the direction
	 * @param cell the cell
	 * @param cubeTam the cube tam
	 * @return true, if successful
	 */
	public boolean moveCube(int direction, Block cell, int cubeTam) {
		//Cria deslocamentos
		//Ex. Se direção for 0 cubo olha para direita da celula em questao (coord. X - 1)
		//Ex. Se direção for 1 cubo olha para esquerda da celula em questao (coord. X + 1)
		//Evita replicação de codigo.
		
		Integer xD, yD, zD;
		xD = 0;
		yD = 0;
		zD = 0;
	
		switch (direction) {
		case 0:
			xD = -1;
			yD = 0;
			zD = 0;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.x == 0) return false;
			break;
		case 1:
			xD = 1;
			yD = 0;
			zD = 0;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.x == cubeTam -1) return false;
			break;
		case 2:
			xD = 0;
			yD = -1;
			zD = 0;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.y == 0) return false;
			break;
		case 3:
			xD = 0;
			yD = 1;
			zD = 0;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.y == cubeTam -1) return false;
			break;
		case 4:
			xD = 0;
			yD = 0;
			zD = -1;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.z == 0) return false;
			break;
		case 5:
			xD = 0;
			yD = 0;
			zD = 1;
			//Verifica se esta na extremiada, se sim aborta movimento
			if(cell.z == cubeTam -1) return false;
			break;

		default:
			break;
		}
			//System.out.println("xD | yD | zD " + xD + " | " + yD + " | " + zD);
		// Olha para a direcao e ve se ta bloqueado
		if ((!(cube[cell.x + xD][cell.y + yD][cell.z + zD].isBlocked()))) {
			// Verifica se esta na lista de fechados
			if (!(closedCells.contains(cube[cell.x + xD][cell.y + yD][cell.z + zD]))) {
				//// Verifica se não esta na lista de abertos (Se estiver recalcula custo)
				if (!(prioQueue.contains(cube[cell.x + xD][cell.y + yD][cell.z + zD]))) {
					// Atualiza G cost (Custo ate aqui + custo do caminho)
					cube[cell.x + xD][cell.y + yD][cell.z + zD].g_cost = cell.g_cost + 1;

					// Atualiza o custo Total cost (Custo G + Custo Heuristico)
					cube[cell.x + xD][cell.y + yD][cell.z + zD].total_cost = cube[cell.x + xD][cell.y + yD][cell.z + zD].g_cost
							+ cube[cell.x + xD][cell.y + yD][cell.z + zD].heuristic_cost;

					// Adiciona na fila de Prioridade
					prioQueue.add(cube[cell.x + xD][cell.y + yD][cell.z + zD]);
					return true;
				} else {

					// Calcula novo custo total e compara com antigo
					// Se o novo for menor então troca na lista
					int tempGCost = cell.g_cost + 1;
					double tempTotalCost = cube[cell.x + xD][cell.y + yD][cell.z + zD].g_cost
							+ cube[cell.x + xD][cell.y + yD][cell.z + zD].heuristic_cost;
					if (cube[cell.x + xD][cell.y + yD][cell.z + zD].total_cost > tempTotalCost) {
						// Remove
						prioQueue.remove(cube[cell.x + xD][cell.y + yD][cell.z + zD]);
						// Sobrescreve custos
						cube[cell.x + xD][cell.y + yD][cell.z + zD].g_cost = tempGCost;
						cube[cell.x + xD][cell.y + yD][cell.z + zD].total_cost = tempTotalCost;
						// Adiciona na fila de Prioridade
						prioQueue.add(cube[cell.x + xD][cell.y + yD][cell.z + zD]);
						return true;

					}

				}
			}
		}
		
		return false;
	}

	/**
	 * Creates the cube.
	 *
	 * @param cubeTam the cube tam
	 * @param cellGoal the cell goal
	 * @param blockedCells the blocked cells
	 */
	public void createCube(int cubeTam, Block cellGoal, ArrayList<Block> blockedCells) {
		cube = new Block[cubeTam][cubeTam][cubeTam];

		// Cria Cubo
		for (int k = 0; k < cubeTam; k++) {
			for (int j = 0; j < cubeTam; j++) {
				for (int i = 0; i < cubeTam; i++) {
					//Testa se a celula deve ser bloqueada
					if (isBloqued(i, j, k, blockedCells)) {
						cube[i][j][k] = new Block(i, j, k, true);

						double dX = (cellGoal.getX()) - (cube[i][j][k].getX());
						double dY = (cellGoal.getY()) - (cube[i][j][k].getY());
						double dZ = (cellGoal.getZ()) - (cube[i][j][k].getZ());

						// Calculo do custo heuristico (Linha Reta)
						cube[i][j][k].heuristic_cost = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2) + Math.pow(dZ, 2)));

					} else {

						cube[i][j][k] = new Block(i, j, k, false);

						double dX = (cellGoal.getX()) - (cube[i][j][k].getX());
						double dY = (cellGoal.getY()) - (cube[i][j][k].getY());
						double dZ = (cellGoal.getZ()) - (cube[i][j][k].getZ());

						// Calculo do custo heuristico (Linha Reta)
						cube[i][j][k].heuristic_cost = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2) + Math.pow(dZ, 2)));
						// System.out.println(cube[i][j][k]);
					}

				}
			}
		}

	}

	/**
	 * Checks if is bloqued.
	 *
	 * @param i the i
	 * @param j the j
	 * @param k the k
	 * @param blockedCells the blocked cells
	 * @return true, if is bloqued
	 */
	public static boolean isBloqued(int i, int j, int k, ArrayList<Block> blockedCells) {
		Iterator<Block> cells = blockedCells.iterator();
		while (cells.hasNext()) {
			Block it = cells.next();
			if (it.x == i && it.y == j && it.z == k) {
				return true;

			}
		}

		return false;

	}

	/**
	 * Prints the cube.
	 *
	 * @param cube the cube
	 * @param cubeTam the cube tam
	 */
	public static void printCube(Block[][][] cube, int cubeTam) {
		for (int k = 0; k < cubeTam; k++) {
			for (int j = 0; j < cubeTam; j++) {
				for (int i = 0; i < cubeTam; i++) {
					if (cube[i][j][k].isBlocked()) {
						System.out.print("[  BL ]");
					} else {
						System.out.print("[" + cube[i][j][k].getX() + "," + cube[i][j][k].getY() + ","
								+ cube[i][j][k].getZ() + "]");
					}

					System.out.print("  ");
				}
				System.out.println();
			}
			for (int i = 0; i < cubeTam; i++)
				System.out.print("------------");
			System.out.println();
		}
	}

	/**
	 * Prints the priority queue.
	 */
	public void printPriorityQueue() {
		PriorityQueue<Block> temp = new PriorityQueue<>((Block c1, Block c2) -> {
			if (c1.getTotal_cost() > c2.getTotal_cost())
				return 1;
			else if (c1.getTotal_cost() < c2.getTotal_cost())
				return -1;
			else
				return 0;
		});

		System.out.println("\n------ Priority Queue state: ------");

		Iterator<Block> cellsOpen = prioQueue.iterator();
		while (cellsOpen.hasNext()) {
			temp.add(cellsOpen.next());

		}

		while (!(temp.isEmpty()))
			System.out.println(temp.poll());
	}

	/**
	 * Prints the closed queue.
	 *
	 * @param closed the closed
	 */
	public void printClosedQueue(ArrayList<Block> closed) {
		System.out.println("\n------ Closed Queue state: ------");

		Iterator<Block> cellsClosed = closed.iterator();
		while (cellsClosed.hasNext()) {
			System.out.println(cellsClosed.next());

		}
	}
}
