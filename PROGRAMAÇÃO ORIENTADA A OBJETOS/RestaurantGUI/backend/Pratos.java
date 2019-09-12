/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Pratos
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : Pratos.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : backend class, contains methods and information of pratos 
--
--
--------------------------------------------------------------------------------

*/

package backend;

import java.util.ArrayList;

public class Pratos {
    private int Codigo;
    private String Nome;
    private String Descricao;
    private float Preco;
    ArrayList<Pratos> ListaPratos;
    
    public Pratos() {
    	Codigo = 0;
    	Nome = "";
    	Descricao = "";
    }
    
	public Pratos(int codigo, String nome, String descricao, float preco) {
		Codigo = codigo;
		Nome = nome;
		Descricao = descricao;
		Preco = preco;
		ListaPratos = new ArrayList();

		
	}
	
	public int getCodigo() {
		return Codigo;
	}
	public void setCodigo(int codigo) {
		Codigo = codigo;
	}
	public String getNome() {
		return Nome;
	}
	public void setNome(String nome) {
		Nome = nome;
	}
	public String getDescricao() {
		return Descricao;
	}
	public void setDescricao(String descricao) {
		Descricao = descricao;
	}
	
	public float getPreco() {
		return Preco;
	}

	public void setPreco(float preco) {
		Preco = preco;
	}

	public ArrayList<Pratos> getListaPratos() {
		return ListaPratos;
	}
	public void setListaPratos(ArrayList<Pratos> listaPratos) {
		ListaPratos = listaPratos;
		
	}
	
	public void ImprimeListaPratos() {
		for(int i = 0; i<ListaPratos.size();i++) {
			System.out.println(ListaPratos.get(i).getCodigo());
		}
		
	}
    
}
