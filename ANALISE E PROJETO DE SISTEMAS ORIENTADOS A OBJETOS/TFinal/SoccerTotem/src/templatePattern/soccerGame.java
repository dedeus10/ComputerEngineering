package templatePattern;

import mediatorPattern.Colleague;
/**
* 
* @author dedeus
*\file soccerGame.java
*
*Classe abstrata que constroi um jogo de futebol seguindo o padrão Template
*/

/**
* 
* @author dedeus
*@class public abstract class soccerGame
*@brief Classe abstrata que constroi um jogo de futebol baseado na 
*implementação de seu template
*/
public abstract class soccerGame {
	///@var colleague é uma instancia de um oobjeto Colleague usado para armazenar o estabelecimento do jogo
	Colleague colleague;

	/**
	 * @brief Implementação final do builder do template
	 * @param colleague é o estabelecimento a ser realizado o jogo
	 * @return void
	 */
	public final void buildGame(Colleague colleague) {
		reservaLocal(colleague);
		reservaBola();
		reservaColetes();
		reservaChurrasqueira();
		reservaAssador();
		System.out.println("Jogo construido!");
	}

	/**
	 * @brief Implementação do metodo para reservar os coletes (presente em todos)
	 * @param void
	 * @return void
	 */
	private void reservaColetes() {
		System.out.println("Coletes reservados");
	}

	/**
	 * @brief Implementação do metodo para reservar a bola (presente em todos)
	 * @param void
	 * @return void
	 */
	private void reservaBola() {
		System.out.println("Bola reservada");
	}

	/**
	 * @brief protótipo do método para reservar o local do jogo estabelecimento e local fisico
	 * @param colleague é o estabelecimento a ser realizado o jogo
	 * @return void
	 */
	abstract void reservaLocal(Colleague colleague);

	/**
	 * @brief protótipo do método para reservar churrasqueira se necessário
	 * @param void
	 * @return void
	 */
	abstract void reservaChurrasqueira();

	/**
	 * @brief protótipo do método para reservar assador se necessário
	 * @param void
	 * @return void
	 */
	abstract void reservaAssador();
	
	/**
	 * @brief protótipo do método para setar o codigo dependendo da escolha do user
	 * @param codigo é a String de 4 caracteres referente a oferta
	 * @return void
	 */
	abstract void setCodigo(String codigo);

	/**
	 * @brief Implementação do metodo para pegar o estabelecimento reservado
	 * @param void
	 * @return Um objeto Colleague referente ao estabelecimento selecionado
	 */
	public Colleague getColleague() {
		return colleague;
	}

	/**
	 * @brief Implementação do metodo para setar o estabelecimento selecionado
	 * @param c é um objeto Colleague referente ao estabelecimento selecionado
	 * @return void
	 */
	public void setColleague(Colleague colleague) {
		this.colleague = colleague;
	}

}
