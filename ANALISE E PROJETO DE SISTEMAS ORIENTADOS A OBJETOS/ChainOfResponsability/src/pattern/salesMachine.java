package pattern;

import java.text.DecimalFormat;

public class salesMachine {
	final Integer Refri = 250;
	final Integer Salgadinho = 300;
	final Integer Biscoito = 200;
	final Integer Pizza = 350;
	Integer coins = 0;
	Integer produto = 0;
	
	public void setProduto(Integer prod) {
		DecimalFormat df = new DecimalFormat("#,###.00");
		switch (prod) {
		case 0:
			produto = Refri;
			System.out.println("\nProduto Selecionado !");
			System.out.println("Item: Refri \nValor: R$ " + df.format((double)(produto/100.0)));
		break;
		
		case 1:
			produto = Salgadinho;
			System.out.println("\nProduto Selecionado !");
			System.out.println("Item: Salgadinho \nValor: R$ " + df.format((double)(produto/100.0)));
		break;
		
		case 2:
			produto = Biscoito;
			System.out.println("\nProduto Selecionado !");
			System.out.println("Item: Biscoito \nValor: R$ " + df.format((double)(produto/100.0)));
		break;
		
		case 3:
			produto = Pizza;
			System.out.println("\nProduto Selecionado !");
			System.out.println("Item: Pizza \nValor: R$ " + df.format((double)(produto/100.0)));
		break;
		
		default:
			System.out.println("\nProduto Invalido !!!!!");
			break;
		}
	}
	
	public Integer newCoin(Integer coin) {
		DecimalFormat df = new DecimalFormat("#,###.00");
		coins += coin;
		if(coins < 100) {
			System.out.println("Coins: " + coins + " cents");
		} else {
			System.out.println("Coins: " + df.format((double)(coins/100.0)) + " cents");
		}
		
		if(coins >= produto) {
			return (coins-produto);
		}else {
			return null;
		}
	}
}
