// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Counter} from "../src/Counter.sol";
import {CounterScript} from "../script/Counter.s.sol";
import {Script, console} from "forge-std/Script.sol";
import {UpgradeScript} from "../script/UpgradeScript.s.sol";
import {CounterUpgrade} from "../src/CounterUpgrade.sol";

contract CounterUpgradeTest is Script {
    CounterScript public counterScript;
    UpgradeScript public upgradeScript;
    CounterUpgrade public counterUpgrade;
    address public ADMIN_OF_PROXY_CONTRACT = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    bytes32 public constant PROXY_ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
    bytes32 constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    address public PROXY_ADMIN_ADDRESS;
    address public IMPLEMENTATION_ADDRESS;
    address public USER = makeAddr("user"); 
    Counter public counter;

    function setUp() public {
        counterScript = new CounterScript();
        address proxy = counterScript.run();
        bytes32 data = vm.load(proxy , PROXY_ADMIN_SLOT);
        PROXY_ADMIN_ADDRESS = address(uint160(uint256(data)));
        IMPLEMENTATION_ADDRESS = address(uint160(uint256(vm.load(proxy, IMPLEMENTATION_SLOT))));
        counter = Counter(proxy);
        console.log(counter.counter());
        upgradeScript = new UpgradeScript();
        upgradeScript.deployUpgradeContract(PROXY_ADMIN_ADDRESS, proxy);
        counterUpgrade = CounterUpgrade(proxy);
    }

    /*//////////////////////////////////////////////////////////////
                            COUNTER CONTRACT
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                           INCREMENT FUNCTION
    //////////////////////////////////////////////////////////////*/

    function testIncrement() public {
        vm.startPrank(USER);
        console.log("value before increment : ",counter.counter());
        counter.increment();
        uint256 val = counter.getRealCounter();
        console.log("value after increment : ",val);
        vm.stopPrank();
        console.log("value : ",counter.counter());
        assert(counter.counter() == 102);
    }

    function testGetRealCounter() public {
        vm.prank(USER);
        uint256 val = counter.getRealCounter();
        console.log("value : ",val);
        vm.stopPrank();
        assert(val == 100);
    }

    function testOwnerCanCallProxyContract() public {
        vm.prank(ADMIN_OF_PROXY_CONTRACT);
        counter.increment();
        vm.stopPrank();
        assert(counter.counter() == 102);
    }

    /*//////////////////////////////////////////////////////////////
                            UPGRADE CONTRACT
    //////////////////////////////////////////////////////////////*/

    function testCounterUpgrade() public {
        vm.prank(USER);
        counterUpgrade.decrement();
        // console.log("value afterd decrement : ",counterUpgrade.counter());
        vm.stopPrank();
    }
} 