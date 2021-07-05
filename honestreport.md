# The honest auditing report for EUBI classic token, and other tokens deployed via MintME.com

Audited on 05/07/2021 by Jessie Lesbian

## HIGH SEVERITY vulnerabilities

SELFDESTRUCT/SUICIDE instructions are present in the EUBI Classic token contract. This is completely BS since token contracts are NEVER EVER supposed to self-destruct.

## MEDIUM SEVERITY vulnerabilities

Potentially unsafe use of DELEGATECALL, maybe this is a proxy contract, designed to make upgradable smart contracts?

Possible use of MintME-specific EVM instructions

Token release period is NOT enforced by the smart contract (no TIMESTAMP instructions found).

## Other suspicions

This is a closed-source token contract with upgradability. Do you guys trust a closed-source token contract? Closed-source token contracts are the first signs that a token is a scam. To make it worse, this token contract is upgradable. This means that it can be modified after deployment by MintME.com. Anyways, please don't get mad at EUB Insurance Limited for this, since this is MintME.com's fault.
