// SPDX-License-Identifier: MIT

pragma solidity^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "src/FundMe.sol";

contract FundFundMe is Script{
 uint256 constant SEND_VALUE=0.01 ether;
  function fundFundMe(address mostRecentDeployed) public{
    
   
    FundMe(payable(mostRecentDeployed)).fund{value: 1 ether}();
    

    console.log("Funded FundMe with %s",SEND_VALUE);
  }

  function run() external {
 address mostRecentlyDeployed= DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
 vm.startBroadcast();
 fundFundMe(mostRecentlyDeployed);
 vm.stopBroadcast();
  }
}

contract WithdrawFundMe is Script{

  uint256 constant SEND_VALUE=0.01 ether;
  function withdrawFundMe(address mostRecentDeployed) public{
    
   vm.startBroadcast();
    FundMe(payable(mostRecentDeployed)).withdraw();
    vm.stopBroadcast();
    
    

    console.log("Funded FundMe with %s",SEND_VALUE);
  }

  function run() external {
 address mostRecentlyDeployed= DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
 vm.startBroadcast();
 withdrawFundMe(mostRecentlyDeployed);
 vm.stopBroadcast();
  }

}