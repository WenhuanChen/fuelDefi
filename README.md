# Introduction to Sway and DeFi Token Contract Example

## What is Sway?

Sway is a statically-typed, contract-oriented programming language designed specifically for the Fuel blockchain. Developed by Fuel Labs, it aims to facilitate the creation of high-performance smart contracts with safety and efficiency in mind. Sway is part of the larger Fuel ecosystem, which focuses on scalability and speed for decentralized applications.

## File Extension for Sway

Sway source code files use the `.sw` file extension. When developing with Sway, developers write and edit `.sw` files, which are then compiled into bytecode that can be deployed and executed on the Fuel blockchain.

## DeFi Token Contract Example in Sway

The following is a basic example of a DeFi token contract written in Sway. This contract includes functionalities such as initializing the token supply, transferring tokens between accounts, and querying account balances.

### Contract Features

- `init_supply`: This function initializes the total supply of tokens and assigns it to the contract deployer.
- `transfer`: This allows a user to transfer tokens from one account to another.
- `get_balance`: This function allows querying the token balance of a specific account.

### Sway Code Example

```sway
script;

use std::storage::cell::Cell;
use std::storage::collections::HashMap as Map;
use std::prelude::*;

abi Token {
    fn init_supply();
    fn transfer(to: address, amount: u64);
    fn get_balance(account: address) -> u64;
}

contract;

storage {
    total_supply: Cell<u64>,
    balances: Map<address, u64>,
}

impl Token for Contract {
    fn init_supply() {
        let initial_supply = 1000000; // Initial supply
        self.total_supply.set(initial_supply);
        self.balances.insert(caller(), initial_supply);
    }

    fn transfer(to: address, amount: u64) {
        let caller_balance = self.balances.get(&caller()).unwrap_or_default();
        assert!(caller_balance >= amount, "Insufficient balance.");

        let to_balance = self.balances.get(&to).unwrap_or_default();
        self.balances.insert(caller(), caller_balance - amount);
        self.balances.insert(to, to_balance + amount);
    }

    fn get_balance(account: address) -> u64 {
        self.balances.get(&account).unwrap_or_default()
    }
}
