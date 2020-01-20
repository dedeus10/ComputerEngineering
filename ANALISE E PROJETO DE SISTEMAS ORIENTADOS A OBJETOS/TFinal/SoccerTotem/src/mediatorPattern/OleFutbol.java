
package mediatorPattern;

import java.util.HashMap;
import java.util.Map;

import adapterPattern.gameTarget;
import templatePattern.fieldGame;
import templatePattern.fieldGamePlusChurras;
import templatePattern.fieldGamePlusChurrasPlusAssador;
import templatePattern.futsalGame;
import templatePattern.futsalGamePlusChurras;
import templatePattern.futsalGamePlusChurrasPlusAssador;
import templatePattern.soccerGame;

/**
 * 
 * @author dedeus
 *\file OleFutbol.java
 *
 *Classe é a implementação de um estabelecimento de jogos
 *extende a classe colleague para vinculo no padrão
 *Mediator 
 */

/**
 * 
 * @author dedeus
 *@class public class OleFutbol extends Colleague
 *@brief Classe implementa serviços de um estabelecimento de jogos de futebol sendo um instancia de Colleague para vinculação
 *com o padrão Mediator
 */
public class OleFutbol extends Colleague {

	/**
	 * @list Quadra lista das quadras credenciadas neste estabelecimento
	 * @list Campo lista dos campos credenciados neste estabelecimento
	 */
	Map<String, String> Quadra = new HashMap<String, String>();
	Map<String, String> Campo = new HashMap<String, String>();
	
	/**
	 * @def valorQuadra constante que representa o valor total do aluguel da quadra
	 * @def valorCampo constante que representa o valor total do aluguel do Campo
	 * @def valorChurras constante que representa o valor total do aluguel da churrasqueira
	 * @def valorAssador constante que representa o valor total do aluguel do assador
	 */
	final double valorQuadra = 120;
	final double valorCampo = 160;
	final double valorChurras = 80;
	final double valorAssador = 0;
	
	/**
	 * @brief Construtor do método.
	 * Cria uma nova instancia e credencia as quadras/campos
	 * @param m é um objeto do tipo Mediator onde o estabelecimento deve se vincular posteriormente utilizando comandos Root
	 */
	public OleFutbol(Mediator m) {
		super(m);
		Quadra.put("Q118", new String("Livre"));
		Quadra.put("Q119", new String("Livre"));

		Campo.put("C118", new String("Livre"));
		Campo.put("C119", new String("Livre"));
	}

	/**
	 * @brief Implementação do metodo toString para vizualização de informações da classe
	 * @param void
	 * @return Retorna String com informações
	 */
	@Override
	public String toString() {
		return "OleFutbol \nvalorQuadra = R$" + valorQuadra + "\nvalorCampo = R$"
				+ valorCampo + "\nvalorChurras = R$" + valorChurras + "\nvalorAssador = R$" + valorAssador + "\nN° Quadras: "
				+ Quadra.size() + "\nN° Campos: " + Campo.size();
	}

	/**
	 * @brief Metodo implementa uma recepção de mensagem entre os Colleagues
	 * @param mensagem é uma String contendo a informação recebida
	 * @return void
	 * @warning atualmente utilizada apenas para debug de comunicação
	 */
	@Override
	public void receberMensagem(String mensagem) {

		System.out.println("OleFutbol recebeu: " + mensagem);
	}

