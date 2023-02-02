// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
//0xa513E6E4b8f2a923D98304ec87F64353C4D5C853

contract Vote{
    address public owner;
    string[] private candidateNames;

    constructor(){
        owner = msg.sender;
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
        require(msg.sender == owner,"You are not the owner.");
        candidates.push(Candidate({name:_name,voteCount:0}));
        candidateNames.push(_name);
    }

    function showAllCandidates() public view returns(string[] memory){
        return candidateNames;
    }

    function removeCandidate(uint _index) public{
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
        require(msg.sender == owner,"You are not the owner.");
        uint winner=0;
        for(uint i=0; i<candidates.length; i++){
            if(candidates[i].voteCount>winner) winner = i;
        }
        return candidates[winner];
    }
}
