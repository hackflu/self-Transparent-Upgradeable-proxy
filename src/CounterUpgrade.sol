// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Counter} from "./Counter.sol";

contract CounterUpgrade is Counter {
    function decrement() public returns (uint256) {
        counter -= 2;
        return counter;
    }
}
