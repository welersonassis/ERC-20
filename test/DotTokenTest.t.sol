// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployDotToken} from "../script/DeployDotToken.s.sol";
import {DotToken} from "../src/DotToken.sol";

contract DotTokenTest is Test {

    DotToken public DotToken;
    DeployDotToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployDotToken();
        deployer.run();
        
        vm.prank(msg.sender);
        DotToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE,DotToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        DotToken.approve(alice, initialAllowance);

        uint256 transferAmount = 100;

        vm.prank(alice);
        DotToken.transferFrom(bob, alice, transferAmount);

        assertEq(transferAmount, DotToken.balanceOf(alice));
        assertEq(STARTING_BALANCE - transferAmount, DotToken.balanceOf(bob));

    }

}
