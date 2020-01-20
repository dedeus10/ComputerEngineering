package pattern;


public class Log implements Expression{
	private Expression left;
	
	public Log(Expression left) {
		this.left = left;
		
	}
	
	@Override
	public int interpretar() {
		return (int) (Math.log10(this.left.interpretar())); 
	}
}
