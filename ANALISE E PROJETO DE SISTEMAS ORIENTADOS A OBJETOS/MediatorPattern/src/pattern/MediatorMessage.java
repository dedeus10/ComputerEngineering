package pattern;
import java.text.DecimalFormat; 


import java.util.ArrayList;

public class MediatorMessage implements Mediator {

	protected ArrayList<Colleague> contatos;

	public MediatorMessage() {
		contatos = new ArrayList<Colleague>();
	}

	public void adicionarColleague(Colleague colleague) {
		contatos.add(colleague);
	}

	@Override
	public void enviar(String mensagem, Colleague colleague) {
		for (Colleague contato : contatos) {
			if (contato != colleague) {
				contato.receberMensagem(mensagem);
			}
		}
	}

	@Override
	public boolean proporOferta(double valor, String unidade) {
		double convertedValue = 0.0;
		DecimalFormat df = new DecimalFormat("#,###.00");
		
		for (Colleague contato : contatos) {
			if (contato instanceof CurrencyConverter) {
				convertedValue = ((CurrencyConverter) contato).Converter(valor, unidade);
				if(unidade == "Real")
					System.out.println("---> R$ "+ df.format(valor) +" para Dólar: $" + df.format(convertedValue));
				else
					System.out.println("---> € "+ df.format(valor) +" para Dólar: $" + df.format(convertedValue));
				
				break;
			}
		}
		for (Colleague contatoSeller : contatos) {
			if (contatoSeller instanceof AmericanSeller) {
				return ((AmericanSeller) contatoSeller).proposedAnalysis(convertedValue);
			}
			
		}
		
		return true;
	}
}
