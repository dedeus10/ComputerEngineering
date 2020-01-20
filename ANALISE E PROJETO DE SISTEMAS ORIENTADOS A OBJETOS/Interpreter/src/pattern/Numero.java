package pattern;

public class Numero implements Expression {

    private int numero;

    public Numero(int numero) {
        this.numero = numero;
    }

    @Override
    public int interpretar() {
        return this.numero;
    }
}