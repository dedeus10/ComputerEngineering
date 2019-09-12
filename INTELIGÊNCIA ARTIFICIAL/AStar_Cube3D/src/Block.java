
// TODO: Auto-generated Javadoc
/**
 * The Class Block.
 */
public class Block {
	
	/** The x. - Coordenada da celula */
	int x;
	
	/** The y. - Coordenada da celula */
	int y;
	
	/** The z. - Coordenada da celula*/
	int z;
	
	/** The heuristic cost. - Custo heuristico (Em linha reta ate o Goal) */
	double heuristic_cost;
	
	/** The blocked. - True - Celula bloqueada / False - Celula livre*/
	boolean blocked;
	
	/** The g cost. - Custo G (Custo de ir de A p/ B) */
	int g_cost;
	
	/** The total cost. - Custo total (G + H) */
	double total_cost;

	/**
	 * To string.
	 *
	 * @return the string
	 */
	@Override
	public String toString() {
		String hC = String.format("%.2f", heuristic_cost);
		String tC = String.format("%.2f", total_cost);
		return "[" + x + "," + y + "," + z + "]   -> hC:" + hC + "| tC:" + tC;
		//return "[" + x + "," + y + "," + z + "] -> tC:" + tC;

	}
	
	/**
	 * Prints the coord.
	 * Printa as coordenadas da celula
	 * @return the string
	 */
	public String printCoord() {
		return "[" + x + "," + y + "," + z + "]";
	}

	/**
	 * Gets the g cost.
	 *
	 * @return the g cost
	 */
	public int getG_cost() {
		return g_cost;
	}

	/**
	 * Sets the g cost.
	 *
	 * @param g_cost the new g cost
	 */
	public void setG_cost(int g_cost) {
		this.g_cost = g_cost;
	}

	/**
	 * Instantiates a new block - Construtor.
	 *
	 * @param x the x
	 * @param y the y
	 * @param z the z
	 * @param heuristic_cost the heuristic cost
	 * @param blocked the blocked
	 */
	public Block(int x, int y, int z, int heuristic_cost, boolean blocked) {
		super();
		this.x = x;
		this.y = y;
		this.z = z;
		this.heuristic_cost = heuristic_cost;
		this.blocked = blocked;
	}

	/**
	 * Instantiates a new block - Construtor.
	 *
	 * @param x the x
	 * @param y the y
	 * @param z the z
	 * @param heuristic_cost the heuristic cost
	 */
	public Block(int x, int y, int z, int heuristic_cost) {
		super();
		this.x = x;
		this.y = y;
		this.z = z;
		this.heuristic_cost = heuristic_cost;

	}

	/**
	 * Instantiates a new block - Construtor.
	 *
	 * @param x the x
	 * @param y the y
	 * @param z the z
	 */
	public Block(int x, int y, int z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	/**
	 * Instantiates a new block - Construtor.
	 *
	 * @param x the x
	 * @param y the y
	 * @param z the z
	 * @param blocked the blocked
	 */
	public Block(int x, int y, int z, boolean blocked) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.blocked = blocked;
	}

	/**
	 * Gets the x.
	 *
	 * @return the x
	 */
	public int getX() {
		return x;
	}

	/**
	 * Sets the x.
	 *
	 * @param x the new x
	 */
	public void setX(int x) {
		this.x = x;
	}

	/**
	 * Gets the y.
	 *
	 * @return the y
	 */
	public int getY() {
		return y;
	}

	/**
	 * Sets the y.
	 *
	 * @param y the new y
	 */
	public void setY(int y) {
		this.y = y;
	}

	/**
	 * Gets the z.
	 *
	 * @return the z
	 */
	public int getZ() {
		return z;
	}

	/**
	 * Sets the z.
	 *
	 * @param z the new z
	 */
	public void setZ(int z) {
		this.z = z;
	}

	/**
	 * Gets the heuristic cost.
	 *
	 * @return the heuristic cost
	 */
	public double getHeuristic_cost() {
		return heuristic_cost;
	}

	/**
	 * Sets the heuristic cost.
	 *
	 * @param heuristic_cost the new heuristic cost
	 */
	public void setHeuristic_cost(int heuristic_cost) {
		this.heuristic_cost = heuristic_cost;
	}

	/**
	 * Gets the total cost.
	 *
	 * @return the total cost
	 */
	public double getTotal_cost() {
		return total_cost;
	}

	/**
	 * Sets the total cost.
	 *
	 * @param total_cost the new total cost
	 */
	public void setTotal_cost(double total_cost) {
		this.total_cost = total_cost;
	}

	/**
	 * Checks if is blocked.
	 *
	 * @return true, if is blocked
	 */
	public boolean isBlocked() {
		return blocked;
	}

	/**
	 * Sets the blocked.
	 *
	 * @param blocked the new blocked
	 */
	public void setBlocked(boolean blocked) {
		this.blocked = blocked;
	}

}
