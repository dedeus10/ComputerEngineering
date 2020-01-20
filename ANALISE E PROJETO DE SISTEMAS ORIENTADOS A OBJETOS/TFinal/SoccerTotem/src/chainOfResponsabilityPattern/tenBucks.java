package chainOfResponsabilityPattern;

import mediatorPattern.Bank;

/**
 * 
 * @author dedeus
 *\file tenBucks.java
 *
 *Classe é a implementação de um slot do padrão 
 *Chain of Responsability
 *Slot de cédulas de R$10,00

/**
 * 
 * @author dedeus
 *@class public class tenBucks implements Slots
 *@brief Classe implementa o padrão Chain of Responsability sendo um slot pra cédulas de R$10,00
 */
public class tenBucks implements Slots{

	/**
	 * @var sucessor é um objeto do tipo Slot que representa o sucessor do slot de 10 na Chain
	 * @var moneyPlace é um objeto do tipo Bank que representa o Banco que esta Chain esta associada
	 * @def TENBUCKS constante que representa o valor deste slot
	 */
	private Slots sucessor;
	private Bank moneyPlace;
	private final Integer TENBUCKS = 10;
	
	/**
	 * @brief Construtor da classe, cria a instancia e associa um Banco ao slot
	 * @param Ba é um objeto do tipo Banco que contem a instancia do Banco a ser associado
	 */
	public tenBucks(Bank Ba) {
		this.moneyPlace = Ba;
	}
	
	/**
	 * @brief Metodo que adiciona o Slot sucessor a este slot
	 * @param sucess é um objeto do tipo Slot que contem a referência para o sucesso na Chain
	 * @return void
	 */
	public void Addsucess(Slots sucess){
		this.sucessor = sucess;
	}
	
	/**
	 * @brief Implementação do metodo processarPilas que verifica se o valor encaminhado é
	 * referente a este slot, no caso positivo repassa ao banco, em caso
	 * negativo repassa para o sucessor na Chain
	 * @param Bucks é o valor da cédula recebida pelo Totem
	 * @param valorJogo é o valor total que é necessário ser recebido para liberar o jogo
	 * @return True em caso de ter chegado no valor, caso contrário False
	 */
	@Override
	public boolean processarPilas(Integer Bucks, double valorJogo) {
		if(Bucks == TENBUCKS) {
			 return moneyPlace.newBuck(Bucks, valorJogo);
		}else {
			if(sucessor != null)
				 return sucessor.processarPilas(Bucks, valorJogo);
			else
				System.out.println("Invalid Bucks!!! \n");
		}
		return false;
	}

	/**
	 * @brief Implementação do metodo toString para vizualização de informações da classe
	 * @param void
	 * @return Retorna String com informações
	 */
	@Override
	public String toString() {
		return "Ten Bucks [sucessor=" + sucessor + "]";
	}
	
}
