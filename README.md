# EtherSender & EtherReceiver Contracts

## Overview

This project contains two Solidity smart contracts:

- **EtherReceiver**: A contract that can receive Ether via a dedicated payable function `receiveEther()` which enforces a minimum amount and emits an event on receipt.
- **EtherSender**: A contract that sends Ether to the `EtherReceiver` contract using a forwarding function with `try/catch` error handling to capture and emit transaction success or failure events.

---

## Contracts

### EtherReceiver

- **Function:** `receiveEther() external payable`
- **Purpose:** Receives Ether and requires the sent value to be greater than 0.0001 Ether.
- **Event:** `Received(address indexed sender, uint256 amount)` emitted on successful receipt.

### EtherSender

- **Function:** `sendEther(address to) external payable`
- **Purpose:** Sends Ether to the specified address (typically an `EtherReceiver` contract).
- **Mechanism:** Uses a helper function `forwardEther` with a low-level `call` to invoke the receiver’s `receiveEther()` function.
- **Error Handling:** Uses Solidity `try/catch` to catch and emit success or error messages.
- **Event:** `SendResult(string message)` emitted with the status of the transaction.

---

## Usage

1. **Deploy `EtherReceiver` contract**

   This contract will receive Ether and emit events.

2. **Deploy `EtherSender` contract**

   This contract will be used to send Ether to the deployed `EtherReceiver`.

3. **Send Ether**

   Call `sendEther` on `EtherSender` with the address of `EtherReceiver` and attach at least 0.0001 Ether.

4. **Events**

   - On success, `SendResult` event will emit `"Transaction sent successfully"`.
   - On failure, the event will emit the failure reason or `"Unknown failure"`.

---

## Example with Remix

- Deploy `EtherReceiver`.
- Deploy `EtherSender`.
- Copy the deployed address of `EtherReceiver`.
- Call `sendEther` on `EtherSender` passing the copied address and send a minimum of 0.0001 Ether.
- Observe events to confirm success or failure.

---

## Notes

- The `forwardEther` function uses low-level call with encoded signature `receiveEther()` on the receiver contract. Ensure the receiver has the matching function signature.
- The contracts require Solidity version `0.8.30`.
- The contracts include a fallback `receive()` function in `EtherSender` to accept direct Ether transfers.

---

## License

MIT License [lostbrain404]
