// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/GovToken.sol";
import "../src/MyGovernor.sol";

contract MyGovernorScript is Script {
  function setUp() public {}

  function run() public returns (MyGovernor, GovToken) {
    vm.startBroadcast();

    GovToken token = new GovToken();
    MyGovernor governor = new MyGovernor(token);

    vm.stopBroadcast();

    return (governor, token);
  }
}
