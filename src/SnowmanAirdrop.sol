// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 *  ░▒▓███████▓▒░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████████████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░        ░▒▓██████▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░
 * ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
 * ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
 *  ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░
 *        ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
 *        ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
 * ░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░ ░▒▓█████████████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░
 */
import {Snowman} from "./Snowman.sol";
import {Snow} from "./Snow.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title Snowman Airdrop
 * @author Chukwubuike Victory Chime @yeahChibyke (Github and Twitter)
 * @notice This contract handles the distribution of Snowman NFTs via a Merkle Tree-based airdrop
 */
contract SnowmanAirdrop is EIP712, ReentrancyGuard {
    using SafeERC20 for Snow;

    // >>> ERRORS
    error SA__InvalidProof(); // Thrown when the provided Merkle proof is invalid
    error SA__InvalidSignature(); // Thrown when the provided ECDSA signature is invalid
    error SA__ZeroAddress();
    error SA__ZeroAmount();

    // >>> TYPE
    struct SnowmanClaim {
        address receiver;
        uint256 amount;
    }

    // >>> VARIABLES
    address[] private s_claimers; // array to store addresses of claimers
    bytes32 private immutable i_merkleRoot; // Merkle root used to validate airdrop claims
    Snow private immutable i_snow; // Snow token to be staked for the airdrop
    Snowman private immutable i_snowman; // Snowman nft to be claimed

    mapping(address => bool) private s_hasClaimedSnowman; // mapping to verify if an address has claimed Snowman

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("SnowmanClaim(addres receiver, uint256 amount)"); // keccak256 hash of the SnowmanClaim struct's type signature, used for EIP-712 compliant message signing

    // >>> EVENTS
    event SnowmanClaimedSuccessfully(address receiver, uint256 amount); // emitted when a Snowman is claimed successfully

    // >>> CONSTRUCTOR
    constructor(bytes32 _merkleRoot, address _snow, address _snowman) EIP712("Snowman Airdrop", "1") {
        if (_snow == address(0)) {
            revert SA__ZeroAddress();
        }
        if (_snowman == address(0)) {
            revert SA__ZeroAddress();
        }

        i_merkleRoot = _merkleRoot;
        i_snow = Snow(_snow);
        i_snowman = Snowman(_snowman);
    }

    // >>> EXTERNAL FUNCTIONS
    function claimSnowman(address receiver, bytes32[] calldata merkleProof, uint8 v, bytes32 r, bytes32 s)
        external
        nonReentrant
    {
        if (receiver == address(0)) {
            revert SA__ZeroAddress();
        }
        if (i_snow.balanceOf(receiver) == 0) {
            revert SA__ZeroAmount();
        }

        if (!_isValidSignature(receiver, getMessageHash(receiver), v, r, s)) {
            revert SA__InvalidSignature();
        }

        uint256 amount = i_snow.balanceOf(receiver);

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(receiver, amount))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert SA__InvalidProof();
        }

        i_snow.safeTransferFrom(receiver, address(this), amount); // send tokens to contract... akin to burning

        s_hasClaimedSnowman[receiver] = true;

        emit SnowmanClaimedSuccessfully(receiver, amount);

        i_snowman.mintSnowman(receiver, amount);
    }

    // >>> INTERNAL FUNCTIONS
    function _isValidSignature(address receiver, bytes32 digest, uint8 v, bytes32 r, bytes32 s)
        internal
        pure
        returns (bool)
    {
        (address actualSigner,,) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == receiver;
    }

    // >>> PUBLIC VIEW FUNCTIONS
    function getMessageHash(address receiver) public view returns (bytes32) {
        if (i_snow.balanceOf(receiver) == 0) {
            revert SA__ZeroAmount();
        }

        uint256 amount = i_snow.balanceOf(receiver);

        return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, SnowmanClaim({receiver: receiver, amount: amount})))
        );
    }

    // >>> GETTER FUNCTIONS
    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getSnowAddress() external view returns (address) {
        return address(i_snow);
    }

    function getSnowmanAddress() external view returns (address) {
        return address(i_snowman);
    }

    function getClaimStatus(address claimant) external view returns (bool) {
        return s_hasClaimedSnowman[claimant];
    }
}
