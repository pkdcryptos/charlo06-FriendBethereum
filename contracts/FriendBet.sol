pragma solidity ^0.4.2;

contract FriendBet{
    address _creator;
    uint public _valueBet;
    uint _endTimeBet;
    uint _endMatch;
    uint _balance;
    uint _winner;
    uint _prizeBet;

    mapping(address=>uint) public playerChoice;
    mapping(uint => uint) public numberOfBetForTeam;

    event Finished (uint winner);


    //--------------------modifier-----------------------------
    modifier isOwner() {
        if(msg.sender != _creator) return;
        _;
    }

    modifier notPlayedYet(){
      if(playerChoice[msg.sender] != 0) return;
      _;
    }

    modifier canStillBet() {
      if (now >= _endTimeBet) return;
      _;
    }

    modifier endOfMatch(){
      if(now < _endMatch) return;
      _;
    }


    function FriendBet() public {
        _valueBet = 0;
        _endTimeBet = 0;
        _endMatch = 0;
        _creator = msg.sender;
        _balance = 0;
        numberOfBetForTeam[3] = 0; //if bet on draw
        numberOfBetForTeam[1] = 0;
        numberOfBetForTeam[2] = 0;
        _winner = 0;
        _prizeBet = 0;
    }

    function createBet( uint valueBet, uint endMatch, uint endTimeBet){
              _creator = msg.sender;
              _valueBet = valueBet;
              _endMatch = endMatch;
              _endTimeBet = endTimeBet;
    }

    function betTeam(uint team) notPlayedYet() {
        playerChoice[msg.sender] = team;
        _balance += _valueBet;
        numberOfBetForTeam[team] += 1;
    }
    function getNumberOFBetForTeam(uint team) public constant returns(uint){
      return(numberOfBetForTeam[team]);
    }

    function getwinnerBet(uint winner) isOwner()  endOfMatch(){
      _winner = winner;
      _prizeBet = _valueBet*(numberOfBetForTeam[3]+ numberOfBetForTeam[1]+ numberOfBetForTeam [2])/ numberOfBetForTeam[winner];
    }
    function getmoneybet()  endOfMatch(){
      playerChoice[msg.sender] = 3; //avoid withdraw more than once
      msg.sender.transfer(_prizeBet);
    }


}
