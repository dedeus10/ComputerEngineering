/*
--------------------------------------------------------------------------------
--                                                                            --
--                         INTELIGÊNCIA ARTIFICIAL                            --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Breadth Search
-- File		   : NodeExpands.java		
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- Created     : 2 Abr 2019
--
--------------------------------------------------------------------------------
*/

import java.util.ArrayList;
import java.util.Iterator;

// TODO: Auto-generated Javadoc
/**
 * The Class NodeExpands.
 */
public class NodeExpands {
	/** The boath. */
	int boath[][] = new int[][] { { 1, 1 }, { 1, 0 }, { 2, 0 }, { 0, 1 }, { 0, 2 } };

	/** The node visit. */
	// Lista de nodes ja visitados (Diminuir memoria e melhorar debug)
	static ArrayList<Node> nodeVisit = new ArrayList<Node>();

	/**
	 * Instantiates a new node expands add in list of visited nodes.
	 *
	 * @param Recebe um Node
	 * Construtor adiciona o node a lista de node's visitados
	 */
	public NodeExpands(Node n) {
		nodeVisit.add(n);

	}

	/* Metodo toString
	 * Return: Retorna uma String com a lista de nodes visitados
	 */
	public String toString() {
		String data = new String();
		data = "";
		Iterator<Node> idx = nodeVisit.iterator();
		Node aux = new Node();
		while (idx.hasNext()) {
			aux = idx.next();
			data += aux;
		}
		return data;

	}
	

	/**
	 * Try Expanded the node.
	 *
	 * @param n - Node atual
	 * @param linha - Index da matriz de possibilidades do barco
	 * @param token - Identificacao do Node atual
	 * @param PRIEST - Numero de Missionarios
	 * @param CANNIBAL Numero de canibais
	 * @return the node - Novo Node criado ou Null 
	 */
	public Node createNode(Node n, int linha, int token, int PRIEST, int CANNIBAL) {
		int Margem_past_M, Margem_past_C, Margem_fut_M, Margem_fut_C;

		// Margem que ira' ser passada e' Estado atual menos a acao pretendida
		Margem_past_M = (n.getPriest() - boath[linha][0]);
		Margem_past_C = (n.getCannibal() - boath[linha][1]);

		//Margem Futura e' numero total menos o que ficou na outra margem
		Margem_fut_M = PRIEST - Margem_past_M;
		Margem_fut_C = CANNIBAL - Margem_past_C;

		//Testa se o estado pretendido e' valido
		if (isValid(n, Margem_past_M, Margem_past_C, Margem_fut_M, Margem_fut_C)) {
			Node newNode = new Node(token, Margem_fut_M, Margem_fut_C, !(n.getPosition()));
			newNode.setParent(n);
			System.out.println("Action expands: " + "<" + boath[linha][0] + ", " + boath[linha][1] + ">" + "\n");
			System.out.println("Expanded Node " + newNode.printNode());
			nodeVisit.add(newNode);
			return newNode;
		} else
			return null;

	}

	/**
	 * Checks if is valid the action of expanded Node.
	 *
	 * @param n - Node atual
	 * @param Margem_past_M - Estado do numero de Missionarios na margem atual se executado a acao proposta
	 * @param Margem_past_C - Estado do numero de Canibais na margem atual se executado a acao proposta
	 * @param Margem_fut_M - Estado do numero de Missionarios na margem futura se executado a acao proposta
	 * @param Margem_fut_C - Estado do numero de Canibais na margem futura se executado a acao proposta
	 * @return true, if is valid
	 */
	public boolean isValid(Node n, int Margem_past_M, int Margem_past_C, int Margem_fut_M, int Margem_fut_C) {
		if (Margem_past_M >= 0 && Margem_past_C >= 0) {
			// Testa se o numero de padres é maior que canibais na margem futura
			if (Margem_fut_M >= Margem_fut_C || Margem_fut_M == 0) {
				// Testa se o numero de padres é maior que canibais na margem passada
				if (Margem_past_M >= Margem_past_C || Margem_past_M == 0) {
					// Cria um iterator para percorrer lista de nodes ja visitados
					Iterator<Node> idx = nodeVisit.iterator();
					Node aux = new Node();
					// Percorre lista e verifica se o node ja foi visitado
					while (idx.hasNext()) {
						aux = idx.next();
						if (aux.getPriest() == Margem_fut_M && aux.getCannibal() == Margem_fut_C
								&& aux.getPosition() == !(n.getPosition())) {
							System.out.println("Node " + aux.printNode() + " Already visited \n");
							return false;

						}
					}
					return true;
				}
			}
		}
		return false;
	}
}
