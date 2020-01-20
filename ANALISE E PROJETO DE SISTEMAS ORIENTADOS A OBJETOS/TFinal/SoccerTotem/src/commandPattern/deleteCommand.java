package commandPattern;

import mediatorPattern.Colleague;
import mediatorPattern.MediatorMessage;

/**
 * 
 * @author dedeus
 *\file deleteCommand.java
 *
 *Classe é a implementação de um comando concreto 
 *do padrão Command
 */

/**
 * 
 * @author dedeus
 *@class public class deleteCommand implements Command
 *@brief Classe implementa um comando concreto seguindo o padrão Command sera usado para comandos de root no sistema
 *Comando usado para deletar um estabeleciento do sistema
 */
public class deleteCommand implements Command {
	
	///@var mediator é uma instancia do mediador envolvido no padrão Chain, usado apra executar os comandos no sistema
	MediatorMessage mediator;

	/**
	 * @brief Construtor que vincula o mediator do sistema com do usuario root
	 * @param med é uma instancia de um mediador, mediador é o mesmo usado para implementação do padrao Chain
	 */
	public deleteCommand(MediatorMessage med) {
		this.mediator = med;
	}

	/**
	 * @brief Metodo que executa o comando efetivamente. Adiciona um estabelecimento no mediador
	 * @param colleague é um objeto do tipo Colleague que é um estabelecimento a ser deletado do mediador
	 * @return void
	 */
	public void execute(Colleague colleague) {
		mediator.removeColleague(colleague);
	}

}
