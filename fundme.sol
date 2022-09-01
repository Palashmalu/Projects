


//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

//constant , immutable keyword
 

   contract FundMe {
   using PriceConverter for uint256;
   uint256 public constant minimumUsd = 50 * 1e18;
   address [] public funders;
   //made a mapping to keep a check on how much money each one of them sent
   mapping(address => uint256) public AddressToAmountFunded;
   address public immutable owner;
   
   constructor() {
      owner = msg.sender;
   }
    // why use payable in order to send eth we need to mark it as payable
    function fund () public  payable{
      
       //want to be able to set minimum fund amount
       // how to send eth to this contract
       // msg.value stands for how much value of native blockchain currency is sent
       require( msg.value.getConversionRate() >= minimumUsd, " didn't send enough ");  //1e18 = 1 * 10 **18 wei
       //msg.sender is the address of however who calls the fund function
       funders.push(msg.sender);
       AddressToAmountFunded [msg.sender]  += msg.value;
    } 
     // to hget the price of  eth
    function withdraw() public onlyOwner{
       for(uint256 funderindex =0; funderindex< funders.length ;funderindex = funderindex + 1) {
         address funder = funders[funderindex];
         AddressToAmountFunded [funder]= 0;
       }

       funders = new address [] (0);

     // transfer
     //payable(msg.sender).transfer(address(this).balance):
     // send
     //bool sendSuccess = payable(msg.sender).send(address(this).balance);
     //require (sendSuccess, "Send failed");//
     // call
      (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
     require(callSuccess, "Call failed");

       }
       modifier onlyOwner {
         require(msg.sender == owner, " sender is not owner ");
         _;
       }
       receive ( ) external payable {
   fund ( ) ;
}
fallback ( ) external payable {
   fund();
}
   }
    

