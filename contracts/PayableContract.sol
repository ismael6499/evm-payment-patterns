// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.24; 

/// @title Payable Contract Example
/// @author Agustin Acosta
/// @notice Demonstrates handling of Ether deposits and withdrawals using low-level calls
contract PayableContract {

    error TransferFailed();
    error InsufficientBalance(uint256 requested, uint256 available);

    event Withdrawal(address indexed to, uint256 amount);
    event Deposit(address indexed from, uint256 amount);

    // Special function to receive Ether without data (msg.data is empty)
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Explicit function to receive Ether via a function call
    // Changed from 'public' to 'external' for gas optimization
    function sendEther() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdrawEther(uint256 _amount) external {
        // Good practice: Check conditions (Checks)
        if (address(this).balance < _amount) {
            revert InsufficientBalance(_amount, address(this).balance);
        }

        // Good practice: Interaction (Perform the action)
        // Using 'call' is the recommended way to send Ether since Solidity 0.6.0
        // to prevent gas limit issues associated with 'transfer' or 'send'.
        (bool success, ) = msg.sender.call{value: _amount}("");
        
        if (!success) {
            revert TransferFailed();
        }

        // Emit event after successful transfer
        emit Withdrawal(msg.sender, _amount);
    }
}