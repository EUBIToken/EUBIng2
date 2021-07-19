# Why am I still reluctant to deploy EUBIng?

I recently learned about front-running attacks, and found a bug that allows miners to receive dividends on EUBIng tokens **WITHOUT** actually "investing" in EUBIng. This affects all dividends-paying tokens that get listed on DeFi exchanges, not just EUBIng. The way this attack work is that miners get to decide the order of the transactions they put in a block. This allows a miner to confirm a transaction of them buying EUBIng from MintyDEFI before the transaction where we make the profit share payment, and selling EUBIng to MintyDEFI afterward. Since the miner brought and sold EUBIng in the same block, then they haven't technically "invested" in EUBIng tokens. No smart contract audits can stop this, since this is the fundamental nature of blockchains.

## Possible workarounds
1. do nothing
2. use OpenZeppelin's ERC20Snapshot to require a minimum hold of 7 days before the profit share. too complicated and requires creating a new smart contract for each profit share.
3. restrict EUBIng transfers to smart contracts for 7 days after a profit share
4. not allowing smart contracts to interact with EUBIng at all
