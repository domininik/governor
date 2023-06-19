// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/MyGovernor.sol";
import "../src/GovToken.sol";

contract MyGovernorTest is Test {
  MyGovernor public governor;
  GovToken public token;

  function setUp() public {
    token = new GovToken();
    governor = new MyGovernor(token);
  }

  function testName() public {
    assertEq(governor.name(), "MyGovernor");
  }

  function testToken() public {
    assertEq(address(governor.token()), address(token));
  }

  function testVotingDelay() public {
    assertEq(governor.votingDelay(), 7200);
  }

  function testVotingPeriod() public {
    assertEq(governor.votingPeriod(), 50400);
  }

  function testProposalThreshold() public {
    assertEq(governor.proposalThreshold(), 0);
  }

  function testPropose() public {
    address[] memory targets = new address[](1);
    targets[0] = address(0x123);

    uint256[] memory values = new uint256[](1);
    values[0] = 0;

    bytes[] memory calldatas = new bytes[](1);
    calldatas[0] = abi.encode("transfer", address(0x456), 1000);

    string memory description = "Proposal #1: Give grant to team";

    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Pending));
  }
}