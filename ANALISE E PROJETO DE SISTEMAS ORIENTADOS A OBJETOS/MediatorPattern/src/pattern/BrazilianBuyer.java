package pattern;

public class BrazilianBuyer extends Colleague {
	double valor;
	final String unidade = "Real";
	
	public BrazilianBuyer(Mediator m) {
		super(m);
	}

	@Override
	public void receberMensagem(String mensagem) {
		System.out.println("Brazilian recebeu: " + mensagem);
	}

}
