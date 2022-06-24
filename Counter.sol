//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Counter {
    uint value;
    function initialize (uint x) public {
        value = x;
    }
    function get() view public returns (uint) {
        return value;
    }
    function increment (uint n) public {
        value = value + n;
    }
    function decrement (uint n) public {
        value = value - n;
    }
}