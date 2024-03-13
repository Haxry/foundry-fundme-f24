// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test,console} from"forge-std/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "script/Interactions.s.sol";

contract InteractionsTest is Test{
  FundMe fundMe;
  address USER=makeAddr("USER");
   
   function setUp() external{
    DeployFundMe deploy= new DeployFundMe();
    fundMe= deploy.run();
    
   }

   function testUserCanFundInteractions() public{
    FundFundMe fundFundMe= new FundFundMe();
    vm.prank(USER);
    //vm.deal(USER, 1e18);
    vm.deal(USER,10 ether);
    fundFundMe.fundFundMe(address(fundMe));
    address funder=fundMe.getFunder(0);
    assertEq(funder, USER);
   }

   function testUserCanWithdrawInteractions() public{
    FundFundMe fundFundMe = new FundFundMe();
    fundFundMe.fundFundMe(address(fundMe));
    WithdrawFundMe withDrawFundMe = new WithdrawFundMe();
    withDrawFundMe.withdrawFundMe(address(fundMe));

    assert(address(fundMe).balance==0);
   }
}