
// File: contracts/IERC20.sol

//SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.4;

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
	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowances;

	uint256 private _totalSupply;

	string private _name;
	string private _symbol;

	/**
	 * @dev Returns the name of the token.
	 */
	function name() external pure override returns (string memory) {
		return "EUBIng2";
	}

	/**
	 * @dev Returns the symbol of the token, usually a shorter version of the
	 * name.
	 */
	function symbol() external pure override returns (string memory) {
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
	function decimals() external pure override returns (uint8) {
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
		uint256 senderBalance = _balances[msg.sender];
		require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
		senderBalance -= amount;
		if(msg.sender == creator){
			require(senderBalance >= locked(), "EUBIUnlocker: not unlocked");
		}
		_balances[msg.sender] = senderBalance;
		_balances[recipient] += (amount);
		uint256 dividendsRecievingSupply1 = dividendsRecievingSupply;
		if(canRecieveDividends(msg.sender)){
			dividendsRecievingSupply1 -= amount;
			magnifiedDividendCorrections[msg.sender] += int256(magnifiedDividendPerShare * amount);
		}
		if(canRecieveDividends(recipient)){
			dividendsRecievingSupply1 += amount;
			magnifiedDividendCorrections[recipient] -= int256(magnifiedDividendPerShare * amount);
		}
		dividendsRecievingSupply = dividendsRecievingSupply1;
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
		uint256 senderBalance = _balances[sender];
		require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
		senderBalance -= amount;
		if(sender == creator){
			require(senderBalance >= locked(), "EUBIUnlocker: not unlocked");
		}
		_balances[sender] = senderBalance;
		_balances[recipient] += (amount);
		uint256 dividendsRecievingSupply1 = dividendsRecievingSupply;
		if(canRecieveDividends(sender)){
			dividendsRecievingSupply1 -= amount;
			magnifiedDividendCorrections[sender] += int256(magnifiedDividendPerShare * amount);
		}
		if(canRecieveDividends(recipient)){
			dividendsRecievingSupply1 += amount;
			magnifiedDividendCorrections[recipient] -= int256(magnifiedDividendPerShare * amount);
		}
		dividendsRecievingSupply = dividendsRecievingSupply1;
		emit Transfer(sender, recipient, amount);
		uint256 currentAllowance = _allowances[sender][msg.sender];
		require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
		unchecked {
			_allowances[sender][msg.sender] = currentAllowance - amount;
		}
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
		uint256 temp = _allowances[msg.sender][spender];
		temp += addedValue;
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
		unchecked {
			temp -= subtractedValue;
		}
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
		unchecked {
			_balances[msg.sender] = accountBalance - amount;
		}
		_totalSupply -= amount;
		if(canRecieveDividends(msg.sender)){
			dividendsRecievingSupply += amount;
			magnifiedDividendCorrections[msg.sender] -= int256(magnifiedDividendPerShare * amount);
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
		uint256 temp = _allowances[account][msg.sender];
		require(temp >= amount, "ERC20: burn amount exceeds allowance");
		unchecked {
			temp -= _allowances[account][msg.sender];
		}
		_allowances[account][msg.sender] = temp;
		emit Approval(account, msg.sender, temp);
		require(account != address(0), "ERC20: burn from the zero address");
		uint256 accountBalance = _balances[account];
		require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
		unchecked {
			_balances[account] = accountBalance - amount;
		}
		_totalSupply -= amount;
		if(canRecieveDividends(account)){
			dividendsRecievingSupply += amount;
			magnifiedDividendCorrections[account] -= int256(magnifiedDividendPerShare * amount);
		}
		emit Transfer(account, address(0), amount);
	}
	
	//EUBIng-specific stuff
	mapping(address => bool) private dividendsOptIn;
	mapping(address => uint256) private approvedDividends;
	
	function canRecieveDividends(address addr) public view returns (bool){
		uint256 size = 0;
		// solhint-disable-next-line no-inline-assembly
		assembly { size := extcodesize(addr) }
		return size == 0 || dividendsOptIn[addr];
	}
	
	function enableDividends() external{
		//Smart contracts are presumed to refuse dividends unless otherwise stated
		if(!canRecieveDividends(msg.sender)){
			dividendsOptIn[msg.sender] = true;
			magnifiedDividendCorrections[msg.sender] = 0 - int256(magnifiedDividendPerShare * _balances[msg.sender]);
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
		uint256 effectiveSupply = dividendsRecievingSupply - _balances[msg.sender];
		require(effectiveSupply > 0);
		if (amount > 0) {
			uint256 correction = (amount * magnitude) / effectiveSupply;
			magnifiedDividendPerShare += correction;
			magnifiedDividendCorrections[msg.sender] = magnifiedDividendCorrections[msg.sender] - int256(correction * _balances[msg.sender]);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transferFrom(msg.sender, address(this), amount), "EUBIng2: can't transfer USDC!");
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
		reused = (uint256(int256(magnifiedDividendPerShare * _balances[addr]) + magnifiedDividendCorrections[addr]) / magnitude) - withdrawnDividends[addr];
		if (reused > 0) {
			withdrawnDividends[msg.sender] += reused;
			emit DividendWithdrawn(msg.sender, reused);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transfer(msg.sender, reused), "EUBIng2: can't transfer USDC");
		}
	}
	/// @notice Withdraws the ether distributed to the sender.
	/// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
	function withdrawDividend() external override {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 _withdrawableDividend = (uint256(int256(magnifiedDividendPerShare * _balances[msg.sender]) + magnifiedDividendCorrections[msg.sender]) / magnitude) - withdrawnDividends[msg.sender];
		if (_withdrawableDividend > 0) {
			withdrawnDividends[msg.sender] += _withdrawableDividend;
			emit DividendWithdrawn(msg.sender, _withdrawableDividend);
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.transfer(msg.sender, _withdrawableDividend), "EUBIng2: can't transfer USDC");
		}
	}
	/// withdraw by granting spending approval instead of transferring
	function withdrawDividendSlim() external {
		require(canRecieveDividends(msg.sender), "EUBIng2: dividends disabled");
		uint256 reusable = (uint256(int256(magnifiedDividendPerShare * _balances[msg.sender]) + magnifiedDividendCorrections[msg.sender]) / magnitude) - withdrawnDividends[msg.sender];
		if (reusable > 0) {
			withdrawnDividends[msg.sender] += reusable;
			emit DividendWithdrawn(msg.sender, reusable);
			reusable += approvedDividends[msg.sender];
			IERC20 just = IERC20(0x834295921A488D9d42b4b3021ED1a3C39fB0f03e);
			require(just.approve(msg.sender, reusable), "EUBIng2: can't transfer USDC");
			approvedDividends[msg.sender] = reusable;
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function dividendOf(address _owner) external override view returns(uint256) {
		if(canRecieveDividends(_owner)){
			return (uint256(int256(magnifiedDividendPerShare * _balances[_owner]) + magnifiedDividendCorrections[_owner]) / magnitude) - withdrawnDividends[_owner];
		} else{
			return 0;
		}
	}

	/// @notice View the amount of dividend in wei that an address can withdraw.
	/// @param _owner The address of a token holder.
	/// @return The amount of dividend in wei that `_owner` can withdraw.
	function withdrawableDividendOf(address _owner) external override view returns(uint256) {
		if(canRecieveDividends(_owner)){
			return (uint256(int256(magnifiedDividendPerShare * _balances[_owner]) + magnifiedDividendCorrections[_owner]) / magnitude) - withdrawnDividends[_owner];
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
		return uint256(int256(magnifiedDividendPerShare * _balances[_owner]) + magnifiedDividendCorrections[_owner]) / magnitude;
	}
	
	bytes32 public DOMAIN_SEPARATOR;
	function unlocked() public view returns (uint256){
		//Rouge miner protection
		require(block.timestamp > 1621588559, "EUBIUnlocker: bad timestamp");
		if(block.timestamp > 1716196559){
			return 10000000*1e12;
		} else{
			return (((block.timestamp - 1621588559) * 6629909*1e12) / 94608000) + 3370091*1e12;
		}
	}
	function locked() public view returns (uint256){
		return 10000000*1e12 - unlocked();
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
	constructor(){
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
