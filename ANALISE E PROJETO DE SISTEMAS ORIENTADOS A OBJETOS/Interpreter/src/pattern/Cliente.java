package pattern;

public class Cliente {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("--- Calculadora Interpreter ---");
		Expression somar = new Somar(new Numero(4), new Numero(2));
		System.out.println("Soma = " + somar.interpretar());
		
		Expression sub = new Subtrair(somar, new Numero(2));
		System.out.println("Subtração = " + sub.interpretar());
		
		Expression mul = new Multiplicar(new Numero(4), new Numero(2));
		System.out.println("Multiplicação = " + mul.interpretar());
		
		Expression div = new Dividir(new Numero(3), new Numero(2));
		System.out.println("Divisão = " + div.interpretar());
		
		Expression exp = new Expo(new Numero(3), new Numero(2));
		System.out.println("Exponenciação = " + exp.interpretar());
		
		Expression sqrt = new RaizQuadrada(new Numero(3));
		System.out.println("Raiz Quadrada = " + sqrt.interpretar());
		
		Expression log = new Log(new Numero(2));
		System.out.println("Log = " + log.interpretar());
		
		
	}

}
