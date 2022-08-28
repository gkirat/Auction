// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction{

    address payable public manager;
    address payable sender;
    uint public time;
    bool destroyed;

    constructor() {
        manager=payable(msg.sender);
        time=block.timestamp +3600;
    }

    struct Items {
        string item;
        uint baseprice;
        uint itemid;
        uint minIncrement;
        bool soldornot;
        address addofbidder;     
    }

    Items[] public items;

    enum Status{                      //to know the state of the suction for that particular item
        Beforeauction,
        Auctionlive,
        Sold,
        Auctionended
    }

     struct Ongoingbid{                      //to know the bidding situation of an item
        uint itemidtobid;
        string itemname;
        // uint minimumbid;                    //minimum bid requires to participate in an auction
        uint highestbid;                    //highest bid amount
        address highestbidderadd;           //highest bidder in ongoing auction 
        Status statusofitem ;    
    }
    

    Ongoingbid[] public biddinginfo;


    struct HighestBidder{                   //this is for storing highest bidder for a item
        uint itemidofhighest;   
        address highestbidder;
        uint highestamountbidded;
    }
   
    modifier onlyowner(){
        require(msg.sender==manager,"You are not the ownwer");
        _;
    }

    modifier isnotdestroyed{
        require(destroyed==false,"Contract has been destroyed");
        _;
    }

    function registeritems(string memory _item,uint _baseprice,uint _minIncrement)public onlyowner {
        Items memory tempitem;
        tempitem.item=_item;
        tempitem.baseprice=_baseprice;
        tempitem.minIncrement=_minIncrement;
        items.push(tempitem);

        Ongoingbid memory tempobid;
        for(uint i=0;i<items.length;i++){
            items[i].itemid=i;
            tempobid.itemidtobid=items[i].itemid;
            }
        tempobid.itemname=_item;
        // tempobid.minimumbid=_baseprice;
        tempobid.statusofitem=Status.Beforeauction; 
        biddinginfo.push(tempobid);
        
    }
    function sold(uint itemid)public onlyowner{
        require(biddinginfo[itemid].highestbid >items[itemid].baseprice,"Amount should be greater than the baseprice");
        require(biddinginfo[itemid].statusofitem==Status.Sold,"Bidder should first pay the amount");
        items[itemid].soldornot=true;
        items[itemid].addofbidder=biddinginfo[itemid].highestbidderadd;
    }

    function bidding(uint _itemid,uint _amount)public isnotdestroyed {
        require(items[_itemid].soldornot==false,"Item is sold");
        require(msg.sender!=manager,"Auctioneer cannot participate");
        require(_amount>=items[_itemid].baseprice + items[_itemid].minIncrement,"Amount should greater then baseprice +Increment value");
        require(_amount>items[_itemid].baseprice,"Bid should be greater than the baseprice");
        require (_amount>=biddinginfo[_itemid].highestbid + items[_itemid].minIncrement,"Amount should greater then highestbid +Increment value");
        require(block.timestamp<=time,"Auction has ended ");
         if(_itemid==biddinginfo[_itemid].itemidtobid){
            biddinginfo[_itemid].highestbid=_amount;
            biddinginfo[_itemid].highestbidderadd=msg.sender;
        }     
         if(block.timestamp>=time  ){
            for(uint i=0;i<biddinginfo.length;i++){
                biddinginfo[i].statusofitem=Status.Auctionended;
            }    
        }
        if(block.timestamp<=time){
            for(uint i=0;i<biddinginfo.length;i++){
                biddinginfo[i].statusofitem=Status.Auctionlive;
            }
        }
    }

    function transfer(uint itemid)public payable isnotdestroyed{
        require(block.timestamp>=time,"Auction is still live");
        require(biddinginfo[itemid].highestbid >items[itemid].baseprice,"Amount should be greater than the baseprice");
        require(msg.sender==biddinginfo[itemid].highestbidderadd,"You are not the highest bidder of this item");
        manager.transfer(biddinginfo[itemid].highestbid*10**18);        //this transfer funciton atomatically transfers and checks if the msg.value == highestbid money of that item so i dont need to use require
        biddinginfo[itemid].statusofitem=Status.Sold;
    }

    function Emergencyend() public onlyowner{
        require(msg.sender==manager,"Only manager is allowed to call this function");
        selfdestruct(manager);
         destroyed =true;
    }
}
