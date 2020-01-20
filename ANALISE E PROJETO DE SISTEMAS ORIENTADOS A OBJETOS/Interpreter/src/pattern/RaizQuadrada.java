package pattern;

public class RaizQuadrada implements Expression{
	private Expression left;
	
	public RaizQuadrada(Expression left) {
		this.left = left;
	}
	
	@Override
	public int interpretar() {
		return (int) (Math.sqrt(this.left.interpretar())); 
	}
}
