/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Funcionario Avançado
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : FuncionarioAvancado.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : backend class, extends funcionario.java and contains login and password 
--
--
--------------------------------------------------------------------------------

*/

package backend;

public class FuncionarioAvancado extends Funcionario {
	private String login;
	private String senha;

	public FuncionarioAvancado(String Nome, int idade, String cpf, String Dept, String login, String senha) {
		super(Nome, idade, cpf, Dept);
		this.login = login;
		this.senha = senha;
	}

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public String getSenha() {
		return senha;
	}

	public void setSenha(String senha) {
		this.senha = senha;
	}

}
