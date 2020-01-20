package mediatorPattern;

import adapterPattern.gameTarget;
import templatePattern.soccerGame;

/**
 * 
 * @author dedeus
 *\file Mediator.java
 *
 *Classe é uma interface para Mediadores
 */

/**
 * 
 * @author dedeus
 *@class public interface Mediator
 *@brief Classe é uma iterface para implementação do padrão Mediator no qual vai intermediar a comunicação
 *Entre o sistema e os estabelecimentos
 */
public interface Mediator {

	/**
	 * @brief Protótipo de metodo que envia mensagens para os Colleagues cadastrados
	 * @param mensagem é uma String contendo a informação
	 * @param colleague é a instancia de Colleague que esta tentando enviar a mensagem Broadcast neste caso
	 * @return void
	 */
	void enviar(String mensagem, Colleague colleague);
	
	/**
	 * @brief Protótipo de metodo que efetivamente marca o jogo no estabelecimento
	 * @param game é um objeto generico para um jogo (soccerGame) no qual foi usado 
	 * adaptadores para representar o  tipo do jogo
	 * @return O valor total do jogo 
	 */
	public double marcandoJogo(soccerGame game);
	
	/**
	 * @brief Protótipo de metodo que seleciona o Colleague que deve listar suas propostas de jogos disponíveis
	 * @param game é um objeto generico para um jogo (soccerGame) no qual foi usado 
	 * adaptadores para representar o  tipo do jogo
	 * @return void
	 */
	public void proporOferta(soccerGame game);
	
}
