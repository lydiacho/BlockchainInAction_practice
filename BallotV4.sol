// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BallotV4 {
    struct Voter { 
        uint weight;  
        bool voted;  
        uint vote;
    }
    struct Proposal { 
        uint voteCount;
    }

    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    enum Phase {Init, Regs, Vote, Done} 

    Phase public state = Phase.Init;  

    modifier validPhase(Phase reqPhase) {
        require(state == reqPhase); 
        _;
    }

    modifier onlyChair() {  //의장만 실행 가능하도록 제한
        require(msg.sender == chairperson);
        _;
    }

    constructor (uint numProposals) public { 
        chairperson = msg.sender;  
        voters[chairperson].weight = 2; 
        for (uint prop = 0; prop < numProposals; prop++) { 
            proposals.push(Proposal(0));
        }
        state = Phase.Regs; 
    }

    function changeState(Phase x) onlyChair public {  
        // if (msg.sender != chairperson) revert(); -> onlyChair 수정자로 대체
        require (x > state);  // if (x < state) revert(); 대체 
        state = x;
    }

    function register(address voter) public validPhase(Phase.Regs) onlyChair { 
        //if (msg.sender != chairperson || voters[voter].voted) return; 
        require (!voters[voter].voted);
        voters[voter].weight = 1;
        voters[voter].voted = false;
    }

    function vote(uint toProposal) public validPhase(Phase.Vote) {
        Voter memory sender = voters[msg.sender]; 
        if (sender.voted || toProposal >= proposals.length) revert(); 
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) {
        uint winningVoteCount = 0;
        for (uint prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
        }

        assert(winningVoteCount>=3);  //assert()사용

    }

}


/* account list
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 : 의장
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 : 투표자1 
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db : 투표자2
0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB : 투표자3
0x617F2E2fD72FD9D5503197092aC168c91465E7f2 : 투표자4
*/