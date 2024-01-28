// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {console2} from "forge-std/console2.sol";

import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {Script} from "forge-std/Script.sol";

import {Observation, LogCompression} from "amm-core/src/ReservoirPair.sol";
import {OracleCaller, ReservoirPair} from "amm-core/src/oracle/OracleCaller.sol";

contract MockOracle {
    ReservoirPair internal _stablePair = ReservoirPair(0x146D00567Cef404c1c0aAF1dfD2abEa9F260B8C7);
    OracleCaller internal _oracleCaller = OracleCaller(0x00A4784E29dB2B1d5e061b4F12aC635Bb910f237);

    function get() external view returns (uint256) {
        for (uint index = 5; index < 18; ++index) {
            _oracleCaller.observation(_stablePair , index);
        }
        _oracleCaller.observation(_stablePair, 18);
        _oracleCaller.observation(_stablePair, 19);

        return 1;
    }
}

contract Benchmarks is Script {
    ReservoirPair internal _stablePair = ReservoirPair(0x146D00567Cef404c1c0aAF1dfD2abEa9F260B8C7);
    OracleCaller internal _oracleCaller = OracleCaller(0x00A4784E29dB2B1d5e061b4F12aC635Bb910f237);
    address internal _timelock = 0xF820eCe0eaaeF4AF1535865Fb6F230f576e586c0;

    function run() external {
        // 0x7099 deploys the MockOracle
        vm.broadcast(0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d);
        MockOracle lMO = new MockOracle();

        vm.prank(_timelock);
        _oracleCaller.whitelistAddress(address(lMO), true);

        // 0xf39F calls the oracle
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        lMO.get();
        vm.stopBroadcast();
    }
}
