package pattern;

public class Expo implements Expression{
	private Expression right; 
	private Expression left;
	
	public Expo(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
	
	@Override
	public int interpretar() {
		return (int) (Math.pow(this.left.interpretar(),this.right.interpretar())); 
	}
}
