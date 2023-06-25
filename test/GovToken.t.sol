// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/GovToken.sol";

contract GovTokenTest is Test {
  GovToken public token;

  function setUp() public {
    token = new GovToken();
  }

  function test_Name() public {
    assertEq(token.name(), "GovToken");
  }

  function test_Symbol() public {
    assertEq(token.symbol(), "GTK");
  }

  function test_Decimals() public {
    assertEq(token.decimals(), 18);
  }

  function test_TotalSupply() public {
    assertEq(token.totalSupply(), 0);
  }

  function test_BalanceOf() public {
    assertEq(token.balanceOf(msg.sender), 0);
  }

  function test_Mint() public {
    token.mint(msg.sender, 1000);
    assertEq(token.balanceOf(msg.sender), 1000);
  }

  function test_NotOwner_Mint() public {
    address notOwner = address(0x123);
    vm.prank(notOwner);
    vm.expectRevert("Ownable: caller is not the owner");
    token.mint(notOwner, 1000);
    assertEq(token.balanceOf(notOwner), 0);
  }

  function test_Transfer() public {
    address owner = token.owner();
    address notOwner = address(0x123);

    // we use prank to keep the same msg.sender (who is owner) across the contracts
    vm.startPrank(owner);
    token.mint(owner, 1000);
    token.transfer(notOwner, 100);
    vm.stopPrank();

    assertEq(token.balanceOf(owner), 900);
    assertEq(token.balanceOf(notOwner), 100);
  }
}
