package commandPattern;

import mediatorPattern.Colleague;

/**
 * 
 * @author dedeus
 *\file service.java
 *
 *Classe é o invoker para o padrão command 
 */

/**
 * 
 * @author dedeus
 *@class public class service
 *@brief Classe implementa um serviço onde é invocado os comandos seguindo o padrão Command sera usado para comandos de root no sistema
 *Invoker do Command
 */
public class service {
	///@var command é uma instancia de um objeto Command que linka com os comandos concretos implementandos
	private Command command;

	/**
	 * @brief Construtor que cria o objeto
	 * @param command é um objeto do tipo Command que especifica o comando que deve ser executado
	 */
	public void setCommand(Command command) {
		this.command = command;
	}


	/**
	 * @brief Metodo que invoca o comando.
	 * @param command é um objeto do tipo Command que especifica o comando que deve ser executado
	 * @return void
	 */
	public void commandExec(Colleague colleague) {
		command.execute(colleague);
	}
}
