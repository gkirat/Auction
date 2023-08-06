// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{
    address payable Auctioneer;

    //in blockchain 1block= 15 sec it means one block is generated in 15 secs
    uint public stblock; //start time block
    uint public etblock; //end time block

    enum Auction_state{
        Started,
        Running,
        Ended,
        Cancelled
    }

    Auction_state public auctionstate;
    
    uint public highest_bid;
    uint public highest_payable_bid;
    uint public bid_increment;

    address payable public highest_bidder;

    
    mapping (address => uint ) public bids;



    constructor()  {
       Auctioneer=payable(msg.sender);  //we cannot set bidders address in comstructor because then msg.sender will collaspe with the auctioneer address
        auctionstate  =  Auction_state.Running;
        stblock = block.number;
        etblock = stblock + 240;
        bid_increment = 1 ether;
    }





    modifier notowner(){    //this modifier will be used when auctioneer wants to participate
        require (msg.sender != Auctioneer,"Auctioneer not allowed");

    _;
    }

    modifier owner() {     //this modifier will be used when auctioneer will end the auction, so only he can access
        require (msg.sender==Auctioneer ,"Only owner can access");

        _;
    }

    modifier startedTime(){
        require(block.number>stblock);

        _;
    }
    modifier beforeEnding(){
        require (block.number<etblock);

        _;
    }


    // this function is used when owner wants to cancel the auction

    function cancelAuc()  owner public returns(Auction_state){

        auctionstate=Auction_state.Cancelled;
        return auctionstate;
    

    }


    function bid()   payable public notowner  startedTime beforeEnding {
        require (auctionstate != Auction_state.Cancelled,"Auction should not be cancelled to proceed further");
        require (msg.value >= 1000000000000000000,"Threshold amount required to participate in bidding");


        uint currentBid = bids[msg.sender] + bid_increment;


        
    }


    
}
