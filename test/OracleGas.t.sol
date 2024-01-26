// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReservoirPair} from "amm-core/src/ReservoirPair.sol";

contract OracleGas is Test {

    ReservoirPair internal _stablePair = ReservoirPair(0x146D00567Cef404c1c0aAF1dfD2abEa9F260B8C7);
    address internal _oracleCaller = 0x00A4784E29dB2B1d5e061b4F12aC635Bb910f237;

    function setUp() public {
        vm.createSelectFork(getChain("avalanche").rpcUrl);
        vm.startPrank(_oracleCaller);
    }

    function testRead4Times() external view {
        for (uint index = 0; index < 4; ++index) {
            _stablePair.observation(index);
        }
    }

    function testRead16Times() external view {
        for (uint index = 0; index < 16; ++index) {
            _stablePair.observation(index);
        }
    }
}
