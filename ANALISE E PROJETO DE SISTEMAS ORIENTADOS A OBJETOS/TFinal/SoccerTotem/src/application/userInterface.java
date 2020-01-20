	package application;

import java.util.Scanner;

/**
 * 
 * @author dedeus
 *\file userInterface.java
 *
 *Classe implementa uma interface com o usuario por meio do console
 */

/**
 * 
 * @author dedeus
 *@class public class userInterface
 *@brief Classe implementa uma interface read/write com o usuario por meio do console 
 */
public class userInterface {
	///@var sc1 é um scanner de leitura do consele
	Scanner sc1 = new Scanner(System.in);
	
	/**
	 * @brief Tela inicial do programa, requisita se é usuario ou desenvolvedor
	 * @param void
	 * @return True caso Dev e False caso User
	 */
	public Boolean telaInicial() {
		System.out.println(" ---- Welcome to Soccer Totem :) ----");
		System.out.println("-> Voce é: ");
		System.out.println(" 0 - Usuário");
		System.out.println(" 1 - Desenvolvedor");
		if(sc1.nextInt()==1)
			return true;
		else
			return false;
	}
	
	/**
	 * @brief Tela de seleção do tipo de jogo a ser buscado
	 * @param void
	 * @return o valor referente a opção selecionada
	 */
	public Integer tipoJogo() {
		System.out.println("-> Tipo de jogo ");
		System.out.println(" 1 - Quadra");
		System.out.println(" 2 - Campo");
		System.out.println(" 4 - Sair");
		System.out.print("-> Interessado em: ");
		return sc1.nextInt();
	}
	
	/**
	 * @brief Tela de seleção para adicionar churrasco e/ou assador ao pacote
	 * @param op indica se esta reservando churrasqueira ou assador (0/1)
	 * @return String com S/N
	 */
	public String churras(Integer op) {
		if(op == 0)
			System.out.print("\n-> Reservar area de churrasco ? (S/N)");
		else
			System.out.print("\n-> Reservar assador ? (S/N)");
		return sc1.next();
	}
	
	/**
	 * @brief Tela de seleção dos estabelecimentos
	 * @param void
	 * @return o valor referente a opção selecionada
	 */
	public Integer estab() {
		System.out.println("\n");
		System.out.println(" -> Estabelecimentos credenciados");
		System.out.println(" 1 - Dalla Favera");
		System.out.println(" 2 - Pains");
		System.out.println(" 3 - Olé Futbol");
		System.out.println(" 4 - Corinthians");
		System.out.println(" 6 - Sair");
		System.out.print(" -> Selecione um estabelecimento: ");
		return sc1.nextInt();
	}
	
	/**
	 * @brief Tela de seleção do pacote de oferta
	 * @param void
	 * @return A String de 4 caracteres referente ao codigo da oferta
	 */
	public String selectLocate() {
		System.out.println(" -> Selecione um Local (Digite codigo ex. Q119)");
		return sc1.next();
	}
	
	/**
	 * @brief Tela de pagamento que faz interface com o banco
	 * @param op indica se é o primeiro uso ou nao (0/1)
	 * @return 0 valor inserido no totem
	 */
	public Integer paymentSystem(Integer op) {
		if(op == 0)
		{
			System.out.println("\nBem vindo ao Sistema de pagamento: ");
			return 0;
		}else {
			System.out.println("\nInsira a cedula:");
			return sc1.nextInt();
		}
		
	}
}
