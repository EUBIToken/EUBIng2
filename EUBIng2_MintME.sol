
// File: contracts/IERC20.sol

//SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.4.17;

library SafeMath {
	function toInt256Safe(uint256 a) internal pure returns (int256) {
		int256 b = int256(a);
		assert(b >= 0);
		return b;
	}
	function mul(int256 a, int256 b) internal pure returns (int256) {
		// Prevent overflow when multiplying INT256_MIN with -1
		// https://github.com/RequestNetwork/requestNetwork/issues/43
		assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
		int256 c = a * b;
		assert((b == 0) || (c / b == a));
		return c;
	}
	function div(int256 a, int256 b) internal pure returns (int256) {
		// Prevent overflow when dividing INT256_MIN by -1
		// https://github.com/RequestNetwork/requestNetwork/issues/43
		assert(!(a == - 2**255 && b == -1) && (b > 0));
		return a / b;
	}
	function sub(int256 a, int256 b) internal pure returns (int256) {
		int256 c = a - b;
		assert((b >= 0 && c <= a) || (b < 0 && c > a));
		return c;
	}
	function add(int256 a, int256 b) internal pure returns (int256) {
		int256 c = a + b;
		assert((b >= 0 && c >= a) || (b < 0 && c < a));
		return c;
	}
	function toUint256Safe(int256 a) internal pure returns (uint256) {
		assert(a >= 0);
		return uint256(a);
	}
	
	/**
	* @dev Multiplies two numbers, throws on overflow.
	*/
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		assert(c / a == b);
		return c;
	}
	/**
	* @dev Integer division of two numbers, truncating the quotient.
	*/
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b > 0);
		uint256 c = a / b;
		return c;
	}
	
	/**
	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	*/
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}
	
	/**
	* @dev Adds two numbers, throws on overflow.
	*/
	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		assert(c >= a);
		return c;
	}
	
	//EUBIng SafeMath2 extension
	function add(uint256 a, int256 b) internal pure returns (uint256) {
		if(b > 0){
			return add(a, uint256(b));
		} else{
			assert(b != int256(uint256(1) << 255));
			return sub(a, uint256(0 - b));
		}
	}
	function sub(uint256 a, int256 b) internal pure returns (uint256) {
		if(b > 0){
			return sub(a, uint256(b));
		} else{
			assert(b != int256(uint256(1) << 255));
			return add(a, uint256(0 - b));
		}
	}
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
contract IERC20 {
	/**
	 * @dev Returns the amount of tokens in existence.
	 */
	function totalSupply() external view returns (uint256);

	/**
	 * @dev Returns the amount of tokens owned by `account`.
	 */
	function balanceOf(address account) external view returns (uint256);

	/**
	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transfer(address recipient, uint256 amount) external returns (bool);

	/**
	 * @dev Returns the remaining number of tokens that `spender` will be
	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
	 * zero by default.
	 *
	 * This value changes when {approve} or {transferFrom} are called.
	 */
	function allowance(address owner, address spender) external view returns (uint256);

	/**
	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
	 * that someone may use both the old and the new allowance by unfortunate
	 * transaction ordering. One possible solution to mitigate this race
	 * condition is to first reduce the spender's allowance to 0 and set the
	 * desired value afterwards:
	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
	 *
	 * Emits an {Approval} event.
	 */
	function approve(address spender, uint256 amount) external returns (bool);

	/**
	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
	 * allowance mechanism. `amount` is then deducted from the caller's
	 * allowance.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

	/**
	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
	 * another (`to`).
	 *
	 * Note that `value` may be zero.
	 */
	event Transfer(address indexed from, address indexed to, uint256 value);

	/**
	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
	 * a call to {approve}. `value` is the new allowance.
	 */
	event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: contracts/extensions/IERC20Metadata.sol

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
contract IERC20Metadata is IERC20 {
	/**
	 * @dev Returns the name of the token.
	 */
	function name() external view returns (string memory);

	/**
	 * @dev Returns the symbol of the token.
	 */
	function symbol() external view returns (string memory);

	/**
	 * @dev Returns the decimals places of the token.
	 */
	function decimals() external view returns (uint8);
}
// File: contracts/ERC20.sol

/// @title Dividend-Paying Token Optional Interface
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev OPTIONAL functions for a dividend-paying token contract.
interface DividendPayingTokenOptionalInterface {
	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner) external view returns(uint256);

	/// @notice View the amount of dividend in wei that an address has withdrawn.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has withdrawn.
	function withdrawnDividendOf(address _owner) external view returns(uint256);

	/// @notice View the amount of dividend in wei that an address has earned in total.
	/// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has earned in total.
	function accumulativeDividendOf(address _owner) external view returns(uint256);
}

