package pattern;

public class FrenchBuyer extends Colleague {
	double valor;
	final String unidade = "Euro";
	
	public FrenchBuyer(Mediator m) {
		super(m);
	}

	@Override
	public void receberMensagem(String mensagem) {
		System.out.println("French recebeu: " + mensagem);
	}

}
