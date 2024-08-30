// SPDX-License-Identifier: MIT

//fund 
//withdraw 
pragma solidity ^0.8.19;
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {Script,console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
contract FundFundMe is Script{
uint256 constant SEND_VALUE =0.1 ether;
function fundFundMe(address mostRecentDeployed) public{

    vm.startBroadcast();
    FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
    vm.stopBroadcast();
    console.log("Funded FundMe with %s",SEND_VALUE);
}

 function run() external{
 address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
 fundFundMe(mostRecentDeployed);
 vm.startBroadcast();
 fundFundMe(mostRecentDeployed);
 vm.stopBroadcast();
 }
 }

contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostRecentDeployed) public{

    vm.startBroadcast();
    FundMe(payable(mostRecentDeployed)).withdraw();
   vm.stopBroadcast();
}

 function run() external{
 address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
 withdrawFundMe(mostRecentDeployed);
 vm.startBroadcast();
 withdrawFundMe(mostRecentDeployed);
 vm.stopBroadcast();
 }

}
