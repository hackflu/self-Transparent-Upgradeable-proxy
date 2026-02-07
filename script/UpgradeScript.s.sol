// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {CounterUpgrade} from "../src/CounterUpgrade.sol";

import {
    ProxyAdmin
} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import {
    ITransparentUpgradeableProxy
} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

contract UpgradeScript is Script {
   
    CounterUpgrade public counterUpgrade;

    function run(address ADMIN_ADDRESS, address PROXY_ADDRESS) public {
        deployUpgradeContract(ADMIN_ADDRESS, PROXY_ADDRESS);
        console.log(
            "Upgrade successful! New logic at:",
            address(counterUpgrade)
        );
    }

    function deployUpgradeContract(
        address ADMIN_ADDRESS,
        address PROXY_ADDRESS
    ) public {
        counterUpgrade = new CounterUpgrade();
        ProxyAdmin admin = ProxyAdmin(ADMIN_ADDRESS);
        address owner = admin.owner();
        console.log("current owner : ", owner);
        vm.startBroadcast(owner);
        admin.upgradeAndCall(
            ITransparentUpgradeableProxy(PROXY_ADDRESS),
            address(counterUpgrade),
            new bytes(0)
        );
        vm.stopBroadcast();
    }
}
