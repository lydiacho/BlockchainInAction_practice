// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BallotV3 {
    struct Voter { 
        uint weight;  
        bool voted;  
        uint vote;
    }
    struct Proposal {   //후보자
        uint voteCount;
    }

    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    enum Phase {Init, Regs, Vote, Done} 

    Phase public state = Phase.Init;  

    //수정자
    modifier validPhase(Phase reqPhase) {
        require(state == reqPhase); 
        _;
    }

    // 컨트랙트 배포 시 호출 (의장이) 
    constructor (uint numProposals) public { 
        chairperson = msg.sender;  
        voters[chairperson].weight = 2; 
        for (uint prop = 0; prop < numProposals; prop++) {  //후보자 등록
            proposals.push(Proposal(0));
        }
        state = Phase.Regs;  // Regs 단계로 state 변경 
    }

    // 의장만 실행 가능
    function changeState(Phase x) public {
        if (msg.sender != chairperson) revert();  //의장인지 if문으로 명시적 검증
        if (x < state) revert(); 
        state = x;
    }

    //투표자 등록. 의장만 실행 가능. 
    function register(address voter) public validPhase(Phase.Regs) { 
        if (msg.sender != chairperson || voters[voter].voted) return; // if문으로 명시적 검증
        voters[voter].weight = 1;
        voters[voter].voted = false;
    }

    //투표. 1인 1투표 
    function vote(uint toProposal) public validPhase(Phase.Vote) {
        Voter memory sender = voters[msg.sender];  //메모리 변수 : 임시적. 블록체인에 저장 안되는 변수 
        if (sender.voted || toProposal >= proposals.length) revert();  // if문으로 명시적 검증
        sender.voted = true;
        sender.vote = toProposal;  //몇번 찍었는지
        proposals[toProposal].voteCount += sender.weight;  //해당 후보의 투표 수 증가 
    }

    //승자 반환
    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) {
        //view : 읽기용 함수. 블록체인에 트랜잭션으로 기록 안됨
        uint winningVoteCount = 0;
        for (uint prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
        }

    }

}


/* account list
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 : 의장
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 : 투표자1 
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db : 투표자2
0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB : 투표자3
0x617F2E2fD72FD9D5503197092aC168c91465E7f2 : 투표자4
*/