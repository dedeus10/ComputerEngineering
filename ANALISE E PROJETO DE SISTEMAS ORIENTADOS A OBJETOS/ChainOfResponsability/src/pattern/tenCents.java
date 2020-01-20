package pattern;

public class tenCents implements Slots{
	private Slots sucessor;
	private salesMachine machine;
	
	public tenCents(salesMachine M) {
		this.machine = M;
	}
	
	
	void Addsucess(Slots sucess){
		this.sucessor = sucess;
	}

	
	@Override
	public Integer processarCoin(Integer coin) {
		if(coin == 10) {
			return machine.newCoin(coin);
		}else {
			if(sucessor != null)
				return sucessor.processarCoin(coin);
			else
				System.out.println("Invalid coin!!! \n");
			return null;
		}
	}


	@Override
	public String toString() {
		return "tenCents [sucessor=" + sucessor + "]";
	}
	
}
