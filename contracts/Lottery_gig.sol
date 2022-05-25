//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
    mapping(address => uint256) public addressTopay; //mapping gambler addresses to how much they pay to gamble
    address payable[] public arrayOfplayers; //array of addresses of the gamblers
    uint256 public usdEntrancefee; //entrance fee in USD
    AggregatorV3Interface internal priceFeed; //Aggregator: ETHUSD current price

    //using enum for the state of the lottery
    enum Lottery_State {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    Lottery_State public lottery_state;

    constructor(address _priceFeedAddress, uint64 subscriptionId) {
        usdEntrancefee = 50 * 10**18; //smallest unit of ether is wei (10**18 decimal)
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
        lottery_state = Lottery_State.CLOSED;
    }

    function enterLottery() public payable {
        //minimum fee is 50USD
        //decimals in 18 according to erc20 standard
        require(
            lottery_state == Lottery_State.OPEN,
            "The lottery is yet to be opened"
        ); //the lottery has to be opened by owner
        //for this function to be activated
        require(
            msg.value >= (getEntrancefee()),
            "the minimum entrance fee is 50USD, send the ETH equivalent"
        );

        arrayOfplayers.push(payable(msg.sender)); // pushing the address that calls this function into the array
        addressTopay[payable(msg.sender)] += msg.value;
    }

    function startLottery() public onlyOwner {
        require(
            lottery_state == Lottery_State.CLOSED,
            "Sorry, on-going lottery"
        );
        lottery_state = Lottery_State.OPEN;
    }

    function endLottery() public onlyOwner {
        lottery_state = Lottery_State.CALCULATING_WINNER;
    }

    function getEntrancefee() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 adjustedPrice = uint256(price) * 10**10; //in 18 decimals
        uint256 costToenter = (usdEntrancefee * 10**18) / adjustedPrice; //equivalent of 50USD in eth the moment
        return costToenter;
    }
}
