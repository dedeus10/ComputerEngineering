package application;

import java.util.Scanner;

import commandPattern.Command;
import commandPattern.addCommand;
import commandPattern.deleteCommand;
import commandPattern.listCommand;
import commandPattern.service;
import commandPattern.sizeCommand;
import mediatorPattern.Bank;
import mediatorPattern.Corinthians;
import mediatorPattern.DallaFavera;
import mediatorPattern.MediatorMessage;
import mediatorPattern.OleFutbol;
import mediatorPattern.PainsSports;

public class Dev {
	/**
	 * @var mediador instancia de um mediator usado para vincular os Colleagues
	 * @var Df instancia do estabelecimento DallaFavera, usado para vincular no mediator
	 * @var Ps instancia do estabelecimento PainsSports, usado para vincular no mediator
	 * @var Ol instancia do estabelecimento OleFutbol, usado para vincular no mediator
	 * @var Co instancia do estabelecimento Corinthians, usado para vincular no mediator
	 * @var Bk instancia do Banco, usado para vincular no mediator
	 */
	MediatorMessage mediador;
	DallaFavera Df;
	PainsSports Ps;
	OleFutbol Ol;
	Corinthians Co;
	Bank Bk;
	
	/**
	 * @var del instancia do comando delete
	 * @var add instancia do comando adicionar
	 * @var size instancia do comando tamanho
	 * @var list instancia do comando listar
	 * @var svc instancia do serviço, invoker
	 */
	Command del;
	Command add;
	Command size;
	Command list;
	service svc = new service();
	
	/**
	 * @brief Construtor do metodo, cria uma isntancia e ja adiciona todos os estabelecimentos
	 * @param mediador instancia de um mediator usado para vincular os Colleagues
	 * @param bk instancia do Banco, usado para vincular no mediator
	 * @param df instancia do estabelecimento DallaFavera, usado para vincular no mediator
	 * @param ps instancia do estabelecimento PainsSports, usado para vincular no mediator
	 * @param ol instancia do estabelecimento OleFutbol, usado para vincular no mediator
	 * @param co instancia do estabelecimento Corinthians, usado para vincular no mediator
	 * @warning foram adicionados por comodidade, porem poderiam ser adicionados via 
	 * comando no console implementado
	 */
	public Dev(MediatorMessage mediador, Bank bk, DallaFavera df, PainsSports ps, OleFutbol ol, Corinthians co) {
		super();
		this.mediador = mediador;
		Df = df;
		Ps = ps;
		Ol = ol;
		Co = co;
		Bk = bk;
		
		del = new deleteCommand(mediador);
		add = new addCommand(mediador);
		size = new sizeCommand(mediador);
		list = new listCommand(mediador);
		
		
		svc.setCommand(add);
		svc.commandExec(Bk);
		svc.commandExec(Df);
		svc.commandExec(Ps);
		svc.commandExec(Ol);
		svc.commandExec(Co);
	}

	/**
	 * @brief Implementação do console para root, permite executar operações via linha
	 * de comando
	 * @param void
	 * @return void
	 */
	public void console() {
	
		String cmd = "";
		Scanner sc1 = new Scanner(System.in);
		
		System.out.println("-- Bem vindo ao console do sistema ---");
		while (!cmd.equals("exit")) {
			System.out.print("root:~$ ");
			cmd = sc1.next();
			if (cmd.equals("add")) {
				svc.setCommand(add);
				System.out.print("-> ");
				cmd = sc1.next();
				if (cmd.equals("Bank"))
					svc.commandExec(Bk);
				else if (cmd.equals("Dalla"))
					svc.commandExec(Df);
				else if (cmd.equals("Pains"))
					svc.commandExec(Ps);
				else if (cmd.equals("Ole"))
					svc.commandExec(Ol);
				else if (cmd.equals("Cor"))
					svc.commandExec(Co);

			} else if (cmd.equals("del")) {
				svc.setCommand(del);
				System.out.print("-> ");
				cmd = sc1.next();
				if (cmd.equals("Bank"))
					svc.commandExec(Bk);
				else if (cmd.equals("Dalla"))
					svc.commandExec(Df);
				else if (cmd.equals("Pains"))
					svc.commandExec(Ps);
				else if (cmd.equals("Ole"))
					svc.commandExec(Ol);
				else if (cmd.equals("Cor"))
					svc.commandExec(Co);

			} else if (cmd.equals("list")) {
				svc.setCommand(list);
				svc.commandExec(Co);

			} else if (cmd.equals("size")) {
				svc.setCommand(size);
				svc.commandExec(Co);

			} 
		}

	}
}
