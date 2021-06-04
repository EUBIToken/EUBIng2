
// File: contracts/IERC20.sol

//SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.6.12;

library SafeMath {
	function toInt256Safe(uint256 a) public pure returns (int256) {
		int256 b = int256(a);
		assert(b >= 0);
		return b;
	}
	function mul(int256 a, int256 b) public pure returns (int256) {
		// Prevent overflow when multiplying INT256_MIN with -1
		// https://github.com/RequestNetwork/requestNetwork/issues/43
		assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
		int256 c = a * b;
		assert((b == 0) || (c / b == a));
		return c;
	}
	function div(int256 a, int256 b) public pure returns (int256) {
		// Prevent overflow when dividing INT256_MIN by -1
		// https://github.com/RequestNetwork/requestNetwork/issues/43
		assert(!(a == - 2**255 && b == -1) && (b > 0));
		return a / b;
	}
	function sub(int256 a, int256 b) public pure returns (int256) {
		int256 c = a - b;
		assert((b >= 0 && c <= a) || (b < 0 && c > a));
		return c;
	}
	function add(int256 a, int256 b) public pure returns (int256) {
		int256 c = a + b;
		assert((b >= 0 && c >= a) || (b < 0 && c < a));
		return c;
	}
	function toUint256Safe(int256 a) public pure returns (uint256) {
		assert(a >= 0);
		return uint256(a);
	}
	
	/**
	* @dev Multiplies two numbers, throws on overflow.
	*/
	function mul(uint256 a, uint256 b) public pure returns (uint256) {
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
	function div(uint256 a, uint256 b) public pure returns (uint256) {
		assert(b > 0);
		uint256 c = a / b;
		return c;
	}
	
	/**
	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	*/
	function sub(uint256 a, uint256 b) public pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}
	
	/**
	* @dev Adds two numbers, throws on overflow.
	*/
	function add(uint256 a, uint256 b) public pure returns (uint256) {
		uint256 c = a + b;
		assert(c >= a);
		return c;
	}
	
	//EUBIng SafeMath2 extension
	function add(uint256 a, int256 b) public pure returns (uint256) {
		if(b > 0){
			return add(a, uint256(b));
		} else{
			assert(b != int256(uint256(1) << 255));
			return sub(a, uint256(0 - b));
		}
	}
	function sub(uint256 a, int256 b) public pure returns (uint256) {
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
interface IERC20 {
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
interface IERC20Metadata is IERC20 {
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

	/// @notice Distributes ether to token holders as dividends.
	/// @dev SHOULD distribute the paid ether to token holders as dividends.
	///  SHOULD NOT directly transfer ether to token holders in this function.
	///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
	function distributeDividends(uint256 amount) external;

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
contract DividendPayingEUBIToken is IERC20, IERC20Metadata, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
	using SafeMath for uint256;
	using SafeMath for int256;
	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowances;

	uint256 private _totalSupply;

	string private _name;
	string private _symbol;

	/**
	 * @dev Returns the name of the token.
	 */
	function name() external view override returns (string memory) {
		return "EUBIng2";
	}

	/**
	 * @dev Returns the symbol of the token, usually a shorter version of the
	 * name.
	 */
	function symbol() external view override returns (string memory) {
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
	function decimals() external view override returns (uint8) {
		return 12;
	}

	/**
	 * @dev See {IERC20-totalSupply}.
	 */
	function totalSupply() external view override returns (uint256) {
		return _totalSupply;
	}

	/**
	 * @dev See {IERC20-balanceOf}.
	 */
	function balanceOf(address account) external view override returns (uint256) {
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
	function transfer(address recipient, uint256 amount) public override returns (bool) {
		require(recipient != address(0), "ERC20: transfer to the zero address");
		uint256 reusable1 = _balances[msg.sender];
		require(reusable1 >= amount, "ERC20: transfer amount exceeds balance");
		reusable1 -= amount;
		if(msg.sender == creator){
			require(reusable1 >= locked(), "EUBIUnlocker: not unlocked");
		}
		_balances[msg.sender] = reusable1;
		_balances[recipient] += amount;
		reusable1 = dividendsRecievingSupply;
		int256 reusable2 = magnifiedDividendPerShare.mul(amount).toInt256Safe();
		if(canRecieveDividends(msg.sender)){
			reusable1 = reusable1.sub(reusable2);
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].add(reusable2);
		}
		if(canRecieveDividends(recipient)){
			reusable1 = reusable1.add(reusable2);
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].sub(reusable2);
		}
		dividendsRecievingSupply = reusable1;
		emit Transfer(msg.sender, recipient, amount);
		return true;
	}

	/**
	 * @dev See {IERC20-allowance}.
	 */
	function allowance(address owner, address spender) external view override returns (uint256) {
		return _allowances[owner][spender];
	}

	/**
	 * @dev See {IERC20-approve}.
	 *
	 * Requirements:
	 *
	 * - `spender` cannot be the zero address.
	 */
	function approve(address spender, uint256 amount) external override returns (bool) {
		require(spender != address(0), "ERC20: approve to the zero address");
		_allowances[msg.sender][spender] = amount;
		emit Approval(msg.sender, spender, amount);
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
	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
		require(sender != address(0), "ERC20: transfer from the zero address");
		require(recipient != address(0), "ERC20: transfer to the zero address");
		uint256 reusable1 = _allowances[sender][msg.sender];
		require(reusable1 >= amount, "ERC20: transfer amount exceeds allowance");
		_allowances[sender][msg.sender] = reusable1 - amount;
		reusable1 = _balances[sender];
		require(reusable1 >= amount, "ERC20: transfer amount exceeds balance");
		reusable1 -= amount;
		if(sender == creator){
			require(reusable1 >= locked(), "EUBIUnlocker: not unlocked");
		}
		_balances[sender] = reusable1;
		_balances[recipient] += amount;
		reusable1 = dividendsRecievingSupply;
		int256 reusable2 = magnifiedDividendPerShare.mul(amount).toInt256Safe();
		if(canRecieveDividends(sender)){
			reusable1 = reusable1.sub(reusable2);
			magnifiedDividendCorrections[sender] = magnifiedDividendCorrections[sender].add(reusable2);
		}
		if(canRecieveDividends(recipient)){
			reusable1 = reusable1.add(reusable2);
			magnifiedDividendCorrections[sender] = magnifiedDividendCorrections[sender].sub(reusable2);
		}
		dividendsRecievingSupply = reusable1;
		emit Transfer(sender, recipient, amount);
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
		emit Approval(msg.sender, spender, temp);
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
		require(temp >= subtractedValue, "ERC20: decreased allowance below zero");
		temp -= subtractedValue;
		_allowances[msg.sender][spender] = temp;
		emit Approval(msg.sender, spender, temp);
		return true;
	}
	/**
	 * @dev Destroys `amount` tokens from the caller.
	 *
	 * See {ERC20-_burn}.
	 */
	function burn(uint256 amount) external {
		uint256 accountBalance = _balances[msg.sender];
		require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
		_balances[msg.sender] = accountBalance - amount;
		_totalSupply = _totalSupply.sub(amount);
		if(canRecieveDividends(msg.sender)){
			dividendsRecievingSupply = dividendsRecievingSupply.sub(amount);
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].add(magnifiedDividendPerShare.mul(amount).toInt256Safe());
		}
		emit Transfer(msg.sender, address(0), amount);
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
		require(reusable >= amount, "ERC20: burn amount exceeds allowance");
		reusable -= _allowances[account][msg.sender];
		_allowances[account][msg.sender] = reusable;
		require(account != address(0), "ERC20: burn from the zero address");
		reusable = _balances[account];
		require(reusable >= amount, "ERC20: burn amount exceeds balance");
		_balances[account] = reusable - amount;
		_totalSupply = _totalSupply.sub(amount);
		if(canRecieveDividends(account)){
			dividendsRecievingSupply = dividendsRecievingSupply.sub(amount);
			magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account].add(magnifiedDividendPerShare.mul(amount).toInt256Safe());
		}
		emit Transfer(account, address(0), amount);
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
			dividendsRecievingSupply = dividendsRecievingSupply.add(_balances[msg.sender]);
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
		/// @dev Distributes dividends whenever ether is paid to this contract.

	/// @notice Distributes ether to token holders as dividends.
	/// @dev It reverts if the total supply of tokens is 0.
	/// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
	/// About undistributed ether:
	///   In each distribution, there is a small amount of ether not distributed,
	///	 the magnified amount of which is
	///	 `(msg.value * magnitude) % totalSupply()`.
	///   With a well-chosen `magnitude`, the amount of undistributed ether
	///	 (de-magnified) in a distribution can be less than 1 wei.
	///   We can actually keep track of the undistributed ether in a distribution
	///	 and try to distribute it in the next distribution,
	///	 but keeping track of such data on-chain costs much more than
	///	 the saved ether, so we don't do that.
	function distributeDividends(uint256 amount) external override {
		uint256 reusable = dividendsRecievingSupply.sub(_balances[msg.sender]);
		if (amount != 0 && reusable != 0) {
			reusable = amount.mul(magnitude) / reusable;
			magnifiedDividendPerShare = magnifiedDividendPerShare.add(reusable);
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].sub(reusable.mul(_balances[msg.sender]).toInt256Safe());
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transferFrom(msg.sender, address(this), amount), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendsDistributed(msg.sender, amount);
		}
	}
	
	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividendFor(address addr) external {
		uint256 reused = 0;
		// solhint-disable-next-line no-inline-assembly
		assembly { reused := extcodesize(addr) }
		require(reused == 0, "EUBIng2: dividends disabled");
		reused = magnifiedDividendPerShare.mul(_balances[addr]).add(magnifiedDividendCorrections[addr]).div(magnitude).sub(withdrawnDividends[addr]);
		if (reused > 0) {
			withdrawnDividends[addr] = withdrawnDividends[addr].add(reused);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transfer(addr, reused), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendWithdrawn(addr, reused);
		}
	}
	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividend() external override {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 _withdrawableDividend = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(_withdrawableDividend);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transfer(msg.sender, _withdrawableDividend), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendWithdrawn(msg.sender, _withdrawableDividend);
		}
	}
	/// used by trusts to save gas when transferring dividends to a beneficiary
	function withdrawDividendTo(address to) external {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 _withdrawableDividend = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(_withdrawableDividend);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transfer(to, _withdrawableDividend), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendWithdrawn(msg.sender, _withdrawableDividend);
		}
	}
	/// withdraw by granting spending approval instead of transferring
	function withdrawDividendSlim() external {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 reusable = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (reusable > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(reusable);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.approve(msg.sender, just.allowance(address(this), msg.sender).add(reusable)), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendWithdrawn(msg.sender, reusable);
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) external override view returns(uint256) {
		if(canRecieveDividendsView(_owner)){
			return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude).sub(withdrawnDividends[_owner]);
		} else{
			return 0;
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner) external override view returns(uint256) {
		if(canRecieveDividendsView(_owner)){
			return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude).sub(withdrawnDividends[_owner]);
		} else{
			return 0;
		}
	}

	/// @notice View the amount of dividend in wei that an address has withdrawn.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has withdrawn.
	function withdrawnDividendOf(address _owner) external override view returns(uint256) {
		return withdrawnDividends[_owner];
	}


	/// @notice View the amount of dividend in wei that an address has earned in total.
	/// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
	/// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` has earned in total.
	function accumulativeDividendOf(address _owner) external override view returns(uint256) {
		return magnifiedDividendPerShare.mul(_balances[_owner]).add(magnifiedDividendCorrections[_owner]).div(magnitude);
	}
	
	bytes32 public DOMAIN_SEPARATOR;
	function unlocked() public view returns (uint256){
		//Rouge miner protection
		require(block.timestamp > 1621588559);
		if(block.timestamp > 1716196559){
			return 10000000*1e12;
		} else{
			return block.timestamp.sub(uint256(1621588559)).mul(6629909*1e12).div(94608000).add(uint256(3370091*1e12));
		}
	}
	function locked() public view returns (uint256){
		return uint256(10000000*1e12).sub(unlocked());
	}
	mapping(address => uint) public nonces;
	//Used by UniswapV2
	function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
		require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
		bytes32 digest = keccak256(
			abi.encodePacked(
				'\x19\x01',
				DOMAIN_SEPARATOR,
				keccak256(abi.encode(0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9, owner, spender, value, nonces[owner]++, deadline))
			)
		);
		address recoveredAddress = ecrecover(digest, v, r, s);
		require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
		_allowances[owner][spender] = value;
		emit Approval(owner, spender, value);
	}
	constructor() public{
		creator = msg.sender;
		uint chainId;
		assembly {
			chainId := chainid()
		}
		DOMAIN_SEPARATOR = keccak256(
			abi.encode(
				keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
				keccak256(bytes(_name)),
				keccak256(bytes('1')),
				chainId,
				address(this)
			)
		);
		_balances[msg.sender] = 10000000*1e12;
		_totalSupply = 10000000*1e12;
		dividendsRecievingSupply = 10000000*1e12;
		emit Transfer(address(0), msg.sender, 10000000*1e12);
	}
	
	//BEGIN TRONZ SHIELD
	uint256 public scalingFactor = 1; // used when decimals of TRC20 token is too large.
	uint256 public leafCount;
	uint256 constant INT64_MAX = 2 ** 63 - 1;
	bytes32 public latestRoot;
	mapping(bytes32 => bytes32) public nullifiers; // store nullifiers of spent commitments
	mapping(bytes32 => bytes32) public roots; // store history root
	mapping(uint256 => bytes32) public tree;
	mapping(bytes32 => bytes32) public noteCommitment;
	bytes32[33] frontier;
	bytes32[32] zeroes = [bytes32(0x0100000000000000000000000000000000000000000000000000000000000000), bytes32(0x817de36ab2d57feb077634bca77819c8e0bd298c04f6fed0e6a83cc1356ca155), bytes32(0xffe9fc03f18b176c998806439ff0bb8ad193afdb27b2ccbc88856916dd804e34), bytes32(0xd8283386ef2ef07ebdbb4383c12a739a953a4d6e0d6fb1139a4036d693bfbb6c), bytes32(0xe110de65c907b9dea4ae0bd83a4b0a51bea175646a64c12b4c9f931b2cb31b49), bytes32(0x912d82b2c2bca231f71efcf61737fbf0a08befa0416215aeef53e8bb6d23390a), bytes32(0x8ac9cf9c391e3fd42891d27238a81a8a5c1d3a72b1bcbea8cf44a58ce7389613), bytes32(0xd6c639ac24b46bd19341c91b13fdcab31581ddaf7f1411336a271f3d0aa52813), bytes32(0x7b99abdc3730991cc9274727d7d82d28cb794edbc7034b4f0053ff7c4b680444), bytes32(0x43ff5457f13b926b61df552d4e402ee6dc1463f99a535f9a713439264d5b616b), bytes32(0xba49b659fbd0b7334211ea6a9d9df185c757e70aa81da562fb912b84f49bce72), bytes32(0x4777c8776a3b1e69b73a62fa701fa4f7a6282d9aee2c7a6b82e7937d7081c23c), bytes32(0xec677114c27206f5debc1c1ed66f95e2b1885da5b7be3d736b1de98579473048), bytes32(0x1b77dac4d24fb7258c3c528704c59430b630718bec486421837021cf75dab651), bytes32(0xbd74b25aacb92378a871bf27d225cfc26baca344a1ea35fdd94510f3d157082c), bytes32(0xd6acdedf95f608e09fa53fb43dcd0990475726c5131210c9e5caeab97f0e642f), bytes32(0x1ea6675f9551eeb9dfaaa9247bc9858270d3d3a4c5afa7177a984d5ed1be2451), bytes32(0x6edb16d01907b759977d7650dad7e3ec049af1a3d875380b697c862c9ec5d51c), bytes32(0xcd1c8dbf6e3acc7a80439bc4962cf25b9dce7c896f3a5bd70803fc5a0e33cf00), bytes32(0x6aca8448d8263e547d5ff2950e2ed3839e998d31cbc6ac9fd57bc6002b159216), bytes32(0x8d5fa43e5a10d11605ac7430ba1f5d81fb1b68d29a640405767749e841527673), bytes32(0x08eeab0c13abd6069e6310197bf80f9c1ea6de78fd19cbae24d4a520e6cf3023), bytes32(0x0769557bc682b1bf308646fd0b22e648e8b9e98f57e29f5af40f6edb833e2c49), bytes32(0x4c6937d78f42685f84b43ad3b7b00f81285662f85c6a68ef11d62ad1a3ee0850), bytes32(0xfee0e52802cb0c46b1eb4d376c62697f4759f6c8917fa352571202fd778fd712), bytes32(0x16d6252968971a83da8521d65382e61f0176646d771c91528e3276ee45383e4a), bytes32(0xd2e1642c9a462229289e5b0e3b7f9008e0301cbb93385ee0e21da2545073cb58), bytes32(0xa5122c08ff9c161d9ca6fc462073396c7d7d38e8ee48cdb3bea7e2230134ed6a), bytes32(0x28e7b841dcbc47cceb69d7cb8d94245fb7cb2ba3a7a6bc18f13f945f7dbd6e2a), bytes32(0xe1f34b034d4a3cd28557e2907ebf990c918f64ecb50a94f01d6fda5ca5c7ef72), bytes32(0x12935f14b676509b81eb49ef25f39269ed72309238b4c145803544b646dca62d), bytes32(0xb2eed031d4d6a4f02a097f80b54cc1541d4163c6b6f5971f88b6e41d35c53814)];
	address owner;

	event MintNewLeaf(uint256 position, bytes32 cm, bytes32 cv, bytes32 epk, bytes32[21] c);
	event TransferNewLeaf(uint256 position, bytes32 cm, bytes32 cv, bytes32 epk, bytes32[21] c);
	event BurnNewLeaf(uint256 position, bytes32 cm, bytes32 cv, bytes32 epk, bytes32[21] c);
	event TokenMint(address from, uint256 value);
	event TokenBurn(address to, uint256 value, bytes32[3] ciphertext);
	event NoteSpent(bytes32 nf);

	// output: cm, cv, epk, proof
	function mint(uint256 rawValue, bytes32[9] calldata output, bytes32[2] calldata bindingSignature, bytes32[21] calldata c) external {
		// transfer the trc20Token from the sender to this contract
		transfer(address(this), rawValue);

		require(noteCommitment[output[0]] == 0);
		uint64 value = rawValueToValue(rawValue);
		bytes32 signHash = sha256(abi.encodePacked(address(this), value, output, c));
		(bytes32[] memory ret) = verifyMintProof(output, bindingSignature, value, signHash, frontier, leafCount);
		uint256 result = uint256(ret[0]);
		require(result == 1);

		uint256 slot = uint256(ret[1]);
		uint256 nodeIndex = leafCount + 2 ** 32 - 1;
		tree[nodeIndex] = output[0];
		if (slot == 0) {
			frontier[0] = output[0];
		}
		for (uint256 i = 1; i < slot + 1; i++) {
			nodeIndex = (nodeIndex - 1) / 2;
			tree[nodeIndex] = ret[i + 1];
			if (i == slot) {
				frontier[slot] = tree[nodeIndex];
			}
		}
		latestRoot = ret[slot + 2];
		roots[latestRoot] = latestRoot;
		noteCommitment[output[0]] = output[0];
		leafCount ++;

		emit MintNewLeaf(leafCount - 1, output[0], output[1], output[2], c);
		emit TokenMint(msg.sender, rawValue);
	}
	//input: nf, anchor, cv, rk, proof
	//output: cm, cv, epk, proof
	function transfer(bytes32[10][] calldata input, bytes32[2][] calldata spendAuthoritySignature, bytes32[9][] calldata output, bytes32[2] calldata bindingSignature, bytes32[21][] calldata c) external {
		require(input.length == spendAuthoritySignature.length);
		require(output.length == c.length);

		for (uint256 i = 0; i < input.length; i++) {
			require(nullifiers[input[i][0]] == 0);
			require(roots[input[i][1]] != 0);
		}
		for (uint256 i = 0; i < output.length; i++) {
			require(noteCommitment[output[i][0]] == 0);
		}

		bytes32 signHash = sha256(abi.encodePacked(address(this), input, output, c));
		(bytes32[] memory ret) = verifyTransferProof(input, spendAuthoritySignature, output, bindingSignature, signHash, 0, frontier, leafCount);
		uint256 result = uint256(ret[0]);
		require(result == 1);

		uint256 offset = 1;
		//ret offset
		uint256 ru = output.length;
		for (uint256 i = 0; i < ru; i++) {
			uint256 slot = uint256(ret[offset++]);
			uint256 nodeIndex = leafCount + 2 ** 32 - 1;
			tree[nodeIndex] = output[i][0];
			if (slot == 0) {
				frontier[0] = output[i][0];
			}
			for (uint256 k = 1; k < slot + 1; k++) {
				nodeIndex = (nodeIndex - 1) / 2;
				tree[nodeIndex] = ret[offset++];
				if (k == slot) {
					frontier[slot] = tree[nodeIndex];
				}
			}
			leafCount++;
		}
		latestRoot = ret[offset];
		roots[latestRoot] = latestRoot;
		ru = input.length;
		for (uint256 i = 0; i < ru; i++) {
			bytes32 nf = input[i][0];
			nullifiers[nf] = nf;
			emit NoteSpent(nf);
		}
		ru = output.length;
		for (uint256 i = 0; i < ru; i++) {
			noteCommitment[output[i][0]] = output[i][0];
			emit TransferNewLeaf(leafCount - (output.length - i), output[i][0], output[i][1], output[i][2], c[i]);
		}
	}
	//input: nf, anchor, cv, rk, proof
	//output: cm, cv, epk, proof
	function burn(bytes32[10] calldata input, bytes32[2] calldata spendAuthoritySignature, uint256 rawValue, bytes32[2] calldata bindingSignature, address payTo, bytes32[3] calldata burnCipher, bytes32[9][] calldata output, bytes32[21][] calldata c) external {
		uint64 value = rawValueToValue(rawValue);
		bytes32 signHash = sha256(abi.encodePacked(address(this), input, output, c, payTo, value));

		bytes32 nf = input[0];
		bytes32 anchor = input[1];
		require(nullifiers[nf] == 0);
		require(roots[anchor] != 0);

		require(output.length <= 1);
		require(output.length == c.length);

		// bytes32 signHash = sha256(abi.encodePacked(address(this), input, payTo, value, output, c));
		if (output.length == 0) {
			(bool result) = verifyBurnProof(input, spendAuthoritySignature, value, bindingSignature, signHash);
			require(result);
		} else {
			transferInBurn(input, spendAuthoritySignature, value, bindingSignature, signHash, output, c);
		}

		nullifiers[nf] = nf;
		emit NoteSpent(nf);
		//Finally, transfer trc20Token from this contract to the nominated address
		_allowances[address(this)][msg.sender] = rawValue;
		transferFrom(address(this), payTo, rawValue);

		emit TokenBurn(payTo, rawValue, burnCipher);
	}

	function transferInBurn(bytes32[10] memory input, bytes32[2] memory spendAuthoritySignature, uint64 value, bytes32[2] memory bindingSignature, bytes32 signHash, bytes32[9][] memory output, bytes32[21][] memory c) private {
		bytes32 cm = output[0][0];
		require(noteCommitment[cm] == 0);
		bytes32[10][] memory inputs = new bytes32[10][](1);
		inputs[0] = input;
		bytes32[2][] memory spendAuthoritySignatures = new bytes32[2][](1);
		spendAuthoritySignatures[0] = spendAuthoritySignature;
		(bytes32[] memory ret) = verifyTransferProof(inputs, spendAuthoritySignatures, output, bindingSignature, signHash, value, frontier, leafCount);
		uint256 result = uint256(ret[0]);
		require(result == 1);

		uint256 slot = uint256(ret[1]);
		uint256 nodeIndex = leafCount + 2 ** 32 - 1;
		tree[nodeIndex] = cm;
		if (slot == 0) {
			frontier[0] = cm;
		}
		for (uint256 i = 1; i < slot + 1; i++) {
			nodeIndex = (nodeIndex - 1) / 2;
			tree[nodeIndex] = ret[i + 1];
			if (i == slot) {
				frontier[slot] = tree[nodeIndex];
			}
		}
		latestRoot = ret[slot + 2];
		roots[latestRoot] = latestRoot;
		noteCommitment[cm] = cm;
		leafCount ++;

		emit BurnNewLeaf(leafCount - 1, cm, output[0][1], output[0][2], c[0]);
	}

	//position: index of leafnode, start from 0
	function getPath(uint256 position) public view returns (bytes32, bytes32[32] memory) {
		require(position >= 0);
		require(position < leafCount);
		uint256 index = position + 2 ** 32 - 1;
		bytes32[32] memory path;
		uint32 level = ancestorLevel(position);
		bytes32 targetNodeValue = getTargetNodeValue(position, level);
		for (uint32 i = 0; i < 32; i++) {
			if (i == level) {
				path[31 - i] = targetNodeValue;
			} else {
				if (index % 2 == 0) {
					path[31 - i] = tree[index - 1];
				} else {
					path[31 - i] = tree[index + 1] == 0 ? zeroes[i] : tree[index + 1];
				}
			}
			index = (index - 1) / 2;
		}
		return (latestRoot, path);
	}

	function ancestorLevel(uint256 leafIndex) private view returns (uint32) {
		uint256 nodeIndex1 = leafIndex + 2 ** 32 - 1;
		uint256 nodeIndex2 = leafCount + 2 ** 32 - 2;
		uint32 level = 0;
		while (((nodeIndex1 - 1) / 2) != ((nodeIndex2 - 1) / 2)) {
			nodeIndex1 = (nodeIndex1 - 1) / 2;
			nodeIndex2 = (nodeIndex2 - 1) / 2;
			level = level + 1;
		}
		return level;
	}

	function getTargetNodeValue(uint256 leafIndex, uint32 level) private view returns (bytes32) {
		bytes32 left;
		bytes32 right;
		uint256 index = leafIndex + 2 ** 32 - 1;
		uint256 nodeIndex = leafCount + 2 ** 32 - 2;
		bytes32 nodeValue = tree[nodeIndex];
		if (level == 0) {
			if (index < nodeIndex) {
				return nodeValue;
			}
			if (index == nodeIndex) {
				if (index % 2 == 0) {
					return tree[index - 1];
				} else {
					return zeroes[0];
				}
			}
		}
		for (uint32 i = 0; i < level; i++) {
			if (nodeIndex % 2 == 0) {
				left = tree[nodeIndex - 1];
				right = nodeValue;
			} else {
				left = nodeValue;
				right = zeroes[i];
			}
			nodeValue = pedersenHash(i, left, right);
			nodeIndex = (nodeIndex - 1) / 2;
		}
		return nodeValue;
	}

	function rawValueToValue(uint256 rawValue) private pure returns (uint64) {
		require(rawValue > 0 && rawValue < INT64_MAX);
		return uint64(rawValue);
	}
}