// File: contracts/DividendPayingTokenInterface.sol

/// @title Dividend-Paying Token Interface
/// @author Roger Wu (https://github.com/roger-wu)
/// @dev An interface for a dividend-paying token contract.
interface DividendPayingTokenInterface {
	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) external view returns(uint256);

	/// @notice Withdraws the ether distributed to the sender.
	/// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
	///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
	function withdrawDividend() external;

	/// @dev This event MUST emit when ether is distributed to token holders.
	/// @param from The address which sends ether to this contract.
	/// @param weiAmount The amount of distributed ether in wei.
	event DividendsDistributed(
	  address indexed from,
	  uint256 weiAmount
	);

	/// @dev This event MUST emit when an address withdraws their dividend.
	/// @param to The address which withdraws ether from this contract.
	/// @param weiAmount The amount of withdrawn ether in wei.
	event DividendWithdrawn(
	  address indexed to,
	  uint256 weiAmount
	);
}
contract IERC223Recipient { 
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
	function tokenFallback(address _from, uint _value, bytes memory _data) public;
}
/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract DividendPayingEUBIToken is IERC20, IERC20Metadata, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, IERC223Recipient{
	using SafeMath for *;
	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowances;

	uint256 private _totalSupply;

	string private _name;
	string private _symbol;

	/**
	 * @dev Returns the name of the token.
	 */
	function name() external view returns (string memory) {
		return "EUBIng2: Next-Generation Dividends-Paying EUBI Token";
	}

	/**
	 * @dev Returns the symbol of the token, usually a shorter version of the
	 * name.
	 */
	function symbol() external view returns (string memory) {
		return "EUBI";
	}

	/**
	 * @dev Returns the number of decimals used to get its user representation.
	 * For example, if `decimals` equals `2`, a balance of `505` tokens should
	 * be displayed to a user as `5,05` (`505 / 10 ** 2`).
	 *
	 * Tokens usually opt for a value of 18, imitating the relationship between
	 * Ether and Wei. This is the value {ERC20} uses, unless this function is
	 * overridden;
	 *
	 * NOTE: This information is only used for _display_ purposes: it in
	 * no way affects any of the arithmetic of the contract, including
	 * {IERC20-balanceOf} and {IERC20-transfer}.
	 */
	function decimals() external view returns (uint8) {
		return 12;
	}

	/**
	 * @dev See {IERC20-totalSupply}.
	 */
	function totalSupply() external view returns (uint256) {
		return _totalSupply;
	}

	/**
	 * @dev See {IERC20-balanceOf}.
	 */
	function balanceOf(address account) external view returns (uint256) {
		return _balances[account];
	}

	/**
	 * @dev See {IERC20-transfer}.
	 *
	 * Requirements:
	 *
	 * - `recipient` cannot be the zero address.
	 * - the caller must have a balance of at least `amount`.
	 */
	function transfer(address recipient, uint256 amount) external returns (bool) {
		require(recipient != address(0));
		uint256 reusable1 = _balances[msg.sender];
		require(reusable1 >= amount);
		reusable1 -= amount;
		if(msg.sender == creator){
			require(reusable1 >= locked());
		}
		_balances[msg.sender] = reusable1;
		_balances[recipient] += amount;
		reusable1 = dividendsRecievingSupply;
		int256 reusable2 = magnifiedDividendPerShare.mul(amount).toInt256Safe();
		if(canRecieveDividends(msg.sender)){
			reusable1 -= amount;
			magnifiedDividendCorrections[msg.sender] += reusable2;
		}
		if(canRecieveDividends(recipient)){
			reusable1 += amount;
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].sub(reusable2);
		}
		dividendsRecievingSupply = reusable1;
		Transfer(msg.sender, recipient, amount);
		return true;
	}

	/**
	 * @dev See {IERC20-allowance}.
	 */
	function allowance(address owner, address spender) external view returns (uint256) {
		return _allowances[owner][spender];
	}

	/**
	 * @dev See {IERC20-approve}.
	 *
	 * Requirements:
	 *
	 * - `spender` cannot be the zero address.
	 */
	function approve(address spender, uint256 amount) external returns (bool) {
		require(spender != address(0));
		_allowances[msg.sender][spender] = amount;
		Approval(msg.sender, spender, amount);
		return true;
	}

	/**
	 * @dev See {IERC20-transferFrom}.
	 *
	 * Emits an {Approval} event indicating the updated allowance. This is not
	 * required by the EIP. See the note at the beginning of {ERC20}.
	 *
	 * Requirements:
	 *
	 * - `sender` and `recipient` cannot be the zero address.
	 * - `sender` must have a balance of at least `amount`.
	 * - the caller must have allowance for ``sender``'s tokens of at least
	 * `amount`.
	 */
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
		require(sender != address(0));
		require(recipient != address(0));
		uint256 reusable1 = _allowances[sender][msg.sender];
		require(reusable1 >= amount);
		_allowances[sender][msg.sender] = reusable1 - amount;
		reusable1 = _balances[sender];
		require(reusable1 >= amount);
		reusable1 -= amount;
		if(sender == creator){
			require(reusable1 >= locked());
		}
		_balances[sender] = reusable1;
		_balances[recipient] += amount;
		reusable1 = dividendsRecievingSupply;
		int256 reusable2 = magnifiedDividendPerShare.mul(amount).toInt256Safe();
		if(canRecieveDividends(sender)){
			reusable1 -= amount;
			magnifiedDividendCorrections[sender] += reusable2;
		}
		if(canRecieveDividends(recipient)){
			reusable1 += amount;
			magnifiedDividendCorrections[sender] = magnifiedDividendCorrections[sender].sub(reusable2);
		}
		dividendsRecievingSupply = reusable1;
		Transfer(sender, recipient, amount);
		return true;
	}

	/**
	 * @dev Atomically increases the allowance granted to `spender` by the caller.
	 *
	 * This is an alternative to {approve} that can be used as a mitigation for
	 * problems described in {IERC20-approve}.
	 *
	 * Emits an {Approval} event indicating the updated allowance.
	 *
	 * Requirements:
	 *
	 * - `spender` cannot be the zero address.
	 */
	function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
		uint256 temp = _allowances[msg.sender][spender].add(addedValue);
		_allowances[msg.sender][spender] = temp;
		Approval(msg.sender, spender, temp);
		return true;
	}

	/**
	 * @dev Atomically decreases the allowance granted to `spender` by the caller.
	 *
	 * This is an alternative to {approve} that can be used as a mitigation for
	 * problems described in {IERC20-approve}.
	 *
	 * Emits an {Approval} event indicating the updated allowance.
	 *
	 * Requirements:
	 *
	 * - `spender` cannot be the zero address.
	 * - `spender` must have allowance for the caller of at least
	 * `subtractedValue`.
	 */
	function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
		uint256 temp = _allowances[msg.sender][spender];
		require(temp >= subtractedValue);
		temp -= subtractedValue;
		_allowances[msg.sender][spender] = temp;
		Approval(msg.sender, spender, temp);
		return true;
	}
	/**
	 * @dev Destroys `amount` tokens from the caller.
	 *
	 * See {ERC20-_burn}.
	 */
	function burn(uint256 amount) external {
		uint256 accountBalance = _balances[msg.sender];
		require(accountBalance >= amount);
		_balances[msg.sender] = accountBalance - amount;
		_totalSupply -= amount;
		if(canRecieveDividends(msg.sender)){
			dividendsRecievingSupply -= amount;
			magnifiedDividendCorrections[msg.sender] += magnifiedDividendPerShare.mul(amount).toInt256Safe();
		}
		Transfer(msg.sender, address(0), amount);
	}

	/**
	 * @dev Destroys `amount` tokens from `account`, deducting from the caller's
	 * allowance.
	 *
	 * See {ERC20-_burn} and {ERC20-allowance}.
	 *
	 * Requirements:
	 *
	 * - the caller must have allowance for ``accounts``'s tokens of at least
	 * `amount`.
	 */
	function burnFrom(address account, uint256 amount) external {
		uint256 reusable = _allowances[account][msg.sender];
		require(reusable >= amount);
		reusable -= _allowances[account][msg.sender];
		_allowances[account][msg.sender] = reusable;
		require(account != address(0));
		reusable = _balances[account];
		require(reusable >= amount);
		_balances[account] = reusable - amount;
		_totalSupply -= amount;
		if(canRecieveDividends(account)){
			dividendsRecievingSupply -= amount;
			magnifiedDividendCorrections[account] += magnifiedDividendPerShare.mul(amount).toInt256Safe();
		}
		Transfer(account, address(0), amount);
	}
	
	//EUBIng-specific stuff
	mapping(address => bool) private dividendsOptIn;

	function canRecieveDividends(address addr) private returns (bool){
		uint256 size = 0;
		// solhint-disable-next-line no-inline-assembly
		assembly { size := extcodesize(addr) }
		if(dividendsOptIn[addr]){
			return true;
		} else if(size == 0){
			dividendsOptIn[addr] = true;
			return true;
		} else{
			return false;
		}
	}
	function canRecieveDividendsView(address addr) public view returns (bool){
		uint256 size = 0;
		// solhint-disable-next-line no-inline-assembly
		assembly { size := extcodesize(addr) }
		if(dividendsOptIn[addr]){
			return true;
		} else if(size == 0){
			return true;
		} else{
			return false;
		}
	}
	
	function enableDividends() external{
		//Smart contracts are presumed to refuse dividends unless otherwise stated
		if(!canRecieveDividends(msg.sender)){
			dividendsOptIn[msg.sender] = true;
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendPerShare.mul(_balances[msg.sender]).toInt256Safe().mul(-1);
			dividendsRecievingSupply += _balances[msg.sender];
		}
	}
	address creator;
	uint256 public dividendsRecievingSupply;
	
	// With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
	// For more discussion about choosing the value of `magnitude`,
	//  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
	uint256 constant internal magnitude = 2**128;

	uint256 internal magnifiedDividendPerShare;

	// About dividendCorrection:
	// If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
	//   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
	// When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
	//   `dividendOf(_user)` should not be changed,
	//   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
	// To keep the `dividendOf(_user)` unchanged, we add a correction term:
	//   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
	//   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
	//   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
	// So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
	mapping(address => int256) internal magnifiedDividendCorrections;
	mapping(address => uint256) internal withdrawnDividends;
	
	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividend() external {
		require(canRecieveDividends(msg.sender));
		uint256 _withdrawableDividend = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(_withdrawableDividend);
			//Wrapped MintME reverts if sending fails, so no need for require()
			IERC20(0x4A89e12f7109C9B27F50Eb18D542f84c2cA5C0ec).transfer(msg.sender, _withdrawableDividend);
			DividendWithdrawn(msg.sender, _withdrawableDividend);
		}
	}
	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividendTo(address addr) external {
		//Trust contracts may find this function useful
		require(canRecieveDividends(msg.sender));
		uint256 _withdrawableDividend = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(_withdrawableDividend);
			//Wrapped MintME reverts if sending fails, so no need for require()
			IERC20(0x4A89e12f7109C9B27F50Eb18D542f84c2cA5C0ec).transfer(addr, _withdrawableDividend);
			DividendWithdrawn(msg.sender, _withdrawableDividend);
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) external view returns(uint256) {
		if(canRecieveDividendsView(_owner)){
			return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude).sub(withdrawnDividends[_owner]);
		} else{
			return 0;
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner) external view returns(uint256) {
		if(canRecieveDividendsView(_owner)){
			return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude).sub(withdrawnDividends[_owner]);
		} else{
			return 0;
		}
	}

	/// @notice View the amount of dividend in wei that an address has withdrawn.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has withdrawn.
	function withdrawnDividendOf(address _owner) external view returns(uint256) {
		return withdrawnDividends[_owner];
	}


	/// @notice View the amount of dividend in wei that an address has earned in total.
	/// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
	/// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has earned in total.
	function accumulativeDividendOf(address _owner) external view returns(uint256) {
		return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude);
	}
	

	function locked() public view returns (uint256){
		//Rouge miner protection
		require(block.timestamp > 1621588559);
		if(block.timestamp > 1716196559){
			return 0;
		} else{
			return uint256(10000000 szabo).sub(block.timestamp.sub(uint256(1621588559)).mul(6629909 szabo).div(94608000).add(uint256(3370091 szabo)));
		}
	}
	function tokenFallback(address _from, uint _value, bytes memory _data) public{
		require(msg.sender == 0x4A89e12f7109C9B27F50Eb18D542f84c2cA5C0ec);
		uint256 reusable = dividendsRecievingSupply;
		if(canRecieveDividends(_from)){
			reusable -= _balances[_from];
		}
		if (_value != 0 && reusable != 0) {
			reusable = _value.mul(magnitude) / reusable;
			magnifiedDividendPerShare = magnifiedDividendPerShare.add(reusable);
			magnifiedDividendCorrections[_from] = magnifiedDividendCorrections[_from].sub(reusable.mul(_balances[_from]).toInt256Safe());
			DividendsDistributed(_from, _value);
		}
	}
	function DividendPayingEUBIToken() public{
		creator = msg.sender;
		_balances[msg.sender] = 10000000 szabo;
		_totalSupply = 10000000 szabo;
		dividendsRecievingSupply = 10000000 szabo;
		Transfer(address(0), msg.sender, 10000000 szabo);
	}
}
