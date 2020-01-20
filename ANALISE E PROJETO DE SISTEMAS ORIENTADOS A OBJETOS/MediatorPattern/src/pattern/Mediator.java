package pattern;

public interface Mediator {

	void enviar(String mensagem, Colleague colleague);
	public boolean proporOferta(double valor, String unidade);
}
