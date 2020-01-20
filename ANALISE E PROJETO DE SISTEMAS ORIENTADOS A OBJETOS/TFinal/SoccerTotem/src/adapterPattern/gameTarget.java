package adapterPattern;

import mediatorPattern.Colleague;

/**
 * 
 * @author dedeus
 *\file gameTarget.java
 *
 *Classe é uma interface para implementação
 *do padrão Adapter que permite criar
 *adaptadores de jogos especificos para uma instância
 *de jogo qualqer 
 
/**
 * 
 * @author dedeus
 *@class public interface gameTarget
 *@brief Classe é uma interface para o padrão Adapter para jogos de futebol
 */
public interface gameTarget {

	/**
	 * @brief Protótipo do método que faz o link entre o metodo reservaLocal da classe alvo do adaptador
	 * @param colleague é um objeto do tipo Colleague que representa um dos estabelecimentos
	 * cadastrados no mediator
	 * @return void
	 */
	public void reservaL(Colleague colleague);
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo reservaC da classe alvo do adaptador
	 * @param void
	 * @return void
	 */
	public void reservaC();
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo reservaAssador da classe alvo do adaptador
	 * @param void
	 * @return void
	 */
	public  void reservaA();
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo getCodigo da classe alvo do adaptador
	 * @param void
	 * @return valor de retorno é a String do código (4 caracteres)
	 */
	public  String getCode();
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo setCode da classe alvo do adaptador
	 * @param codigo é uma String que contem o codigo da oferta selecionada pelo usuario
	 * (4 caracteres)
	 * @return void
	 */
	public  void setCode(String codigo);
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo getColleague da classe alvo do adaptador
	 * @param void
	 * @return Retorno é um objeto Colleague que representa o estabelecimento cadastrado
	 * no mediator
	 */
	public Colleague getCol();
	
	/**
	 * @brief Protótipo do método que faz o link entre o metodo setColleague da classe alvo do adaptador
	 * @param c é um objeto do tipo Colleague que representa um dos estabelecimentos
	 * cadastrados no mediator
	 * @return void
	 */
	public void setCol(Colleague c);
	
}
