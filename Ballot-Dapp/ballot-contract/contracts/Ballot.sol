// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Ballot {
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

    modifier onlyChair() { 
        require(msg.sender == chairperson);
        _;
    }

    modifier validVoter() {   //등록된 투표자인지 체크하는 수정자
        require(voters[msg.sender].weight > 0, "Not a Registered Voter");
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
        require (x > state);  
        state = x;
    }

    function register(address voter) public validPhase(Phase.Regs) onlyChair { 
        require (!voters[voter].voted);
        voters[voter].weight = 1;
        voters[voter].voted = false;
    }

    function vote(uint toProposal) public validPhase(Phase.Vote) validVoter {
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

        assert(winningVoteCount>=3); 

    }

}