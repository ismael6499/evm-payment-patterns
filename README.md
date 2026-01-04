# 💸 Secure Settlement Core: EVM Payment Patterns

![Solidity](https://img.shields.io/badge/Solidity-0.8.24-363636?style=flat-square&logo=solidity)
![Security](https://img.shields.io/badge/Security-Reentrancy_Safe-green?style=flat-square)
![License](https://img.shields.io/badge/License-GPL_3.0-blue?style=flat-square)

A robust reference implementation for handling native Ether (ETH) settlements on the EVM. This project establishes secure patterns for receiving, holding, and distributing value, addressing the obsolescence of legacy transfer methods.

Unlike deprecated `.transfer()` or `.send()` methods—which impose a hard 2300 gas limit incompatible with modern Smart Contract Wallets (Account Abstraction/Gnosis Safe)—this architecture utilizes low-level `call` opcodes wrapped in defensive logic to ensure interoperability and safety.

## 🏗 Architecture & Design Decisions

### 1. Settlement Security (The `.call` Standard)
- **Forward-Compatible Transfers:**
  - Implemented `(bool success, ) = recipient.call{value: amount}("")` to execute payouts.
  - **Why:** This prevents "Out of Gas" DoS attacks when interacting with complex receiver contracts (e.g., Multisigs or DAOs) that require more than 2300 gas to trigger their own receipts (`receive` functions).
- **Return Value Validation:** Strict enforcement of the boolean success flag to prevent silent failures during value transfer.

### 2. Calldata Hygiene (Receive vs. Fallback)
- **Explicit Separation:**
  - `receive() external payable`: Strictly handles empty-calldata ETH transfers (standard wallet sends).
  - `fallback() external payable`: Handles calls with data payload that do not match a function signature.
  - **Benefit:** clearly distinguishing intent allows the contract to reject erroneous interactions or implement distinct logic for pure funding vs. arbitrary execution attempts.

### 3. Checks-Effects-Interactions (CEI)
- **Reentrancy Mitigation:**
  - State changes (balances updates) occur *strictly before* the external `.call` to the recipient. This architectural discipline neutralizes reentrancy vectors without necessarily relying on heavy `ReentrancyGuard` modifiers for simple transfer logic.

## 🛠 Tech Stack

* **Core:** Solidity `^0.8.24`
* **Patterns:** CEI (Checks-Effects-Interactions), Low-level Call
* **Standards:** Solidity 0.6.x+ Payment Splitter conventions
* **License:** GNU GPL v3

## 📝 Contract Interface

The implementation exposes a secured payout interface compatible with EOAs and Contract Wallets:

```solidity
// Secure pattern for withdrawals
function withdraw() external {
    uint256 amount = address(this).balance;
    (bool success, ) = owner.call{value: amount}("");
    if (!success) revert TransferFailed();
}