	/**
	 * @brief Metodo que efetivamente marca o jogo trocando o estado da quadra/campo para marcado
	 * e informando o valor total do jogo
	 * @param game é um objeto generico para um jogo (gameTarget) no qual foi usado 
	 * adaptadores para representar o  tipo do jogo
	 * @return O valor total do jogo 
	 */
	public double marcarJogo(gameTarget game) {
		String type = "";
		String ID = "";
		
		ID = game.getCode();
		type = ID.substring(0, 1);
		
		if (type.equals("Q")) {
			for (String key : Quadra.keySet()) {
				String value = Quadra.get(key);
				String cod = key.substring(0, 2);
				String hours = key.substring(2, 4);

				if (key.equals(ID)) {
					if (value.equals("Livre")) {
						// Troca estado
						Quadra.replace(key, "Marcado");
						value = Quadra.get(key);
						System.out.println("Codigo: " + key);
						System.out.println("Quadra: " + cod);
						System.out.println("Horas: " + hours + "h");
						System.out.println("Disponivel: " + value);
					
						if(game instanceof futsalGame)
							return valorQuadra;
						else if(game instanceof futsalGamePlusChurras) {
							System.out.println("Churrasqueira: Adicionada");
							return (valorQuadra+valorChurras);
						}
						else if(game instanceof futsalGamePlusChurrasPlusAssador) {
							System.out.println("Churrasqueira: Adicionada");
							System.out.println("Assador: Adicionado");
							return (valorQuadra+valorChurras+valorAssador);
						}
						System.out.println("\n");
						
					} else {
						System.out.println("Quadra ja foi agendada!!!");
						System.out.println("\n");
						return 0;
					}
				}
			}
		} else if (type.equals("C")) {
			for (String key : Campo.keySet()) {
				String value = Campo.get(key);
				String cod = key.substring(0, 2);
				String hours = key.substring(2, 4);

				if (key.equals(ID)) {
					if (value.equals("Livre")) {
						// Troca estado
						Campo.replace(key, "Marcado");
						value = Campo.get(key);
						System.out.println("Codigo: " + key);
						System.out.println("Campo: " + cod);
						System.out.println("Horas: " + hours + "h");
						System.out.println("Disponivel: " + value);
						
						if(game instanceof fieldGame)
							return valorCampo;
						else if(game instanceof fieldGamePlusChurras) {
							System.out.println("Churrasqueira: Adicionada");
							return (valorCampo+valorChurras);
						}
						else if(game instanceof fieldGamePlusChurrasPlusAssador) {
							System.out.println("Churrasqueira: Adicionada");
							System.out.println("Assador: Adicionado");
							return (valorCampo+valorChurras+valorAssador);
						}
						System.out.println("\n");
							
					} else {
						System.out.println("Campo ja foi agendada!!!");
						System.out.println("\n");
						return 0;
					}
				}
			}
		}
		System.out.println("Local não encontrado!!!");
		System.out.println("\n");
		return 0;
	}

	/**
	 * @brief Metodo que lista as ofertas de jogos baseado na busca do usuário
	 * @param game é um objeto generico para um jogo (soccerGame) no qual foi usado 
	 * adaptadores para representar o  tipo do jogo
	 * @return void
	 */
	public void proposedAnalysis(soccerGame game) {

		System.out.println("\n");
		System.out.println("---Disponibilidade para jogos em: Ole Futbol---");

		if (game instanceof futsalGame || game instanceof futsalGamePlusChurras || game instanceof futsalGamePlusChurrasPlusAssador) {
			for (String key : Quadra.keySet()) {
				String value = Quadra.get(key);
				String cod = key.substring(0, 2);
				String hours = key.substring(2, 4);

				if (value.equals("Livre")) {
					System.out.println("Codigo: " + key);
					System.out.println("Quadra: " + cod);
					System.out.println("Horas: " + hours + "h");
					System.out.println("Disponivel: " + value);
					if (game instanceof futsalGamePlusChurras) {
						System.out.println("Churrasqueira: Adicionada");
					}
					else if(game instanceof futsalGamePlusChurrasPlusAssador) {
						System.out.println("Churrasqueira: Adicionada");
						System.out.println("Assador: Adicionado");
					}
					System.out.println("\n");
				}
			}
		} else if (game instanceof fieldGame || game instanceof fieldGamePlusChurras || game instanceof fieldGamePlusChurrasPlusAssador) {
			for (String key : Campo.keySet()) {
				String value = Campo.get(key);
				String cod = key.substring(0, 2);
				String hours = key.substring(2, 4);

				if (value.equals("Livre")) {
					System.out.println("Codigo: " + key);
					System.out.println("Campo: " + cod);
					System.out.println("Horas: " + hours + "h");
					System.out.println("Disponivel: " + value);
					if (game instanceof fieldGamePlusChurras) {
						System.out.println("Churrasqueira: Adicionada");
					}
					else if (game instanceof fieldGamePlusChurrasPlusAssador) {
						System.out.println("Churrasqueira: Adicionada");
						System.out.println("Assador: Adicionado");
					}
					System.out.println("\n");
				}

			}
		}
	}
}