/*
--------------------------------------------------------------------------------
--                                                                            --
--                         INTELIGÊNCIA ARTIFICIAL                            --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Breadth Search
-- File		   : Node.java		
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
 * The Class Node.
 */
public class Node {

	/** The node. */
	ArrayList node = new ArrayList();

	/** The parent. - Referencia ao pai do Node*/
	Node parent;

	/**
	 * Instantiates a new node.
	 *
	 * @param token - Identificacao do Node
	 * @param M     - Numero de Missionarios
	 * @param C     - Numero de Canibais
	 * @param pos   - Posicao (true - direita / false - esquerda)
	 */
	public Node(int token, int M, int C, boolean pos) {
		node.add(token);
		node.add(M);
		node.add(C);
		node.add(pos);
	}

	/**
	 * Instantiates a new node. Cria node vazio
	 */
	public Node() {

	}

	/**
	 * Gets the parent.
	 *
	 * @return the parent Retorna referencia ao pai
	 */
	public Node getParent() {
		return parent;
	}

	/**
	 * Checks if is equal.
	 *
	 * @param n - Um Node qualquer
	 * @return true, if is equal
	 */
	public boolean isEqual(Node n) {
		if (n.getPriest() == getPriest() && n.getCannibal() == getCannibal() && n.getPosition() == getPosition())
			return true;
		else
			return false;
	}

	/**
	 * Sets the parent.
	 *
	 * @param parent - Node que deseja incluir como parent
	 */
	public void setParent(Node parent) {
		this.parent = parent;
	}

	/**
	 * Gets the node.
	 *
	 * @return the node
	 */
	public ArrayList getNode() {
		return node;
	}

	/**
	 * Gets the token.
	 *
	 * @return the token - Identificacao
	 */
	public int getToken() {
		return (int) node.get(0);
	}

	/**
	 * Gets the priest.
	 *
	 * @return the priest - Numero de Missionarios
	 */
	public int getPriest() {
		return (int) node.get(1);
	}

	/**
	 * Gets the cannibal.
	 *
	 * @return the cannibal - Numero de Canibais
	 */
	public int getCannibal() {
		return (int) node.get(2);
	}

	/**
	 * Gets the position.
	 *
	 * @return the position - Posicao do barco
	 */
	public boolean getPosition() {
		return (boolean) node.get(3);
	}

	/*
	 * Metodo toString Return: String com atributos do Node incluindo a arvore de
	 * nodes
	 */
	@Override
	public String toString() {
		String data = "";

		data += parent;
		data += "\nToken:" + node.get(0) + " is " + "<" + node.get(1) + "," + node.get(2) + "," + node.get(3) + ">\n";

		return data;
	}

	/**
	 * Prints the node.
	 *
	 * @return String com atributos do node em questao, sem arvore de nodes
	 */
	public String printNode() {
		String data = "";

		data += "Token:" + node.get(0) + " is " + "<" + node.get(1) + "," + node.get(2) + "," + node.get(3) + ">\n";
		return data;

	}

}
