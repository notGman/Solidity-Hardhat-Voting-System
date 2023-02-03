// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
//0x5FbDB2315678afecb367f032d93F642f64180aa3

contract Vote{
    address public owner;
    string[] private candidateNames;
    uint daysAfter;

    constructor(uint _daysAfter){
        owner = msg.sender;
        daysAfter =block.timestamp+ _daysAfter*1 days;
    }

    struct Voter{
        string name;
        uint256 age;
        bool voted;
        string vote;
    }

    struct Candidate{
        string name;
        uint voteCount;
    }

    mapping (address =>Voter) private voter;
    Candidate[] private candidates;

    function addCandidate(string memory _name) public{
        require(block.timestamp < daysAfter,"Voting has already started.");
        require(msg.sender == owner,"You are not the owner.");
        candidates.push(Candidate({name:_name,voteCount:0}));
        candidateNames.push(_name);
    }

    function showAllCandidates() public view returns(string[] memory){
        require(block.timestamp >= daysAfter,"Voting has not started yet..");
        return candidateNames;
    }

    function removeCandidate(uint _index) public{
        require(block.timestamp < daysAfter,"Voting has already started.");
        require(msg.sender == owner,"You are not the owner.");
        if (_index >= candidates.length) return;

        for (uint i = _index; i<candidates.length-1; i++){
            candidates[i] = candidates[i+1];
            candidateNames[i] = candidateNames[i+1];
        }
        candidates.pop();
        candidateNames.pop();
    }

    function voteCandidate(string memory _name,uint256 _age, uint _index) public{
        require(block.timestamp >= daysAfter,"Voting has not started yet..");
        require(_age>=18,"You don't have the rights to vote.");
        Voter storage sender = voter[msg.sender];
        require(sender.voted!=true,"You have already placed your vote.");
        sender.name = _name;
        sender.age = _age;
        sender.voted = true;
        sender.vote = candidates[_index].name;
        candidates[_index].voteCount +=1;
    }

    function showVoter(address _address) public view returns(Voter memory){
        require(msg.sender == owner,"You are not the owner.");
        return voter[_address];
    }

    function getWinner() public view returns(Candidate memory){
        require(block.timestamp >= daysAfter,"Voting has not started yet..");
        require(msg.sender == owner,"You are not the owner.");
        uint winner = candidates.length;
        for(uint i=0; i<candidates.length-1; i++){
            if(candidates[i].voteCount>winner) winner = i;
        }
        return candidates[winner];
    }
}
