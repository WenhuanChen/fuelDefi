script;

use std::prelude::*;
use std::storage::cell::Cell;
use std::storage::collections::HashMap as Map;

abi LendingProtocol {
    fn deposit(amount: u64);
    fn withdraw(amount: u64) -> bool;
    fn borrow(amount: u64) -> bool;
    fn repay(amount: u64) -> bool;
    fn get_account_balance(user: address) -> u64;
    fn get_account_debt(user: address) -> u64;
}

contract;

storage {
    total_liquidity: Cell<u64>,
    user_balances: Map<address, u64>,
    user_debts: Map<address, u64>,
}

impl LendingProtocol for Contract {
    fn deposit(amount: u64) {
        let current_balance = self.user_balances.get(&caller()).unwrap_or_default();
        self.user_balances.insert(caller(), current_balance + amount);
        self.total_liquidity.set(self.total_liquidity.get() + amount);
    }

    fn withdraw(amount: u64) -> bool {
        let current_balance = self.user_balances.get(&caller()).unwrap_or_default();
        if current_balance >= amount {
            self.user_balances.insert(caller(), current_balance - amount);
            self.total_liquidity.set(self.total_liquidity.get() - amount);
            true
        } else {
            false
        }
    }

    fn borrow(amount: u64) -> bool {
        let liquidity = self.total_liquidity.get();
        if liquidity >= amount {
            let current_debt = self.user_debts.get(&caller()).unwrap_or_default();
            self.user_debts.insert(caller(), current_debt + amount);
            self.total_liquidity.set(liquidity - amount);
            true
        } else {
            false
        }
    }

    fn repay(amount: u64) -> bool {
        let current_debt = self.user_debts.get(&caller()).unwrap_or_default();
        if current_debt >= amount {
            self.user_debts.insert(caller(), current_debt - amount);
            self.total_liquidity.set(self.total_liquidity.get() + amount);
            true
        } else {}
