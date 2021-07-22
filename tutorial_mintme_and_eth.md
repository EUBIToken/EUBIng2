# EUBIng tutorial for MintME and Ethereum version

## Quick navigation links

[Smart contract access](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#smart-contract-access)

[Token staking](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#token-staking)

[Unsafe dividends distribution](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#unsafe-dividends-distribution)

[Safe dividends distribution](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#safe-dividends-distribution)

[Dividend withdrawal](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#dividend-withdrawal)

[Token unstaking](https://github.com/EUBIToken/EUBIng2/blob/main/tutorial_mintme_and_eth.md#token-unstaking)

## Smart contract access

MintME: 0x33270088997751267fe218f8251fec52512a8689

Ethereum: not yet deployed!

[click here to get the ABI/JSON Interface](https://raw.githubusercontent.com/EUBIToken/EUBIng2/main/abi_ethereum.json)

Just copy and paste the address and ABI into your wallet's interact with contract menu

![image](https://user-images.githubusercontent.com/55774978/126618528-6f1b32a6-d859-452c-a48e-c0515c7ed739.png)

NOTE: the're a small bug when copying and pasting where the copy-pasted ABI/JSON Interface could end with ````{"mode":"full","isActive":false}````. Please trim off this part if you see it.

![image](https://user-images.githubusercontent.com/55774978/126616937-344afcd6-267b-4191-a910-b1a812e7edac.png)

## Token staking

EUBIng uses a proof-of-stake model to overcome frontrunning and issues with tokens held by smart contracts. You can only receive dividends on staked EUBIng tokens, and in order to stake tokens, send them to the smart contract address.

## Unsafe dividends distribution

Simply send the native cryptocurrency (Ethereum or MintME) to the smart contract

## Safe dividends distribution

Safe dividends distribution protects against front-running attacks by specifying the maximum number of staked EUBIng tokens in the transaction data. If more EUBIng tokens are staked than what is specified, then the transaction will be reverted.

![image](https://user-images.githubusercontent.com/55774978/126618629-b8ad0b53-00c8-4430-aa3b-c1bc8a6bf3e5.png)

### Step 1: get the current staked supply

![image](https://user-images.githubusercontent.com/55774978/126618738-fa5bbe10-7a6e-44db-8702-8b3c9c0b32e9.png)

### Step 2: write the transaction

![image](https://user-images.githubusercontent.com/55774978/126619268-a5f95b8f-467a-4b5e-aeed-144ad1c23665.png)

### Step 3: confirm the transaction

![image](https://user-images.githubusercontent.com/55774978/126619428-8b0a8e51-b9f5-4917-add6-d154d77bfcc5.png)

NOTE: Value should be the amount of MintME/Ethereum you are distributing as dividends, and MaxStakedTokens should be equal to or bigger than the current staked supply.

## Dividend withdrawal

### Step 1: write the transaction

![image](https://user-images.githubusercontent.com/55774978/126619569-b2ba3c20-61ce-49d1-bd94-7fb7929dbc87.png)

### Step 2: confirm the transaction

![image](https://user-images.githubusercontent.com/55774978/126619634-2308cd86-7b79-4574-9d00-7f4da49075f3.png)

## Token unstaking

### Step 1: write the transaction

![image](https://user-images.githubusercontent.com/55774978/126620356-a9142e20-e41f-4f9f-98b6-a66d200150f7.png)

### Step 2: confirm the transaction

![image](https://user-images.githubusercontent.com/55774978/126619634-2308cd86-7b79-4574-9d00-7f4da49075f3.png)
