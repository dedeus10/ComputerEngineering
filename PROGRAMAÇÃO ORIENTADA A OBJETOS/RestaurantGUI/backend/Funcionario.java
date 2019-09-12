/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Funcionarios
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : Funcionario.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : backend class, contains methods and information of funcionarios 
--
--
--------------------------------------------------------------------------------

*/


package backend;

public class Funcionario {
	private String Nome;
	private int idade;
	private String cpf;
	private String Dept;

	public Funcionario(String Nome, int idade, String cpf, String Dept) {
		this.idade = idade;
		this.Nome = Nome;
		this.cpf = cpf;
		this.Dept = Dept;
	}

	public String getDept() {
		return Dept;
	}

	public void setDept(String dept) {
		Dept = dept;
	}

	public int getIdade() {
		return idade;
	}

	public void setIdade(int idade) {
		this.idade = idade;
	}

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	public String getNome() {
		return Nome;
	}

	public void setNome(String Nome) {
		this.Nome = Nome;
	}

}
