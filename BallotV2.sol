// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BallotV2 {
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

    constructor (uint numProposals) public {  //컨트랙트 배포 시 실행
        chairperson = msg.sender;   //컨트랙트 배포자 -> 의장으로 설정
        voters[chairperson].weight = 2;  //의장의 가중치 2로 설정
        for (uint prop = 0; prop < numProposals; prop++) {  //proposals 개수만큼 배열에 구조체 추가
            proposals.push(Proposal(0));
        }
    }

    // 단계를 변화시키는 함수 (의장만 실행 가능)
    function changeState(Phase x) public {
        if (msg.sender != chairperson) revert();  //의장이 아닐 경우 되돌림
        if (x < state) revert(); //state는 0, 1, 2, 3 단계로 진행되며 그렇지 않을 경우 되돌림
        state = x;
    }
    

    function register(address voter) public validPhase(Phase.Regs) {  //투표자 등록
        // if (state != Phase.Regs) { revert(); }
        if (msg.sender != chairperson || voters[voter].voted) return;
        voters[voter].weight = 1;
        voters[voter].voted = false;
    }

}

