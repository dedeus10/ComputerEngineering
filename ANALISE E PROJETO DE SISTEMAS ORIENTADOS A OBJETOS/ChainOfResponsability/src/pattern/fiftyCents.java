package pattern;

public class fiftyCents implements Slots{
	private Slots sucessor;
	private salesMachine machine;
	
	public fiftyCents(salesMachine M) {
		this.machine = M;
	}
	
	
	void Addsucess(Slots sucess){
		this.sucessor = sucess;
	}

	
	@Override
	public Integer processarCoin(Integer coin) {
		if(coin == 50) {
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
		return "fiftyCents [sucessor=" + sucessor + "]";
	}
	
}
