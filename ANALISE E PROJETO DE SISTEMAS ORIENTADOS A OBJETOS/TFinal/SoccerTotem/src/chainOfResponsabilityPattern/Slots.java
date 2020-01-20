package chainOfResponsabilityPattern;

/**
 * 
 * @author dedeus
 *\file Slots.java
 *
 *Classe é uma interface para os slots criados seguindo
 *o padrão Chain of Responsability
*/

/**
 * 
 * @author dedeus
 *@class public interface Slots
 *@brief Classe é uma intrface do padrão Chain of Responsability sendo um slot pra cédulas
 */
public interface Slots {
	
	/**
	 * @brief Protótipo do metodo processarPilas que verifica se o valor encaminhado é
	 * referente a este slot, no caso positivo repassa ao banco, em caso
	 * negativo repassa para o sucessor na Chain
	 * @param Bucks é o valor da cédula recebida pelo Totem
	 * @param valorJogo é o valor total que é necessário ser recebido para liberar o jogo
	 * @return True em caso de ter chegado no valor, caso contrário False
	 */
	public boolean processarPilas(Integer Bucks, double valorJogo);

}
