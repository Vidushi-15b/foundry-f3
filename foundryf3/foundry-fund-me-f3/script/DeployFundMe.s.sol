// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {HelperConfig} from "./HelperConfig.s.sol";

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
contract DeployFundMe is Script {
    function run() external returns (FundMe){

       HelperConfig helperConfig = new HelperConfig();

        address priceFeed = helperConfig.getPriceFeed();

        vm.startBroadcast();
       FundMe fundme = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundme;
    }
}
//priceFeed :