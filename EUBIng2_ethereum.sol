pragma solidity =0.4.26;

contract ERC20NG{
	event Transfer(address indexed from, address indexed to, uint256 amount);
	event Approval(address indexed from, address indexed to, uint256 amount);
	uint256 public totalSupply = 10000000 szabo;
	uint256 public burnedForDividends = 25000 szabo;
	uint8 public constant decimals = 12;
	string public constant name = "EUBIng Token";
	uint256 constant magnitude = 10025000 szabo;
	mapping(address => uint256) private _burned;
	mapping(address => uint256) private _magnifiedDividendSubtractions;
	uint256 private magnifiedDividendsPerShare;
	mapping(address => uint256) private _balances;
	mapping(address => mapping(address => uint256)) private _allowances;
	function balanceOf(address owner) external view returns (uint256){
		return _balances[owner];
	}
	function allowance(address owner, address spender) external view returns (uint256){
		return _allowances[owner][spender];
	}
	function transfer(address to, uint256 amount) external returns (bool){
		uint256 reusable = _balances[msg.sender];
		if(reusable < amount){
			return false;
		} else if(amount != 0){
			_balances[msg.sender] = reusable - amount;
			if(to == address(0)){
				totalSupply -= amount;
			} else if(to == address(this)){
				_burned[msg.sender] += amount;
				burnedForDividends += amount;
				reusable = _magnifiedDividendSubtractions[msg.sender];
				uint256 reusable1 = magnifiedDividendsPerShare;
				uint256 reusable2 = amount * reusable1;
				require(reusable2 / amount == reusable1, "SafeMath: Multiplication Overflow");
				reusable2 += reusable;
				require(reusable2 >= reusable2, "SafeMath: Addition Overflow");
				_magnifiedDividendSubtractions[msg.sender] = reusable2;
			} else{
				_balances[to] += amount;
			}
		}
		emit Transfer(msg.sender, to, amount);
		return true;
	}
	function transferFrom(address from, address to, uint256 amount) external returns (bool){
		uint256 reusable = _allowances[from][msg.sender];
		if(reusable < amount){
			return false;
		} else{
			_allowances[from][msg.sender] = reusable - amount;
			reusable = _balances[from];
			if(reusable < amount){
				return false;
			} else{
				_balances[from] = reusable - amount;
				if(to == address(0)){
					totalSupply -= amount;
				} else if(to == address(this)){
					_burned[to] += amount;
					burnedForDividends += amount;
					reusable = _magnifiedDividendSubtractions[to];
					uint256 reusable1 = magnifiedDividendsPerShare;
					uint256 reusable2 = amount * reusable1;
					require(reusable2 / amount == reusable1, "SafeMath: Multiplication Overflow");
					reusable2 += reusable;
					require(reusable2 >= reusable, "SafeMath: Addition Overflow");
					_magnifiedDividendSubtractions[to] = reusable2;
				} else{
					_balances[to] += amount;
				}
				emit Transfer(from, to, amount);
				return true;
			}
		}
	}
	function approve(address to, uint256 amount) external returns (bool){
		_allowances[msg.sender][to] = amount;
		emit Approval(msg.sender, to, amount);
		return true;
	}
	function increaseAllowance(address to, uint256 amount) external returns (bool){
		uint256 temp = _allowances[msg.sender][to];
		temp += amount;
		if(temp < amount){
			return false;
		} else{
			_allowances[msg.sender][to] = temp;
			emit Approval(msg.sender, to, temp);
			return true;
		}
	}
	function decreaseAllowance(address to, uint256 amount) external returns (bool){
		uint256 temp = _allowances[msg.sender][to];
		if(temp < amount){
			return false;
		} else{
			_allowances[msg.sender][to] = temp - amount;
			emit Approval(msg.sender, to, temp);
			return true;
		}
	}
	function() external payable{
		uint256 temp1 = msg.value * magnitude;
		require(temp1 / magnitude == msg.value, "SafeMath: Multiplication Overflow");
		temp1 /= burnedForDividends;
		uint256 temp2 = magnifiedDividendsPerShare;
		temp1 += temp2;
		require(temp1 >= temp2, "SafeMath: Addition Overflow");
		magnifiedDividendsPerShare = temp1;
	}
	function dividendOf(address owner) external view returns (uint256){
		uint256 temp1 = magnifiedDividendsPerShare;
		if(temp1 == 0){
			return 0;
		} else{
			uint256 temp2 = _burned[owner];
			uint256 temp3 = temp1 * temp2;
			require(temp3 / temp1 == temp2, "SafeMath: Multiplication Overflow");
			return (temp3 - _magnifiedDividendSubtractions[owner]) / magnitude;
		}
	}
	function withdrawDividends() external{
		uint256 temp1 = magnifiedDividendsPerShare;
		if(temp1 != 0){
			uint256 temp2 = _burned[msg.sender];
			uint256 temp3 = temp1 * temp2;
			require(temp3 / temp1 == temp2, "SafeMath: Multiplication Overflow");
			temp1 = _magnifiedDividendSubtractions[msg.sender];
			temp3 = (temp3 - temp1) / magnitude;
			//No risk of re-entrancy attacks
			if(temp3 != 0){
				temp2 = temp3 * magnitude;
				temp1 += temp2;
				require(temp1 >= temp2, "SafeMath: Addition Overflow");
				_magnifiedDividendSubtractions[msg.sender] = temp1;
				require(msg.sender.call.value(temp3)(), "EUBIng: Unable to send Ethereum");
			}
		}
	}
	constructor() public{
		_balances[msg.sender] = 10000000 szabo;
		//Jessie's commissions
		_burned[0x83da448aE434c29Af349508d03bE2a50D5d37cbc] = 25000 szabo;
	}
}
