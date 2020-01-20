package commandPattern;

import mediatorPattern.Colleague;
/**
 * 
 * @author dedeus
 *\file Command.java
 *
 *Classe é uma interface para os comandos criados seguindo
 *o padrão Command
*/

/**
 * 
 * @author dedeus
 *@class public interface Command
 *@brief Classe é uma interface do padrão Command responsável por executar um comando root
 */
public interface Command {
	
	/**
	 * @brief Protótipo do metodo que executa o comando efetivamente.
	 * @param colleague é um objeto do tipo Colleague que pode especificar o estabelecimento a ser removido, adicionado etc.
	 * @return void
	 */
	public void execute(Colleague colleague);

}
