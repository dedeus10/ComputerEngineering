
package mediatorPattern;

/**
 * 
 * @author dedeus
 *\file Bank.java
 *
 *Classe é a implementação de um banco 
 *extende a classe colleague para vinculo no padrão
 *Mediator 
 */

/**
 * 
 * @author dedeus
 *@class public class Bank extends Colleague
 *@brief Classe implementa serviços de um banco sendo um instancia de Colleague para vinculação
 *com o padrão Mediator
 */
public class Bank extends Colleague{
	///@var valor armazena o valor atual de dinheiro em caixa
	double valor;
	
	/**
	 * @brief Construtor do método.
	 * @param m é um objeto do tipo Mediator onde o banco deve se vincular posteriormente utilizando comandos Root
	 */
	public Bank(Mediator m) {
		super(m);
	}

	/**
	 * @brief Metodo implementa uma recepção de mensagem entre os Colleagues
	 * @param mensagem é uma String contendo a informação recebida
	 * @return void
	 * @warning atualmente utilizada apenas para debug de comunicação
	 */
	@Override
	public void receberMensagem(String mensagem) {
		
		System.out.println("Bank recebeu: " + mensagem);
	}
	
	/**
	 * @brief Metodo que recebe uma nova cedula e processa, incrementando no valor atual
	 * verificando se o valor atual chegou a quantia necessária para pagar pelo jogo.
	 * @param Bucks é o valor da cedula a ser processada
	 * @param valorJogo é o valor total necessário para pagar o jogo
	 * @return True caso o valor atual no banco seja suficiente para pagar o jogo, caso contrario False
	 */
	public boolean newBuck(Integer Bucks, double valorJogo) {
		
		valor += Bucks;
		if(valor >= valorJogo)
		{
			valor = 0;
			return true;
		}
		System.out.println("Valor Atual: R$" + valor);
		
		return false;
	}

	/**
	 * @brief Implementação do metodo toString para vizualização de informações da classe
	 * @param void
	 * @return Retorna String com informações
	 */
	@Override
	public String toString() {
		return "Bank Office";
	}

}