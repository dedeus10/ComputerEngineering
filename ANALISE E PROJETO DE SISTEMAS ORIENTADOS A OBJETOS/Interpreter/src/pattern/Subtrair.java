package pattern;

public class Subtrair implements Expression{
	private Expression right; 
	private Expression left;
	
	public Subtrair(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
	
	@Override
	public int interpretar() {
		return this.left.interpretar() - this.right.interpretar(); 
	}
}
