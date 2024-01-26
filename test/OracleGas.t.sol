// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ReservoirPair, Observation, LogCompression} from "amm-core/src/ReservoirPair.sol";

contract OracleGas is Test {

    // addresses of actual deployed contracts on the AVAX mainnet
    ReservoirPair internal _stablePair = ReservoirPair(0x146D00567Cef404c1c0aAF1dfD2abEa9F260B8C7);
    address internal _oracleCaller = 0x00A4784E29dB2B1d5e061b4F12aC635Bb910f237;
    address internal _avaxUsdChainlinkPricefeed = 0x0A77230d17318075983913bC2145DB16C7366156;

    function setUp() public {
        vm.createSelectFork(getChain("avalanche").rpcUrl);
        vm.startPrank(_oracleCaller);
    }

    function testRead4Times() external view {
        for (uint index = 0; index < 4; ++index) {
            _stablePair.observation(index);
        }
    }

    function testRead16Times() public view returns (Observation memory rPrev, Observation memory rNext) {
        for (uint index = 0; index < 14; ++index) {
            _stablePair.observation(index);
        }
        rPrev = _stablePair.observation(14);
        rNext = _stablePair.observation(15);
    }

    function testRead16Times_WithCalculation() external view {
        (Observation memory lPrev, Observation memory lNext) = testRead16Times();
        int256 lPriceAccDiff = lNext.logAccRawPrice - lPrev.logAccRawPrice;
        uint256 lTimeDiff = lNext.timestamp - lPrev.timestamp;

        uint256 lAvgPrice = LogCompression.fromLowResLog(lPriceAccDiff / int256(lTimeDiff));
    }

    function testReadChainlink() external view {

    }
}
