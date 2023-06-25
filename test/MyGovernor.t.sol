// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
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

    targets = [address(token)];
    values = [0];
    calldatas = [abi.encode("transfer", address(0x456), 500)];
    description = "Proposal #1: Give grant to team";
  }

  function test_Name() public {
    assertEq(governor.name(), "MyGovernor");
  }

  function test_Token() public {
    assertEq(address(governor.token()), address(token));
  }

  function test_VotingDelay() public {
    assertEq(governor.votingDelay(), 7200);
  }

  function test_VotingPeriod() public {
    assertEq(governor.votingPeriod(), 50400);
  }

  function test_ProposalThreshold() public {
    assertEq(governor.proposalThreshold(), 0);
  }

  function test_GetVotes() public {
    address owner = token.owner();

    token.mint(owner, 1000);
    assertEq(token.balanceOf(owner), 1000);
    assertEq(token.numCheckpoints(owner), 0);
    assertEq(governor.getVotes(owner, 0), 0);

    token.delegate(owner);
    assertEq(token.numCheckpoints(owner), 1);
    assertEq(governor.getVotes(owner, 0), 0);

    vm.roll(2);
    assertEq(governor.getVotes(owner, 1), 1000);
  }

  function test_Propose() public {
    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Pending));
  }

  function test_Cancel() public {
    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    governor.cancel(targets, values, calldatas, keccak256(bytes(description)));

    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Canceled));
  }

  function test_TooLate_Cancel() public {
    governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    vm.roll(10000);
    vm.expectRevert("Governor: too late to cancel");
    governor.cancel(targets, values, calldatas, keccak256(bytes(description)));
  }

  function test_TooEarly_CastVote() public {
    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    vm.expectRevert("Governor: vote not currently active");
    governor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.For));
  }

  function test_CastVote() public {
    address owner = token.owner();

    token.mint(owner, 1000);
    token.delegate(owner);

    uint256 proposalId = governor.propose(
      targets,
      values,
      calldatas,
      description
    );

    vm.roll(10000);
    assertEq(uint256(governor.state(proposalId)), uint256(IGovernor.ProposalState.Active));

    governor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.For));

    assertEq(governor.hasVoted(proposalId, address(this)), true);
    
    (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = governor.proposalVotes(proposalId);

    assertEq(againstVotes, 0);
    assertEq(forVotes, 1000);
    assertEq(abstainVotes, 0);
  }
}
