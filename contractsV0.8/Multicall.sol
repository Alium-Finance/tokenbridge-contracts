// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @dev Provides a function to batch together multiple calls in a single external call.
 *
 * _Available since v4.1._
 */
contract Multicall {
    /**
     * @dev Receives and executes a batch of function calls on this contract.
     */
    function execute(address[] calldata dest, bytes[] calldata data) external virtual returns (bytes[] memory results) {
        uint dataLength = data.length;

        require(dataLength == dest.length, "Wrong args length");

        results = new bytes[](dataLength);
        for (uint256 i = 0; i < dataLength; i++) {
            results[i] = Address.functionCall(dest[i], data[i]);
        }
        return results;
    }

    /**
     * @dev Receives and executes a batch of function calls on this contract.
     */
    function executePayable(address[] calldata dest, bytes[] calldata data, uint256[] calldata paymentAmount) external virtual payable returns (bytes[] memory results) {
        uint dataLength = data.length;

        require(dataLength == dest.length, "Wrong args length");

        uint256 amountPassed;
        for (uint256 i = 0; i < dataLength; i++) {
            amountPassed += paymentAmount[i];
        }
        require(msg.value == amountPassed, "Payment amount incorrect");

        results = new bytes[](dataLength);
        for (uint256 i = 0; i < dataLength; i++) {
            results[i] = Address.functionCallWithValue(dest[i], data[i], paymentAmount[i]);
        }
        return results;
    }
}
