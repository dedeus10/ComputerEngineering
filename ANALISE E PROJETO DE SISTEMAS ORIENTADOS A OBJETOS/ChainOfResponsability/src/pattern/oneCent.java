package pattern;

public class oneCent implements Slots {
	private Slots sucessor;
	private salesMachine machine;
	
	public oneCent(salesMachine M) {
		this.machine = M;
	}
	void Addsucess(Slots sucess){
		this.sucessor = sucess;
	}
	
	@Override
	public Integer processarCoin(Integer coin) {
		if(coin == 1) {
			return machine.newCoin(coin);
			
		}else {
			return sucessor.processarCoin(coin);
		}
	}

	@Override
	public String toString() {
		return "oneCent [sucessor=" + sucessor + "]";
	}
	
}
