

package adapterPattern;

import mediatorPattern.Colleague;
import templatePattern.futsalGamePlusChurrasPlusAssador;

/**
 * 
 * @author dedeus
 *\file futsalGamePCPAAdapter.java
 *
 *Classe utiliza o padrão Adapter para criar 
 *um adaptador de jogos de futebol
 *implementa um jogo alvo qualquer e é uma extensão
 *de jogos do tipo de futsal com adicional de churrasco e adicional de assador
 */

/**
 * 
 * @author dedeus
 *@class public class futsalGamePCPAAdapter extends futsalGamePlusChurrasPlusAssador implements gameTarget
 *@brief Classe é um adaptador para jogos de futebol de futsal com adicional de churrasco e adicional de assador
 */
public class futsalGamePCPAAdapter extends futsalGamePlusChurrasPlusAssador implements gameTarget {
	
	/**
	 * @brief Método que faz o link entre o metodo reservaLocal da classe alvo do adaptador
	 * @param colleague é um objeto do tipo Colleague que representa um dos estabelecimentos
	 * cadastrados no mediator
	 * @return void
	 */
	@Override
	public void reservaL(Colleague colleague) {
		reservaLocal(colleague);
	}
	
	/**
	 * @brief Método que faz o link entre o metodo reservaC da classe alvo do adaptador
	 * @param void
	 * @return void
	 */
	@Override
	public void reservaC() {
		reservaC();
	}
	
	/**
	 * @brief Método que faz o link entre o metodo reservaAssador da classe alvo do adaptador
	 * @param void
	 * @return void
	 */
	@Override
	public  void reservaA() {
		reservaAssador();
	}
	
	/**
	 * @brief Método que faz o link entre o metodo getCodigo da classe alvo do adaptador
	 * @ param void
	 * @return valor de retorno é a String do código
	 */
	@Override
	public String getCode() {
		return getCodigo();
	}
	
	/**
	 * @brief Método que faz o link entre o metodo setCode da classe alvo do adaptador
	 * @param codigo é uma String que contem o codigo da oferta selecionada pelo usuario
	 * (4 caracteres)
	 * @return void
	 */
	@Override
	public  void setCode(String codigo) {
		setCodigo(codigo);
	}
	
	/**
	 * @brief Método que faz o link entre o metodo getColleague da classe alvo do adaptador
	 * @param void
	 * @return Retorno é um objeto Colleague que representa o estabelecimento cadastrado
	 * no mediator
	 */
	@Override
	public Colleague getCol() {
		return getColleague();
	}
	
	/**
	 * @brief Método que faz o link entre o metodo setColleague da classe alvo do adaptador
	 * @param c é um objeto do tipo Colleague que representa um dos estabelecimentos
	 * cadastrados no mediator
	 * @return void
	 */
	@Override
	public void setCol(Colleague c) {
		setColleague(c);
	}


}
