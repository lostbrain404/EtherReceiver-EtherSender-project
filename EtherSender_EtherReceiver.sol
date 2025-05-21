// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/// @title Receiver Contract
/// @notice Receives Ether from a sender contract and emits an event upon reception
contract Receiver {
    /// @notice Emitted when Ether is received
    /// @param sender The address sending the Ether
    /// @param amount The amount of Ether received (in wei)
    event Received(address indexed sender, uint256 amount);

    /// @notice Receive Ether with a minimum amount requirement
    /// @dev This function must be called explicitly; triggered via call with signature "receiveEther()"
    /// @dev Reverts if the sent value is less than 0.0001 Ether
    function receiveEther() external payable {
        require(msg.value > 0.0001 ether, "Invalid amount");
        emit Received(msg.sender, msg.value);
    }
}

/// @title Sender Contract
/// @notice Sends Ether to a Receiver contract using a forwarding function with error handling (try/catch)
contract Sender {
    /// @notice Emitted with the result message of the send attempt
    /// @param message Success or failure message describing the send outcome
    event SendResult(string message);

    /// @notice Send Ether to a specified address
    /// @param to The address of the receiver contract
    /// @dev Requires a minimum value of 0.0001 Ether to send
    /// @dev Uses try/catch to handle success and failure of the forwarding call
    function sendEther(address to) external payable {
        require(msg.value >= 0.0001 ether, "Invalid amount");

        try this.forwardEther(to, msg.value) {
            emit SendResult("Transaction sent successfully");
        } catch Error(string memory reason) {
            emit SendResult(reason);
        } catch {
            emit SendResult("Unknown failure");
        }
    }

    /// @notice Forward Ether to the target contract by calling its receiveEther function
    /// @param to The target contract address to send Ether to
    /// @param amount The amount of Ether (in wei) to forward
    /// @dev Uses low-level call with the encoded function signature "receiveEther()"
    /// @dev Reverts if the call fails
    function forwardEther(address to, uint256 amount) external {
        (bool sent, ) = to.call{value: amount}(abi.encodeWithSignature("receiveEther()"));
        require(sent, "call failed");
    }

    /// @notice Built-in receive function to accept Ether sent directly to this contract
    receive() external payable {}
}
