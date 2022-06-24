//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract AccountsDemo {

    address public whoDeposited;
    uint public depositAmt;
    uint public accountBalance;

    function deposit() public payable {  //가치를 전송받을 수 있는 함수
        whoDeposited = msg.sender;  //함수호출한 EOA 
        depositAmt = msg.value;  //함수호출 시 지정한 value
        accountBalance = address(this).balance;  //컨트랙트에 저장된 밸런스 값 
    }
}