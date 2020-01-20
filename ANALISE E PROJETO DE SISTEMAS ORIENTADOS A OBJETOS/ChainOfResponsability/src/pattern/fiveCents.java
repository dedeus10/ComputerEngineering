package pattern;

public class fiveCents implements Slots {
	
	private Slots sucessor;
	private salesMachine machine;
	
	public fiveCents(salesMachine M) {
		this.machine = M;
	}
	
	void Addsucess(Slots sucess){
		this.sucessor = sucess;
	}

	@Override
	public Integer processarCoin(Integer coin) {
		if(coin == 5) {
			return machine.newCoin(coin);
		}else {
			return sucessor.processarCoin(coin);
		}
	}
	
	@Override
	public String toString() {
		return "fiveCents [sucessor=" + sucessor + "]";
	}
}
