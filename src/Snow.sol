// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 *  ░▒▓███████▓▒░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 * ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 * ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 *  ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 *        ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 *        ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░
 * ░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░ ░▒▓█████████████▓▒░
 */
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Snow is ERC20, Ownable {
    using SafeERC20 for IERC20;

    // >>> ERROR
    error S__NotAllowed();
    error S__ZeroAddress();
    error S__ZeroValue();
    error S__Timer();
    error S__SnowFarmingOver();

    // >>> VARIABLES
    address private s_collector;
    uint256 private s_earnTimer;
    uint256 public s_buyFee;
    uint256 private immutable i_farmingOver;

    IERC20 i_weth;

    uint256 constant PRECISION = 10 ** 18;
    uint256 constant FARMING_DURATION = 12 weeks;

    // >>> EVENTS
    event SnowBought(address indexed buyer, uint256 indexed amount);
    event SnowEarned(address indexed earner, uint256 indexed amount);
    event FeeCollected();
    event NewCollector(address indexed newCollector);

    // >>> MODIFIERS
    modifier onlyCollector() {
        if (msg.sender != s_collector) {
            revert S__NotAllowed();
        }
        _;
    }

    modifier canFarmSnow() {
        if (block.timestamp >= i_farmingOver) {
            revert S__SnowFarmingOver();
        }
        _;
    }

    // >>> CONSTRUCTOR
    constructor(address _weth, uint256 _buyFee, address _collector) ERC20("Snow", "S") Ownable(msg.sender) {
        if (_weth == address(0)) {
            revert S__ZeroAddress();
        }
        if (_buyFee == 0) {
            revert S__ZeroValue();
        }
        if (_collector == address(0)) {
            revert S__ZeroAddress();
        }

        i_weth = IERC20(_weth);
        s_buyFee = _buyFee * PRECISION;
        s_collector = _collector;
        i_farmingOver = block.timestamp + FARMING_DURATION; // Snow farming eands 12 weeks after deployment
    }

    // >>> EXTERNAL FUNCTIONS
    function buySnow(uint256 amount) external payable canFarmSnow {
        if (msg.value == (s_buyFee * amount)) {
            _mint(msg.sender, amount);
        } else {
            i_weth.safeTransferFrom(msg.sender, address(this), (s_buyFee * amount));
            _mint(msg.sender, amount);
        }

        s_earnTimer = block.timestamp;

        emit SnowBought(msg.sender, amount);
    }

    function earnSnow() external canFarmSnow {
        if (s_earnTimer != 0 && block.timestamp < (s_earnTimer + 1 weeks)) {
            revert S__Timer();
        }
        _mint(msg.sender, 1);

        s_earnTimer = block.timestamp;
    }

    function collectFee() external onlyCollector {
        uint256 collection = i_weth.balanceOf(address(this));
        i_weth.transfer(s_collector, collection);

        (bool collected,) = payable(s_collector).call{value: address(this).balance}("");
        require(collected, "Fee collection failed!!!");
    }

    function changeCollector(address _newCollector) external onlyCollector {
        if (_newCollector == address(0)) {
            revert S__ZeroAddress();
        }

        s_collector = _newCollector;

        emit NewCollector(_newCollector);
    }

    // >>> GETTER FUNCTIONS
    function getCollector() external view returns (address) {
        return s_collector;
    }
}
