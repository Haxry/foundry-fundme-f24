// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test,console} from"forge-std/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{

  FundMe fundMe;

  address  USER= makeAddr("user");
  uint256 constant GAS_PRICE=1;

  function setUp() external {
   // fundMe=new FundMe();
          DeployFundMe deployFundMe=new DeployFundMe();
          fundMe=deployFundMe.run();
          vm.deal(USER, 10 ether);
  }

  function testMinimumDollarIsFive() public{
    assertEq(fundMe.MINIMUM_USD(), 5e18);
  }
  function testOwnerIsMsgSender() public{
    assertEq(fundMe.getOwner(),msg.sender);
  }

  function testPriceFeedVersionIsAccurate() public{
    assertEq(fundMe.getVersion(), 4);
  }
  
  function testFundFailsWithoutEnoughEth() public{
    vm.expectRevert();
    fundMe.fund();
}

function testFundUpdatesFundedDataStructure() public{
vm.prank(USER);
fundMe.fund{value:10e18}();

uint256 amountFunded= fundMe.getAddressToAmoutFunded(USER);
assertEq(amountFunded, 10e18);
}

function testAddsFunderToArrayOfFunders() public funded{
 

  address funder=fundMe.getFunder(0);
  assertEq(funder, USER);

}

modifier funded(){
  vm.prank(USER);
  fundMe.fund{value:10e18}();
  _;
}

function testOnlyOwnerCanWithdraw() public funded{
   

vm.expectRevert();

fundMe.withdraw();

}

function testWithDrawWithASingleFunder() public funded{
  //Arrange
  uint256 startOwnerbalance= fundMe.getOwner().balance;
  uint256 startingFundMeBalance= address(fundMe).balance;

  //Act
  //uint256 gasStart=gasleft();
  //vm.txGasPrice(GAS_PRICE);
  vm.prank(fundMe.getOwner());
  fundMe.withdraw();

  //uint256 gasEnd=gasleft();
  //uint256 gasUsed=(gasStart-gasEnd)* tx.gasprice;
  //console.log(gasUsed);

  //Assert
  uint256 endingOwnerBalance= fundMe.getOwner().balance;
  uint endingFundMeBalance= address(fundMe).balance;
  assertEq(endingFundMeBalance,0);
  assertEq(startingFundMeBalance+startOwnerbalance, endingOwnerBalance);
}

function testWithdrawFromMultipleFunders() public funded{
  uint160 numberOfFunders=10;
  uint160 startingFunderIndex=1;
  for(uint160 i=startingFunderIndex;i<numberOfFunders;i++){
    hoax(address(i),10e18);
    fundMe.fund{value:10e18}();
  }

  uint256 startingOwnerBalance=fundMe.getOwner().balance;
  uint256 startingFundMeBalance=address(fundMe).balance;

  vm.startPrank(fundMe.getOwner());
  fundMe.withdraw();
  vm.stopPrank();

  assert(address(fundMe).balance==0);
  assert(startingFundMeBalance+startingOwnerBalance== fundMe.getOwner().balance);

}//Kya vaakai me hal hai yaa bas zaaya waqt kar raha hu  




}
