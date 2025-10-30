// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract LiquiditySurgeTrap is ITrap {
    address public constant TOKEN = 0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1;
    address public constant POOL  = 0x0000000000000000000000000000000000000000;

    struct CollectOutput {
        uint256 tokenBalance;
    }

    constructor() {}

    function collect() external view override returns (bytes memory) {
        uint256 bal = IERC20(TOKEN).balanceOf(POOL);
        return abi.encode(CollectOutput({tokenBalance: bal}));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
        if (past.tokenBalance == 0) return (false, bytes(""));
        uint256 increase = (current.tokenBalance - past.tokenBalance);
        if (increase > 1e18) return (true, bytes(""));
        return (false, bytes(""));
    }
}
