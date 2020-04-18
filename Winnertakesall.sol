pragma solidity >=0.4.22 <0.7.0;

//Players put money into the pot. Each bid must be higher than the previous one. Highest bidder at gameEndTime takes all the money in the pot.

contract WinnerTakesAll {

    uint public gameEndTime;
    uint public biddingTime = 200;
    
    address payable public highestBidder;
    uint public highestBid;
    uint public bidsInPot;
    
    bool ended;
    
    event HighestBidIncreased(address bidder, uint amount);
    event GameEnded(address winner, uint amount);
    event NewTotalBidsInPot(uint amount);
    
    
    constructor() public{
        gameEndTime = now + biddingTime;
    }
    
    function bid() public payable{
        require(
            now <= gameEndTime,
            "Game already ended."
            );
            
        require(
            msg.value > highestBid,
            "There already is a higher bid."
            );
            
        highestBidder = msg.sender;
        highestBid = msg.value;
        bidsInPot += msg.value;
        emit HighestBidIncreased(highestBidder,highestBid);
        emit NewTotalBidsInPot(bidsInPot);
    }
    
    function gameEnd() public {
        require(
            now > gameEndTime,
            "Game has not yet ended."
            );
            
        require(
            !ended,
            "GameEnd() has already been called."
            );
            
        ended = true;
        emit GameEnded(highestBidder,highestBid);
        highestBidder.transfer(bidsInPot);
        // need to earn commission for the house
    }
}
