package pattern;

public abstract class Colleague {
	protected Mediator mediator;

	public Colleague(Mediator m) {
		mediator = m;
	}

	public void enviarMensagem(String mensagem) {
		mediator.enviar(mensagem, this);
	}
	
	public boolean proporOfer(double valor, String unidade) {
		return mediator.proporOferta(valor, unidade);
	}

	public abstract void receberMensagem(String mensagem);
}
