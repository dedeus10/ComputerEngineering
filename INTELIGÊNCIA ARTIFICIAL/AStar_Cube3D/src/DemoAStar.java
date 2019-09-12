import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Random;
import java.util.Scanner;
import java.math.*;

// TODO: Auto-generated Javadoc
/**
 * The Class DemoAStar.
 */
public class DemoAStar {

	/** The Random gen X, Y, Z. */
	static Random genX = new Random();
	static Random genY = new Random();
	static Random genZ = new Random();

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 */
	public static void main(String[] args) {

		//Usado para interface com user
		Scanner scanner = new Scanner(System.in);
		//Listas: Celulas bloqueadas, celulas start, celulas goal
		ArrayList<Block> blockedCells = new ArrayList<Block>();
		LinkedList<Block> startCells = new LinkedList<Block>();
		LinkedList<Block> goalCells = new LinkedList<Block>();

		//Cria uma busca
		AStar Search = new AStar();

		//Interface com User
		System.out.println("Tamanho do Cubo ? :");
		int cubeTam = scanner.nextInt();

		System.out.println("Porcentagem de obstaculos[%]:");
		int porcentagem = scanner.nextInt();

		System.out.println("Numero de Start-Goal:");
		int nComb = scanner.nextInt();

		float prob = (float) porcentagem / 100;
		int nBlockeds = (int) (prob * (float) (Math.pow((double) cubeTam, (double) 3)));
		System.out.println("Prob: " + prob + " NB: " + nBlockeds);

		// Gera estados de start e goal
		for (int i = 0; i < nComb; i++) {
			while (!(randomCells(cubeTam, startCells))) {
			}
			while (!(randomCells(cubeTam, goalCells))) {
			}
		}

		// Printa celulas start e goal
		Iterator<Block> cellsS = startCells.iterator();
		Iterator<Block> cellsG = goalCells.iterator();
		while (cellsS.hasNext()) {
			Block S = cellsS.next();
			Block G = cellsG.next();
			System.out.println(S.printCoord() + "/" + G.printCoord());
		}

		// Gera Lista com celulas que devem ser bloqueadas
		for (int m = 0; m < (nBlockeds); m++) {
			while (!(randomGen(cubeTam, blockedCells))) {
			}
		}

		// Efetua Busca A*
		Search.AStar_search(blockedCells, startCells, goalCells, cubeTam, nBlockeds);
	}

	/**
	 * Random gen.
	 *
	 * @param cubeTam the cube tam
	 * @param blockedCells the blocked cells
	 * @return true, if successful
	 * 
	 * Metodo que gera celulas randomicos que devem ser bloqueadas
	 * 
	 */
	public static boolean randomGen(int cubeTam, ArrayList<Block> blockedCells) {

		int sX = genX.nextInt(cubeTam);
		int sY = genY.nextInt(cubeTam);
		int sZ = genZ.nextInt(cubeTam);

		// Testa se esta celula ja foi criada
		Iterator<Block> cells = blockedCells.iterator();
		while (cells.hasNext()) {
			Block it = cells.next();
			if (it.x == sX && it.y == sY && it.z == sZ) {
				return false;
			}
		}

		// Se não achou dentro da lista, cria celula e add
		Block cellTemp = new Block(sX, sY, sZ);

		// System.out.println(cellTemp + " TAM:" + blockedCells.size());
		blockedCells.add(cellTemp);
		return true;

	}

	/**
	 * Random cells.
	 *
	 * @param cubeTam the cube tam
	 * @param Cells the cells
	 * @return true, if successful
	 * 
	 * Metodo que gera celulas randomicos de Start e Goal
	 */
	public static boolean randomCells(int cubeTam, LinkedList<Block> Cells) {

		int sX = genX.nextInt(cubeTam);
		int sY = genY.nextInt(cubeTam);
		int sZ = genZ.nextInt(cubeTam);

		// Testa se esta celula ja foi criada
		Iterator<Block> cells = Cells.iterator();
		while (cells.hasNext()) {
			Block it = cells.next();
			if (it.x == sX && it.y == sY && it.z == sZ) {
				return false;
			}
		}

		// Se não achou dentro da lista, cria celula e add
		Block cellTemp = new Block(sX, sY, sZ);

		// System.out.println(cellTemp + " TAM:" + Cells.size());
		Cells.add(cellTemp);
		return true;

	}

}
