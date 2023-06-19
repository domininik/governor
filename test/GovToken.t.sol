// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/GovToken.sol";

contract GovTokenTest is Test {
  GovToken public token;

  function setUp() public {
    token = new GovToken();
  }

  function testNamel() public {
    assertEq(token.name(), "GovToken");
  }

  function testSymbol() public {
    assertEq(token.symbol(), "GTK");
  }

  function testDecimals() public {
    assertEq(token.decimals(), 18);
  }

  function testTotalSupply() public {
    assertEq(token.totalSupply(), 0);
  }

  function testBalanceOf() public {
    assertEq(token.balanceOf(address(this)), 0);
  }
}
