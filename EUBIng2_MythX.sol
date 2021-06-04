//DO NOT DEPLOY ON ANY BLOCKCHAINS!
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
	function distributeDividends() external payable;

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
	function transfer(address recipient, uint256 amount) external override returns (bool) {
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
	function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
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
			magnifiedDividendCorrections[msg.sender] = 0 - magnifiedDividendPerShare.mul(_balances[msg.sender]).toInt256Safe();
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
	function distributeDividends() external payable override {
		uint256 reusable = dividendsRecievingSupply.sub(_balances[msg.sender]);
		if (msg.value != 0 && reusable != 0) {
			reusable = msg.value.mul(magnitude) / reusable;
			magnifiedDividendPerShare = magnifiedDividendPerShare.add(reusable);
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender].sub(reusable.mul(_balances[msg.sender]).toInt256Safe());
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transferFrom(msg.sender, address(this), msg.value), "EUBIng2: can't transfer JUST Stablecoin");
			emit DividendsDistributed(msg.sender, msg.value);
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
			assert(payable(address(this)).balance >= reused);
			payable(addr).transfer(reused);
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
			assert(payable(address(this)).balance >= _withdrawableDividend);
			payable(msg.sender).transfer(_withdrawableDividend);
			emit DividendWithdrawn(msg.sender, _withdrawableDividend);
		}
	}
	/// used by trusts to save gas when transferring dividends to a beneficiary
	function withdrawDividendTo(address to) external {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 _withdrawableDividend = magnifiedDividendPerShare.mul(_balances[msg.sender]).add(magnifiedDividendCorrections[msg.sender]).div(magnitude).sub(withdrawnDividends[msg.sender]);
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] = withdrawnDividends[msg.sender].add(_withdrawableDividend);
			assert(payable(address(this)).balance >= _withdrawableDividend);
			payable(to).transfer(_withdrawableDividend);
			emit DividendWithdrawn(msg.sender, _withdrawableDividend);
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
	//HINT TO MythX
	function selftest2() external{
		if(dividendsRecievingSupply > _totalSupply){
			selfdestruct(payable(msg.sender));
		}
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
}
