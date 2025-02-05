// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Ballot} from "src/VotingDoctored.sol";
import {Test} from "forge-std/Test.sol";

contract VotingDoctoredTest is Test {
    Ballot ballot;

    address public VOTER_ALICE = makeAddr("ALICE");
    address public VOTER_BOB = makeAddr("BOB");
    uint256 constant TRUMP_INDEX = 0;
    uint256 constant CLINTON_INDEX = 1;

    function setUp() public {
        bytes32[] memory proposalNames = new bytes32[](2);
        proposalNames[0] = "Trump";
        proposalNames[1] = "Clinton";
        ballot = new Ballot(proposalNames);
    }

    // test giveRightToVote() function sets right correct.
    function testVoteRightsBeforeAndAfter() public {
        (uint256 previousWeight, , , ) = ballot.voters(VOTER_ALICE);
        assertEq(previousWeight, 0);
        ballot.giveRightToVote(VOTER_ALICE);
        (uint256 currentWeight, , , ) = ballot.voters(VOTER_ALICE);
        assertEq(currentWeight, 1);
    }

    // test vote() function increments vote count.
    function testVote() public {
        ballot.giveRightToVote(VOTER_ALICE);
        vm.prank(VOTER_ALICE);
        ballot.vote(TRUMP_INDEX);
        (bytes32 name, uint256 voteCount) = ballot.proposals(TRUMP_INDEX);
        assertEq(voteCount, 1);
    }
}
