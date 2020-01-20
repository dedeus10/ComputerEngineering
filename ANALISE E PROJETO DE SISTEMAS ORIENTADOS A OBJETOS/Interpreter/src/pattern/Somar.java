package pattern;

public class Somar implements Expression{
	private Expression right; 
	private Expression left;
	
	public Somar(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
	
	@Override
	public int interpretar() {
		return this.left.interpretar() + this.right.interpretar(); 
	}
}
