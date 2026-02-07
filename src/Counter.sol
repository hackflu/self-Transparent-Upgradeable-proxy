// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {
    Initializable
} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
contract Counter is Initializable {
    uint256 public counter;

    function initialize(uint256 _value) public initializer {
        counter = _value;
    }

    function increment() public returns (uint256) {
        counter += 2;
        return counter;
    }
    function getRealCounter() public view returns (uint256) {
        uint256 val;
        assembly {
            val := sload(0) // Manually read where you know the 100 is
        }
        return val;
    }
}
