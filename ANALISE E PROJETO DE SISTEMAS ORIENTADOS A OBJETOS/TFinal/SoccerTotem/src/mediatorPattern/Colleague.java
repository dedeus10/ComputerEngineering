package mediatorPattern;

import templatePattern.soccerGame;

/**
 * 
 * @author dedeus
 *\file Colleague.java
 *
 *Classe abstrata responsável por descrever comportamento dos Colleagues que serçao
 *registrados no mediator
 */

/**
 * 
 * @author dedeus
 *@class public abstract class Colleague
 *@brief Classe abstrata que interliga estabelecimentos com o mediator
 */
public abstract class Colleague {
	///@var Instancia do mediator que os Colleagues serão vinculados
	protected Mediator mediator;
	
	/**
	 * @brief Construtor da classe que cria uma instancia de colleague e vincula ao mediator
	 * @param m instância de um mediator usado para vinculo
	 */
	public Colleague(Mediator m) {
		mediator = m;
	}

	/**
	 * @brief Metodo que invoca o mediator para enviar mensagens para os Colleagues cadastrados
	 * @param mensagem é uma String contendo a informação
	 * @return void
	 */
	public void enviarMensagem(String mensagem) {
		mediator.enviar(mensagem, this);
	}
	
	/**
	 * @brief Metodo invoca o mediator para que ele selecione o Colleague que deve listar suas propostas de jogos disponíveis
	 * @param game é um objeto generico para um jogo (soccerGame) no qual foi usado 
	 * adaptadores para representar o  tipo do jogo
	 * @return void
	 */
	public void proporOferta(soccerGame game) {
		 mediator.proporOferta(game);
	}

	/**
	 * @brief Protótipo de metodo abstrato que deve ser implementado pelos colleagues vinculados
	 * @param mensagem é uma String contendo a informação
	 * @return void
	 */
	public abstract void receberMensagem(String mensagem);
}
