package pattern;

public class CurrencyConverter extends Colleague{
	final double dolarToReal = 0.24;
	final double dolarToEuro = 1.09;
	
	public CurrencyConverter(Mediator m) {
		super(m);
	}

	@Override
	public void receberMensagem(String mensagem) {
		System.out.println("Converter recebeu: " + mensagem);
	}
	
	public double Converter(double valor, String unidade) {
		double newValue = 0;
		
		if(unidade == "Real")
			newValue = valor*dolarToReal;
			
		else if(unidade == "Euro")
			newValue = valor*dolarToEuro;
		else
			System.out.print("--- Moeda não identificada! ---");
		
		return newValue; 
	}

}
