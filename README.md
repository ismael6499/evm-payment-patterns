# 💸 Secure Ether Handling: Modern Payment Patterns on EVM

A reference implementation for secure native value transfers on Ethereum, focusing on forward compatibility, gas efficiency, and reentrancy protection.

## 🚀 Engineering Context

As a **Java Software Engineer**, implementing payments typically involves integrating third-party APIs (like Stripe/PayPal) or handling ACID transactions in a centralized database.

In **Solidity**, value transfer is a native language primitive. This project explores the security implications of this paradigm shift, specifically focusing on the transition from legacy patterns (`transfer`/`send`) to modern standards (`call`) required for interoperability with Smart Wallets.

## 💡 Project Overview

The goal of this contract is to implement a robust payment gateway that handles ETH deposits and withdrawals. It addresses the limitations of hardcoded gas limits found in older Solidity versions and implements observability patterns for off-chain indexing.

### 🔍 Key Technical Features:

* **Modern Transfer Logic (`.call` vs `transfer`):**
    * **Architecture Decision:** Deprecated the legacy `transfer()` function (which imposes a hardcoded 2300 gas limit).
    * **Solution:** Implemented `.call{value: amount}("")`. This ensures forward compatibility with Abstract Accounts and Gnosis Safes that may require more gas to process a receipt, preventing the contract from becoming obsolete as gas costs change.

* **Direct Deposits (`receive`):**
    * Implemented the `receive() external payable` fallback function. This enables the contract to function as a seamless wallet destination, accepting direct ETH transfers without requiring specific calldata execution.

* **Gas Optimization (Custom Errors):**
    * **Bytecode Reduction:** Replaced expensive `require` strings with `error TransferFailed()` and `error InsufficientBalance()`. This significantly reduces deployment costs and runtime execution gas compared to storing and processing ASCII error strings.

* **Observability (Events):**
    * Emitted indexed `Deposit` and `Withdrawal` events to allow off-chain indexers (like The Graph) to track the flow of funds and reconstruct historical balances efficiently.

## 🛠️ Stack & Tools

* **Language:** Solidity `^0.8.24`.
* **Patterns:** Checks-Effects-Interactions (CEI), Withdrawal Pattern.
* **License:** GPL-3.0-only.

---

*This project serves as a secure baseline for handling native asset transfers in decentralized applications.*