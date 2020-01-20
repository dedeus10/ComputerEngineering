package mediatorPattern;

import java.text.DecimalFormat;

import java.util.ArrayList;

import adapterPattern.gameTarget;
import templatePattern.fieldGame;
import templatePattern.soccerGame;

/**
 * 
 * @author dedeus
 *\file MediatorMessage.java
 *
 *Classe é uma interface para Mediadores
 */

/**
 * 
 * @author dedeus
 *@class public class MediatorMessage implements Mediator
 *@brief Classe implementa o padrão Mediator intermediando a comunicação entre colleagues e 
 *Entre o sistema e os Colleagues
 */
public class MediatorMessage implements Mediator {
	
	///@list contatos é uma Lista de contatos do mediator
	protected ArrayList<Colleague> contatos;

	/**
	 * @brief Construtor do método.
	 * Cria uma nova instancia e cria a lista de contatos
	 * @param void
	 */
	public MediatorMessage() {
		contatos = new ArrayList<Colleague>();
	}

	/**
	 * @brief Implementação do metodo que adiciona um Colleague aos contatos do mediator
	 * @param colleague estabelecimento a ser adicionado
	 * @return void
	 * @warning preferencialmente acessar via comandos root do sistema
	 */
	public void adicionarColleague(Colleague colleague) {
		System.out.println("Estabelecimento credenciado com sucesso!");
		contatos.add(colleague);
	}


	/**
	 * @brief Implementação do metodo que remove um Colleague dos contatos do mediator
	 * @param colleague estabelecimento a ser removido
	 * @return void
	 * @warning preferencialmente acessar via comandos root do sistema
	 */
	public void removeColleague(Colleague colleague) {
		if (!contatos.isEmpty()) {
			contatos.remove(colleague);
			System.out.println("Estabelecimento removido com sucesso!");
		} else
			System.out.println("Sem Estabelecimentos cadastrados!");

	}

	/**
	 * @brief Implementação do metodo que exibe N° de estabelecimentos cadastrados
	 * @param void
	 * @return void
	 * @warning preferencialmente acessar via comandos root do sistema
	 */
	public void sizeOfEstablishment() {
		System.out.println("N° Estabelecimentos credenciados: " + contatos.size());
	}

	/**
	 * @brief Implementação do metodo que lista os estabelecimentos cadastrados
	 * @param void
	 * @return void
	 * @warning preferencialmente acessar via comandos root do sistema
	 */
	public void listEstablishment() {
		System.out.println("--Estabelecimentos credenciados--");
		int i = 0;
		for (Colleague contato : contatos) {

			System.out.println(i + " - " + contato + "\n");
			i++;
		}
	}

	/**
	 * @brief Implementação do metodo que envia um broadcast para os colleagues
	 * @param mensagem é a String do pacote
	 * @param colleague é o estabelecimento que esta emitindo o broadcast
	 * @return void
	 * @warning Usada apenas para debug de comunicação nesta versão
	 */
	@Override
	public void enviar(String mensagem, Colleague colleague) {
		for (Colleague contato : contatos) {
			if (contato != colleague) {
				contato.receberMensagem(mensagem);
			}
		}
	}

	/**
	 * @brief Implementação do metodo que intermedia a comunicação com os estabelecimentos, pedindo para mostrarem as ofertas
	 * @param game é o jogo construido 
	 * @return void
	 */
	@Override
	public void proporOferta(soccerGame game) {
		for (Colleague contatoSeller : contatos) {
			if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof DallaFavera) {
				((DallaFavera) contatoSeller).proposedAnalysis(game);
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof PainsSports) {
				((PainsSports) contatoSeller).proposedAnalysis(game);
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof OleFutbol) {
				((OleFutbol) contatoSeller).proposedAnalysis(game);
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof Corinthians) {
				((Corinthians) contatoSeller).proposedAnalysis(game);
			}

		}

	}

	/**
	 * @brief Implementação do metodo que efetivamente marca o jogo depois do usuario ter escolhido
	 * @param game é o jogo construido 
	 * @return retorna o valor total que deve ser pago pelo jogo
	 */
	@Override
	public double marcandoJogo(soccerGame game) {
		for (Colleague contatoSeller : contatos) {
			if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof DallaFavera) {
				return ((DallaFavera) contatoSeller).marcarJogo((gameTarget) game); 
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof PainsSports) {
				return ((PainsSports) contatoSeller).marcarJogo((gameTarget) game);
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof OleFutbol) {
				return ((OleFutbol) contatoSeller).marcarJogo((gameTarget) game);
			} else if (game.getColleague().equals(contatoSeller) && contatoSeller instanceof Corinthians) {
				return ((Corinthians) contatoSeller).marcarJogo((gameTarget) game);
			}
		}
		return 0;
	}

}
