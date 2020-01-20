
package templatePattern;

import mediatorPattern.Colleague;

/**
* 
* @author dedeus
*\file futsalGamePlusChurrasPlusAssador.java
*
*Classe implementa um jogo de futebol seguindo o padrão Template
*/

/**
* 
* @author dedeus
*@class public class futsalGamePlusChurrasPlusAssador extends soccerGame
*@brief Classe implementa o padrão Template criando um jogo de quadra com churrasco
*e com assador extendendo um jogo de futebol
*/
public class futsalGamePlusChurrasPlusAssador extends soccerGame{
	/**
	 * @var churras identifica se o jogo vai contar com churrasqueira
	 * @var assador identifica se o jogo vai contar com assador
	 * @var local identifica o local do jogo Campo/Quadra
	 * @var codigo identifica o codigo do jogo escolhido pelo user
	 */
	public Integer churras = 0;
	public Integer assador = 0;
	public Integer local = 0;
	public String codigo = "";
	//Colleague colleague;
	
	/**
	 * @brief Implementação do metodo para reservar o estabelecimento e o local como sendo quadra/campo
	 * @param colleague é o estabelecimento a ser realizado o jogo
	 * @return void
	 */
	@Override
	public void reservaLocal(Colleague colleague) {
		System.out.println("Jogo em Quadra");
		this.colleague = colleague;
		this.local = 1;
	}
	
	/**
	 * @brief Implementação do metodo para reservar a churrasqueira
	 * @param void
	 * @return void
	 */
	@Override
	public void reservaChurrasqueira() {
		this.churras = 1;
		System.out.println("Com churrasco");
	}
	
	/**
	 * @brief Implementação do metodo para reservar o assador
	 * @param void
	 * @return void
	 */
	@Override
	public  void reservaAssador() {
		this.assador = 1;
		System.out.println("Com assador");
	}
	
	/**
	 * @brief Implementação do metodo para setar o codigo da oferta selecionada
	 * @param codigo é a String de 4 caracteres referente a oferta
	 * @return void
	 */
	@Override
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	
	/**
	 * @brief Implementação do metodo para pegar o codigo da oferta selecionada
	 * @param void
	 * @return Uma String de 4 caracteres referente o codigo da oferta
	 */
	public String getCodigo() {
		return codigo;
	}
	
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
	public void setColleague(Colleague c) {
		this.colleague = c;
	}
	
	/**
	 * @brief Implementação do metodo toString para vizualização de informações da classe
	 * @param void
	 * @return Retorna String com informações
	 */
	@Override
	public String toString() {
		return "futsalGamePlusChurrasPlusAssador [churras=" + churras + ", assador=" + assador + ", local=" + local
				+ ", codigo=" + codigo + ", colleague=" + colleague + "]";
	}
	
	
	
}

