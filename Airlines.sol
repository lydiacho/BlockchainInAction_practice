//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Airlines {
    address chairperson;  //의장의 identity
    struct details {  //항공사 데이터 집합
        uint escrow;
        uint status;
        uint hashOfDetails;
    }

    //회원의 identity를 상세 정보에 매핑 
    mapping (address=>details) public balanceDetails;  //데이터를 public으로 지정하여 접근 함수 자동 생성
    mapping (address=>uint) membership;

    //수정자 또는 규칙들
    modifier onlyChairperson {
        require(msg.sender == chairperson);
        _;
    }
    modifier onlyMember {
        require(membership[msg.sender]==1);
        _;
    }

    //생성자함수 : 컨트랙트 배포 시 실행 (accoutn, escrow 필요. 설정한 예치금이 등록됨)
    constructor() public payable {
        chairperson=msg.sender;
        membership[msg.sender] = 1; //자동으로 등록
        balanceDetails[msg.sender].escrow = msg.value; //예치금 등록
    }

    //항공사 자체 회원 등록 (account, escrow 필요)
    function register() public payable {
        address AirlineA = msg.sender;
        membership[AirlineA] = 1;
        balanceDetails[msg.sender].escrow = msg.value;
    }

    //항공사 회원 취소. 의장만 실행 가능
    function unregister (address payable AirlineZ) onlyChairperson public {
        membership[AirlineZ]=0;
        AirlineZ.transfer(balanceDetails[AirlineZ].escrow); //출발 항공사에게 에스크로를 반환
        balanceDetails[AirlineZ].escrow = 0;
    }

    // 좌석 요청 (인자 : 요청할 항공사 account, 상세 내용 해시주소). 멤버만 실행 가능
    function request (address toAirline, uint hashOfDetails) onlyMember public {
        if(membership[toAirline]!=1) { revert(); }  //멤버가 아니면 거절
        balanceDetails[msg.sender].status = 0;  //status = 0 : 요청 상태
        balanceDetails[msg.sender].hashOfDetails = hashOfDetails; 
    }

    // 좌석 응답 (인자 : 요청한 항공사 account, 상세 내용 해시주소, 좌석 가용 여부1/0). 멤버만 실행 가능
    function response (address fromAirline, uint hashOfDetails, uint done) onlyMember public {
        if(membership[fromAirline]!=1) { revert(); }
        balanceDetails[msg.sender].status = done; //status = 1 : 좌석 가용 상태 응답
        balanceDetails[fromAirline].hashOfDetails = hashOfDetails;
    }

    // 예치금 송금 (인자 : 예치금 받을 항공사 account). 멤버만 실행 가능
    function settlePayment (address payable toAirline) onlyMember payable public {
        address fromAirline = msg.sender;
        uint amt = msg.value;

        balanceDetails[toAirline].escrow = balanceDetails[toAirline].escrow + amt;
        balanceDetails[fromAirline].escrow = balanceDetails[fromAirline].escrow - amt;

        //msg.sender로부터 amt를 차감해 toAirline으로 보냄
        toAirline.transfer(amt);
    } 
}


/*
실습용 test account list :
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db : 의장
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 : 항공사A (fromAirline)
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 : 항공사B (toAirline)
*/