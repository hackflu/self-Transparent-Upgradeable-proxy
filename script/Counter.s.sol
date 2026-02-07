// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";
import {ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {TransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract CounterScript is Script {
    Counter public counter;

    function run() public returns (address) {
        vm.startBroadcast();
        //1.  deployed the CounterScript
        counter = new Counter();

        //2.  set the proxy Admin
        // and the admin is the owner who deployed the contract
        //3. Prepare Initalization Data
        // initalizer
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 100);

        // Deploy the TransapatentUpgradeableProxy
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(address(counter), msg.sender, data);

        vm.stopBroadcast();
        console.log("The Proxy address : ", address(proxy));
        return address(proxy);
        // console.log("The proxyAdmin address : ", address(admin));
    }
}
