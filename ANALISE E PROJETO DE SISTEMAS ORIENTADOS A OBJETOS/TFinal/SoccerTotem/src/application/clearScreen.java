package application;

/**
 * 
 * @author dedeus
 *\file clearScreen.java
 *
 *Classe implementa espaços em branco para limpar a tela
 */

/**
 * 
 * @author dedeus
 *@class public class clearScreen 
 *@brief Classe implementa um clear screen via brute force
 */
public class clearScreen {

	public void clear()
	{
		for(int i=0; i<50; i++)
			System.out.println();
	}
}
