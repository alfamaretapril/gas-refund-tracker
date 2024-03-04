// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Gas Refund Tracker
/// @author Chat
/// @notice Refunds gas to whitelisted users based on their on-chain activity

contract GasRefundTracker {
    address public owner;
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public gasRefunded;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelist[msg.sender], "Not whitelisted");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addToWhitelist(address user) external onlyOwner {
        whitelist[user] = true;
    }

    function removeFromWhitelist(address user) external onlyOwner {
        whitelist[user] = false;
    }

    function performAndRefund() external onlyWhitelisted {
        uint256 gasStart = gasleft();

        for (uint256 i = 0; i < 10; i++) {
            keccak256(abi.encodePacked(i));
        }

        uint256 gasUsed = gasStart - gasleft();
        uint256 refund = gasUsed * tx.gasprice;

        gasRefunded[msg.sender] += refund;

        payable(msg.sender).transfer(refund);
    }

    receive() external payable {}
}
