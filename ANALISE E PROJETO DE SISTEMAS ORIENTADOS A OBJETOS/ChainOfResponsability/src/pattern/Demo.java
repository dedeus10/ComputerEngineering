package pattern;

import java.util.Scanner;

public class Demo {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		salesMachine sM = new salesMachine();

		oneCent sl1 = new oneCent(sM);
		fiveCents sl5 = new fiveCents(sM);
		tenCents sl10 = new tenCents(sM);
		fiftyCents sl50 = new fiftyCents(sM);

		sl1.Addsucess(sl5);
		sl5.Addsucess(sl10);
		sl10.Addsucess(sl50);
		Scanner sc1 = new Scanner(System.in);
		Integer coin = 0;
		Integer ret = null;
		Integer prod = 0;

		while (true) {
			System.out.println("\n###### Welcome a Máquina de Vendas ############");
			System.out.println(
					"--- Menu -----\n0-Refri (R$2,50)\n1-Salgadinho(R$3,00)\n2-Biscoito(R$2,00)\n3-Pizza(R$3,50)");
			System.out.println("\nSelecione produto:");

			prod = sc1.nextInt();
			if (prod != 0 && prod != 1 && prod != 2 && prod != 3) {
				System.out.println("\nPRODUTO INVALIDO !!");
			} else {
				sM.setProduto(prod);

				while (ret == null) {
					System.out.println("\nInsira a moeda:");
					coin = sc1.nextInt();
					ret = sl1.processarCoin(coin);
				}
				System.out.println("\nProduto Liberado - Enjoy!!!");
				System.out.println("Troco: " + ret + " Cents");
			}
		}

	}

}
