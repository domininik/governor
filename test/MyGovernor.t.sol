// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/MyGovernor.sol";
import "../src/GovToken.sol";

contract MyGovernorTest is Test {
  MyGovernor public governor;
  GovToken public token;

  address[] targets;
  uint256[] values;
  bytes[] calldatas;
  string description;


  function setUp() public {
    token = new GovToken();
    governor = new MyGovernor(token);

    targets = [address(0x123)];
    values = [0];
    calldatas = [abi.encode("transfer", address(0x456), 1000)];
    description = "Proposal #1: Give grant to team";
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
    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Pending));
  }

  function testCancel() public {
    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    governor.cancel(targets, values, calldatas, keccak256(bytes(description)));

    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Canceled));
  }
}
