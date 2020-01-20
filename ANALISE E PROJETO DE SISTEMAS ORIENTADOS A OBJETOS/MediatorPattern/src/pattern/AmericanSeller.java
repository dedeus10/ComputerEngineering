package pattern;

public class AmericanSeller extends Colleague{
	double valor;
	final String unidade = "Dolar";
	final double itemValue = 10.0;
	
	public AmericanSeller(Mediator m) {
		super(m);
	}

	@Override
	public void receberMensagem(String mensagem) {
		
		System.out.println("American recebeu: " + mensagem);
	}
	
	public boolean proposedAnalysis(double valor) {
		if(valor >= itemValue) {
			return true;
		}else {
			return false;
		}
	}


}
