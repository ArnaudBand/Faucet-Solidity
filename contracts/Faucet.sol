// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Faucet {
  address payable public owner;

  constructor() payable {
    owner = payable(msg.sender);
  }
  
  // Allows users to withdraw a specified amount of ether from the contract
  function withdraw(uint _amount) payable public {
    require(_amount <= 100000000000000000);
    (bool sent, ) = payable(msg.sender).call{value: _amount}("");
    require(sent, "Failed to send Ether");
  }

  // Allows the owner to withdraw all of the ether held by the contract
  function withdrawAll() onlyOwner public {
    (bool sent, ) = owner.call{value: address(this).balance}("");
    require(sent, "Failed to send Ether");
  }

  // Allows the owner to destroy the contract and transfer any remaining ether to their address
  function destroyFaucet() onlyOwner public {
    selfdestruct(owner);
  }

  // Modifier that restricts access to certain functions to the owner of the contract
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}