// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BallotV1 {
    struct Voter {  //투표자 상세 정보
        uint weight;  //가중치 (의장 : 2) 
        bool voted;  //투표 완료 여부
        uint vote;
    }
    struct Proposal {  //제안의 상세 정보
        uint voteCount;
    }

    address chairperson;
    mapping(address => Voter) voters;  //투표자 정보를 투표자 상세 정보로 매핑
    Proposal[] proposals;

    //enum : solidity 내부 데이터 타입
    enum Phase {Init, Regs, Vote, Done}  //투표의 여러 단계(0, 1, 2, 3) 

    Phase public state = Phase.Init;  //현재 진행중인 투표 단계 (init으로 초기화) 
    // public 데이터는 유저 인터페이스 버튼 생김 (클릭 시 state 값 반환 (public 가시성 수정자)
    // Phase public state = Phase.Done;  -> state 접근 시 3반환 
}