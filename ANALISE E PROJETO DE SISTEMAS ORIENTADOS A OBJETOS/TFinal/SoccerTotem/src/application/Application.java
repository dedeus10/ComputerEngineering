package application;

import adapterPattern.fieldGameAdapter;
import adapterPattern.fieldGamePCAdapter;
import adapterPattern.fieldGamePCPAAdapter;
import adapterPattern.futsalAdapter;
import adapterPattern.futsalGamePCAdapter;
import adapterPattern.futsalGamePCPAAdapter;
import adapterPattern.gameTarget;
import chainOfResponsabilityPattern.fiftyBucks;
import chainOfResponsabilityPattern.fiveBucks;
import chainOfResponsabilityPattern.hundredBucks;
import chainOfResponsabilityPattern.tenBucks;
import chainOfResponsabilityPattern.twentyBucks;
import chainOfResponsabilityPattern.twoBucks;
import mediatorPattern.Bank;
import mediatorPattern.Corinthians;
import mediatorPattern.DallaFavera;
import mediatorPattern.MediatorMessage;
import mediatorPattern.OleFutbol;
import mediatorPattern.PainsSports;
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
*\file Application.java
*
*Classe de demonstration do sistema
*/

/**
* 
* @author dedeus
*@class public class Application
*@brief Classe implementa a aplicação do sistema
*/
public class Application {

	/**
	 * @brief Metodo main inicialização e fluxo do sistema
	 * @param args
	 * @return void
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MediatorMessage mediador = new MediatorMessage();

		DallaFavera Df = new DallaFavera(mediador);
		PainsSports Ps = new PainsSports(mediador);
		OleFutbol Ol = new OleFutbol(mediador);
		Corinthians Co = new Corinthians(mediador);
		Bank Bk = new Bank(mediador);

		twoBucks slot2 = new twoBucks(Bk);
		fiveBucks slot5 = new fiveBucks(Bk);
		tenBucks slot10 = new tenBucks(Bk);
		twentyBucks slot20 = new twentyBucks(Bk);
		fiftyBucks slot50 = new fiftyBucks(Bk);
		hundredBucks slot100 = new hundredBucks(Bk);

		Dev dev = new Dev(mediador, Bk, Df, Ps, Ol, Co);
		userInterface usr = new userInterface();
		clearScreen cls = new clearScreen();

		slot2.Addsucess(slot5);
		slot5.Addsucess(slot10);
		slot10.Addsucess(slot20);
		slot20.Addsucess(slot50);
		slot50.Addsucess(slot100);

	
		Integer option = 0;
		String local = "";
		Integer QC = 0;
		String churras = "";
		String assador = "";
		soccerGame nG = null;

		while (option != 6 || QC != 4) {
			if(usr.telaInicial())
				dev.console();

			cls.clear();

			QC = usr.tipoJogo();
			if (QC == 4)
				break;

			churras = usr.churras(0);
			assador = usr.churras(1);

			option = usr.estab();
			if (option == 6)
				break;

			gameTarget gmt = null;
			
			if (QC == 1 && churras.equals("N") && assador.equals("N")) {
				nG = new futsalGame();
				gmt = new futsalAdapter();
			} else if (QC == 2 && churras.equals("N") && assador.equals("N")) {
				nG = new fieldGame();
				gmt = new fieldGameAdapter();
			} else if (QC == 1 && churras.equals("S") && assador.equals("N")) {
				nG = new futsalGamePlusChurras();
				gmt = new futsalGamePCAdapter();
			} else if (QC == 2 && churras.equals("S") && assador.equals("N")) {
				nG = new fieldGamePlusChurras();
				gmt = new fieldGamePCAdapter();
			} else if (QC == 1 && churras.equals("S") && assador.equals("S")) {
				nG = new futsalGamePlusChurrasPlusAssador();
				gmt = new futsalGamePCPAAdapter();
			} else if (QC == 2 && churras.equals("S") && assador.equals("S")) {
				nG = new fieldGamePlusChurrasPlusAssador();
				gmt = new fieldGamePCPAAdapter();
			}
			
			switch (option) {
			case 1:
				nG.buildGame(Df);
				
				break;

			case 2:
				nG.buildGame(Ps);
				break;

			case 3:
				nG.buildGame(Ol);
				break;

			case 4:
				nG.buildGame(Co);
				break;

			default:
				break;
			}

			
			gmt.setCol(nG.getColleague());
			gmt.getCol().proporOferta(nG);

			local = usr.selectLocate();
			gmt.setCode(local);
			double valorJogo = mediador.marcandoJogo((soccerGame)(gmt));
			
		
			boolean ok = false;
			usr.paymentSystem(0);
			System.out.println("\nValor a ser pago: R$: " + valorJogo);
			while (!ok) {
				Integer buck = usr.paymentSystem(1);
				ok = slot2.processarPilas(buck, valorJogo);
				if (ok) {
					System.out.println("\nPagamento Aprovado, tenha um bom jogo\n\n");
				}
			}

		}
		System.out.println(" End of Program! ");
		System.out.println(" Thank you :) ");
	}
}
