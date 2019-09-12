/*
--------------------------------------------------------------------------------
--                                                                            --
--                     PROGRAMAÇÃO ORIENTADA A OBJETOS                         --
--                        ENGENHARIA DE COMPUTAÇÃO                            --
--                     UNIVERSIDADE FEDERAL DE SANTA MARIA                    --
--------------------------------------------------------------------------------
--
-- Design      : Departamentos
-- Author      : Luis Felipe de Deus
--
--------------------------------------------------------------------------------
--
-- File        : Departamento.java
-- Created     : 13 nov 2018
--
--------------------------------------------------------------------------------
--
--  Description : backend class, contains methods and information of departments 
--
--
--------------------------------------------------------------------------------

*/



package backend;

import java.util.ArrayList;


public class Departamento {
    private int Codigo;
    private String Nome;
    private int sal_base;



    public Departamento(int Codigo, String Nome, int sal_base) {
        this.Codigo = Codigo;
        this.Nome = Nome;
        this.sal_base = sal_base;
    }

    public int getSal_base() {
		return sal_base;
	}

	public void setSal_base(int sal_base) {
		this.sal_base = sal_base;
	}

	public int getCodigo() {
        return Codigo;
    }

    public void setCodigo(int Codigo) {
        this.Codigo = Codigo;
    }

    public String getNome() {
        return Nome;
    }

    
	public void setNome(String Nome) {
        this.Nome = Nome;
    }


}
