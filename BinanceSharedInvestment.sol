//SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.0;

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
	function transferFrom(
		address sender,
		address recipient,
		uint256 amount
	) external returns (bool);

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
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
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
contract ERC20 is IERC20Metadata {
	mapping(address => uint256) private _balances;

	mapping(address => mapping(address => uint256)) private _allowances;

	uint256 private _totalSupply;

	string private _name;
	string private _symbol;

	/**
	 * @dev Sets the values for {name} and {symbol}.
	 *
	 * The default value of {decimals} is 18. To select a different value for
	 * {decimals} you should overload it.
	 *
	 * All two of these values are immutable: they can only be set once during
	 * construction.
	 */
	constructor(string memory name_, string memory symbol_) {
		_name = name_;
		_symbol = symbol_;
	}

	/**
	 * @dev Returns the name of the token.
	 */
	function name() external view virtual override returns (string memory) {
		return _name;
	}

	/**
	 * @dev Returns the symbol of the token, usually a shorter version of the
	 * name.
	 */
	function symbol() external view virtual override returns (string memory) {
		return _symbol;
	}

	/**
	 * @dev Returns the number of decimals used to get its user representation.
	 * For example, if `decimals` equals `2`, a balance of `505` tokens should
	 * be displayed to a user as `5.05` (`505 / 10 ** 2`).
	 *
	 * Tokens usually opt for a value of 18, imitating the relationship between
	 * Ether and Wei. This is the value {ERC20} uses, unless this function is
	 * overridden;
	 *
	 * NOTE: This information is only used for _display_ purposes: it in
	 * no way affects any of the arithmetic of the contract, including
	 * {IERC20-balanceOf} and {IERC20-transfer}.
	 */
	function decimals() external view virtual override returns (uint8) {
		return 18;
	}

	/**
	 * @dev See {IERC20-totalSupply}.
	 */
	function totalSupply() public view virtual override returns (uint256) {
		return _totalSupply;
	}

	/**
	 * @dev See {IERC20-balanceOf}.
	 */
	function balanceOf(address account) public view virtual override returns (uint256) {
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
	function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
		_transfer(msg.sender, recipient, amount);
		return true;
	}

	/**
	 * @dev See {IERC20-allowance}.
	 */
	function allowance(address owner, address spender) public view virtual override returns (uint256) {
		return _allowances[owner][spender];
	}

	/**
	 * @dev See {IERC20-approve}.
	 *
	 * Requirements:
	 *
	 * - `spender` cannot be the zero address.
	 */
	function approve(address spender, uint256 amount) external virtual override returns (bool) {
		_approve(msg.sender, spender, amount);
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
	function transferFrom(
		address sender,
		address recipient,
		uint256 amount
	) external virtual override returns (bool) {
		_transfer(sender, recipient, amount);

		uint256 currentAllowance = _allowances[sender][msg.sender];
		require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
		unchecked {
			_approve(sender, msg.sender, currentAllowance - amount);
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
	function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
		_approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
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
	function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
		uint256 currentAllowance = _allowances[msg.sender][spender];
		require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
		unchecked {
			_approve(msg.sender, spender, currentAllowance - subtractedValue);
		}

		return true;
	}

	/**
	 * @dev Moves `amount` of tokens from `sender` to `recipient`.
	 *
	 * This internal function is equivalent to {transfer}, and can be used to
	 * e.g. implement automatic token fees, slashing mechanisms, etc.
	 *
	 * Emits a {Transfer} event.
	 *
	 * Requirements:
	 *
	 * - `sender` cannot be the zero address.
	 * - `recipient` cannot be the zero address.
	 * - `sender` must have a balance of at least `amount`.
	 */
	function _transfer(
		address sender,
		address recipient,
		uint256 amount
	) internal virtual {
		require(sender != address(0), "ERC20: transfer from the zero address");
		require(recipient != address(0), "ERC20: transfer to the zero address");

		_beforeTokenTransfer(sender, recipient, amount);

		uint256 senderBalance = _balances[sender];
		require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
		unchecked {
			_balances[sender] = senderBalance - amount;
		}
		_balances[recipient] += amount;

		emit Transfer(sender, recipient, amount);

		_afterTokenTransfer(sender, recipient, amount);
	}

	/** @dev Creates `amount` tokens and assigns them to `account`, increasing
	 * the total supply.
	 *
	 * Emits a {Transfer} event with `from` set to the zero address.
	 *
	 * Requirements:
	 *
	 * - `account` cannot be the zero address.
	 */
	function _mint(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: mint to the zero address");

		_beforeTokenTransfer(address(0), account, amount);

		_totalSupply += amount;
		_balances[account] += amount;
		emit Transfer(address(0), account, amount);

		_afterTokenTransfer(address(0), account, amount);
	}

	/**
	 * @dev Destroys `amount` tokens from `account`, reducing the
	 * total supply.
	 *
	 * Emits a {Transfer} event with `to` set to the zero address.
	 *
	 * Requirements:
	 *
	 * - `account` cannot be the zero address.
	 * - `account` must have at least `amount` tokens.
	 */
	function _burn(address account, uint256 amount) internal virtual {
		require(account != address(0), "ERC20: burn from the zero address");

		_beforeTokenTransfer(account, address(0), amount);

		uint256 accountBalance = _balances[account];
		require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
		unchecked {
			_balances[account] = accountBalance - amount;
		}
		_totalSupply -= amount;

		emit Transfer(account, address(0), amount);

		_afterTokenTransfer(account, address(0), amount);
	}

	/**
	 * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
	 *
	 * This internal function is equivalent to `approve`, and can be used to
	 * e.g. set automatic allowances for certain subsystems, etc.
	 *
	 * Emits an {Approval} event.
	 *
	 * Requirements:
	 *
	 * - `owner` cannot be the zero address.
	 * - `spender` cannot be the zero address.
	 */
	function _approve(
		address owner,
		address spender,
		uint256 amount
	) internal virtual {
		require(owner != address(0), "ERC20: approve from the zero address");
		require(spender != address(0), "ERC20: approve to the zero address");

		_allowances[owner][spender] = amount;
		emit Approval(owner, spender, amount);
	}

	/**
	 * @dev Hook that is called before any transfer of tokens. This includes
	 * minting and burning.
	 *
	 * Calling conditions:
	 *
	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
	 * will be transferred to `to`.
	 * - when `from` is zero, `amount` tokens will be minted for `to`.
	 * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
	 * - `from` and `to` are never both zero.
	 *
	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
	 */
	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal virtual {}

	/**
	 * @dev Hook that is called after any transfer of tokens. This includes
	 * minting and burning.
	 *
	 * Calling conditions:
	 *
	 * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
	 * has been transferred to `to`.
	 * - when `from` is zero, `amount` tokens have been minted for `to`.
	 * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
	 * - `from` and `to` are never both zero.
	 *
	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
	 */
	function _afterTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal virtual {}
}
interface IFlashMintReceiver{
	function receiveFlashMint(uint256 amount, uint256 amount2, bytes memory data) external;
}
library signcaster{
	function toUint256(int256 value) internal pure returns (uint256) {
		require(value >= 0, "SafeCast: value must be positive");
		return uint256(value);
	}
	function toInt256(uint256 value) internal pure returns (int256) {
		// Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
		require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
		return int256(value);
	}
}
contract DividendsPayingFlashMintableEUBI2Token is ERC20{
	using signcaster for int256;
	using signcaster for uint256;
	constructor() ERC20("Dividends-Paying Flash-Mintable EUBI2 Token", "EUBI2"){
		
	}
	mapping(address => uint256) public burnedForDividends;
	mapping(address => int256) private _dividends_adjustments;
	uint256 private _magnified_dividends_per_share;
	uint256 constant private multiply = 2**128;
	receive() payable external{
		uint256 temp = totalSupply();
		require(temp != 0, "The're are no EUBI2 holders");
		_magnified_dividends_per_share += (msg.value * multiply) / temp;
	}
	function _beforeTokenTransfer(
		address from,
		address to,
		uint256 amount
	) internal override {
		int256 adjustment = (amount * _magnified_dividends_per_share).toInt256();
		if(from != address(0)){
			_dividends_adjustments[from] += adjustment;
		}
		if(to != address(0)){
			_dividends_adjustments[to] -= adjustment;
		}
	}
	
	//frequently misused by smart contracts
	function flashMint(address to, uint256 value1out, uint256 value2out, uint256 value1in, uint256 value2in, bytes memory data) external{
		require(value1in + value2in >= value1out + value2out, "flash mint input value is smaller than output value");
		_mint(to, value1out);
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transfer(to, value2out);
		IFlashMintReceiver(to).receiveFlashMint(value1out, value2out, data);
		_burn(to, value1in);
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transferFrom(to, address(this), value2in);
	}
	/**
	 * @dev Allow a user to deposit underlying tokens and mint the corresponding number of wrapped tokens.
	 */
	function depositFor(address account, uint256 amount) external {
		_mint(account, amount);
		//bEUBI uses reverts, so we don't need to check
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transferFrom(msg.sender, address(this), amount);
	}

	/**
	 * @dev Allow a user to burn a number of wrapped tokens and withdraw the corresponding number of underlying tokens.
	 */
	function withdrawTo(address account, uint256 amount) external {
		_burn(msg.sender, amount);
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transfer(account, amount);
		
	}
	/**
	 * @dev Allow a user to burn a number of wrapped tokens and withdraw the corresponding number of underlying tokens.
	 */
	function withdrawUsingApprovalTo(address from, address account, uint256 amount) external {
		uint256 approval = allowance(from, msg.sender);
		require(approval >= amount, "withdrawal amount exceeds allowance");
		unchecked{
			_approve(from, msg.sender, approval - amount);
		}
		_burn(from, amount);
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transfer(account, amount);
		
	}

	/**
	 * @dev Mint wrapped token to cover any underlyingTokens that would have been transfered by mistake. Internal
	 * function that can be exposed with access control if desired.
	 * 
	 * Also useful for saving gas when depositing on approval
	 */
	function recover(address account, uint256 amount1, uint256 amount2) external {
		require(IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).balanceOf(address(this)) - totalSupply() >= amount1 + amount2, "recover amount exceeds spare balance");
		_mint(account, amount1);
		IERC20(0x27fAAa5bD713DCd4258D5C49258FBef45314ae5D).transfer(account, amount2);
	}
	
	function pendingDividends(address addr) public view returns (uint256){
		return ((_magnified_dividends_per_share * balanceOf(addr)).toInt256() + _dividends_adjustments[addr]).toUint256() / multiply;
	}
	function withdrawDividendsTo(address payable addr, uint256 amount, bytes calldata data) external{
		uint256 calculatedPendingDividends = pendingDividends(msg.sender);
		require(calculatedPendingDividends >= amount, "Dividends withdrawal amount exceeds pending dividends balance");
		_dividends_adjustments[msg.sender] -= (multiply * amount).toInt256();
		(bool status, bytes memory ret) = addr.call{value: amount}(data);
		if(ret.length == 0){
			require(status, "Unable to send dividends to recipient address");
		} else{
			require(status, string(ret));
		}
	}
	
}
