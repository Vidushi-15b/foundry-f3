// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMetest is Test{
    FundMe fundme;
    address USER =makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
     uint256 constant GAS_PRICE = 1;
    
  
    function setUp() external {
    // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    DeployFundMe deployfundme = new DeployFundMe();
    fundme = deployfundme.run();
    vm.deal(USER,STARTING_BALANCE);
    }
    function testMinimumDollarIsFive() public view{
       assertEq(fundme.MINIMUM_USD(), 5e18);
     }
   function testownerisMSGsender() public view {
     assertEq(fundme.getOwner(),msg.sender);
   }

function testPriceFeedVersionIsAccurate() public view{
    uint256 version = fundme.getVersion();
    assertEq(version,4);
   }
   function testFundFailsWithoutEnoughEth() public {
    vm.expectRevert();
    fundme.fund();
   }
function testFundUpdatesFundedDataStructure() public {
  vm.prank(USER); //next transaction is set by user
  fundme.fund{value: SEND_VALUE}();
   
      uint amountFunded = fundme.getAmountToBeFunded(USER);
      assertEq(amountFunded,SEND_VALUE); 

}
function testAddsFunderToArrayFunders() public {
  vm.prank(USER); //next transaction is set by user
  fundme.fund{value: SEND_VALUE}();
   address funder = fundme.getFunder(0);
   assertEq(funder,USER);
}
  modifier funded {
  vm.prank(USER); //next transaction is set by user
  fundme.fund{value: SEND_VALUE}();
  _;
}

function testOnlyOwnerCanWithdraw() public funded{
  
   vm.prank(USER);
   vm.expectRevert();
   fundme.withdraw();
}
function testWithDrawWithaSingleFunder() public funded{
  //arrange
  uint256 startingOwnerBalance = fundme.getOwner().balance;
  uint256 startingFundMeBalance =address(fundme).balance;
  //act 
  
  vm.prank(fundme.getOwner());
  fundme.withdraw();
  //assert
  uint256 endingOwnerBalance =fundme.getOwner().balance;
  uint256 endingFundMeBalance =address(fundme).balance;
  assertEq(endingFundMeBalance,0);
  assertEq(startingFundMeBalance + startingOwnerBalance,endingOwnerBalance);
}
function testWithDrawWithaMultipleFunder() public funded{
  uint160 numberOfFunders = 10;
  uint160 startingFundingIndex =1;
  for(uint160 i=startingFundingIndex;i<numberOfFunders ;i++){
  hoax(address(i),SEND_VALUE);
  fundme.fund{value:SEND_VALUE}();
  }
   uint256 startingOwnerBalance = fundme.getOwner().balance;
  uint256 startingFundMeBalance =address(fundme).balance;
  //act
  
   vm.startPrank(fundme.getOwner());
  fundme.withdraw();
  vm.stopPrank();


  //assert
  assert(address(fundme).balance == 0);
  assert(startingFundMeBalance + startingOwnerBalance== fundme.getOwner().balance);
}
function testWithDrawWithaMultipleFunderCheaper() public funded{
  uint160 numberOfFunders = 10;
  uint160 startingFundingIndex =1;
  for(uint160 i=startingFundingIndex;i<numberOfFunders ;i++){
  hoax(address(i),SEND_VALUE);
  fundme.fund{value:SEND_VALUE}();
  }
   uint256 startingOwnerBalance = fundme.getOwner().balance;
  uint256 startingFundMeBalance =address(fundme).balance;
  //act
  
   vm.startPrank(fundme.getOwner());
  fundme.cheaperWithdraw();
  vm.stopPrank();


  //assert
  assert(address(fundme).balance == 0);
  assert(startingFundMeBalance + startingOwnerBalance== fundme.getOwner().balance);
}
}