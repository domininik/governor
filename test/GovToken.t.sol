// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/GovToken.sol";

contract GovTokenTest is Test {
  GovToken public token;

  function setUp() public {
    token = new GovToken();
  }

  function test_Namel() public {
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
    address other = address(0x123);
    vm.prank(other);
    vm.expectRevert("Ownable: caller is not the owner");
    token.mint(other, 1000);
    assertEq(token.balanceOf(other), 0);
  }
}
