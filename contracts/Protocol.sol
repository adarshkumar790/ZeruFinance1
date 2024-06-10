// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interfaces for ChainLink and Uniswap
interface IChainLink {
    function latestAnswer() external view returns (int256);
}

interface IUniswapV3Pool {
    function slot0() external view returns (
        uint160 sqrtPriceX96,
        int24 tick,
        uint16 observationIndex,
        uint16 observationCardinality,
        uint16 observationCardinalityNext,
        uint8 feeProtocol,
        bool unlocked
    );
}

interface IUniswapV3Router {
    function exactInputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        address recipient,
        uint256 deadline,
        uint256 amountIn,
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountOut);
}

contract Protocol {
    IChainLink public chainlinkARB;
    IChainLink public chainlinkUSDC;
    IUniswapV3Pool public uniswapV3Pool;
    IUniswapV3Router public uniswapV3Router;

    address public tokenARB;
    address public tokenUSDC;

    constructor(
        address _chainlinkARB,
        address _chainlinkUSDC,
        address _uniswapV3Pool,
        address _uniswapV3Router,
        address _tokenARB,
        address _tokenUSDC
    ) {
        chainlinkARB = IChainLink(_chainlinkARB);
        chainlinkUSDC = IChainLink(_chainlinkUSDC);
        uniswapV3Pool = IUniswapV3Pool(_uniswapV3Pool);
        uniswapV3Router = IUniswapV3Router(_uniswapV3Router);
        tokenARB = _tokenARB;
        tokenUSDC = _tokenUSDC;
    }

    function getChainlinkPriceARB() public view returns (int256) {
        return chainlinkARB.latestAnswer();
    }

    function getChainlinkPriceUSDC() public view returns (int256) {
        return chainlinkUSDC.latestAnswer();
    }

    function getUniswapPriceARB() public view returns (uint256) {
        (uint160 sqrtPriceX96,, , , , ,) = uniswapV3Pool.slot0();
        uint256 priceX96 = uint256(sqrtPriceX96) * uint256(sqrtPriceX96);
        uint256 price = priceX96 / (2 ** 192);
        return price;
    }

    function swapARBTokens(uint256 amount, uint256 deadline) external {
        int256 chainlinkPriceARB = getChainlinkPriceARB();
        int256 chainlinkPriceUSDC = getChainlinkPriceUSDC();
        uint256 uniswapPriceARB = getUniswapPriceARB();

        require(chainlinkPriceARB > 0 && chainlinkPriceUSDC > 0, "Invalid ChainLink price");

        uint256 chainlinkExchangeRate = uint256(chainlinkPriceARB) * 1e18 / uint256(chainlinkPriceUSDC);

        require(
            uniswapPriceARB >= chainlinkExchangeRate * 99 / 100 && 
            uniswapPriceARB <= chainlinkExchangeRate * 101 / 100, 
            "Price discrepancy detected"
        );

        
        uint256 amountOutMinimum = (amount * uniswapPriceARB * 99) / 100; 
        uniswapV3Router.exactInputSingle(
            tokenARB,
            tokenUSDC,
            3000, 
            msg.sender,
            deadline,
            amount,
            amountOutMinimum,
            0
        );
    }
}
