package pattern;

public class Aplicativo {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MediatorMessage mediador = new MediatorMessage();
		
		BrazilianBuyer Br = new BrazilianBuyer(mediador);
		FrenchBuyer Fr = new FrenchBuyer(mediador);
		AmericanSeller Am = new AmericanSeller(mediador);
		CurrencyConverter Cc = new CurrencyConverter(mediador);
	
		mediador.adicionarColleague(Br);
		mediador.adicionarColleague(Fr);
		mediador.adicionarColleague(Am);
		mediador.adicionarColleague(Cc);
		
		boolean proposal = false;
		int i = 0;
		int propost = 12;
		
		System.out.println(" --- Brazilian Buyer ----");
		while(!proposal) {
			proposal = Br.proporOfer(propost, "Real");
			System.out.println("Proposta [" + i + "]: " + proposal+ "\n");
			propost+=3;
			i++;
		}
		System.out.println("\n=========================\n");
		proposal = false;
		propost = 3;
		i = 0;
		
		System.out.println(" --- French Buyer ----");
		while(!proposal) {
			proposal = Fr.proporOfer(propost, "Euro");
			System.out.println("Proposta [" + i + "]: " + proposal + "\n");
			propost+=3;
			i++;
		}
	}

}
