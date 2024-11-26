// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "risc0/contracts/IRiscZeroVerifier.sol";

contract VillageUnknown is Ownable {
    struct Village {
        uint8 x;
        uint8 y;
        uint8 villageType; // 0: small, 1: medium, 2: large
        uint256 elixir;
        uint256 defense;
        address owner;
        bool isRevealed;
    }

    struct Player {
        bool registered;
        uint256 villagesOwned;
    }

    uint8 private constant MAP_SIZE = 10; // 10x10 grid for 100 villages
    uint8 private constant MAX_PLAYERS = 9;
    uint256 private constant ELIXIR_SEND_LIMIT = 80; // 80% max of current elixir

    mapping(uint8 => mapping(uint8 => Village)) private gameMap;
    mapping(address => Player) private players;
    uint8 public currentPlayerCount;
    
    IRiscZeroVerifier public verifier;
    bytes32 public immutable GUEST_IMAGE_ID;

    event PlayerRegistered(address indexed player);
    event ActionVerified(address player, bool success);
    event VillageConquered(uint8 x, uint8 y);
    event VillageReinforced(uint8 x, uint8 y);

    constructor(address _verifier, bytes32 _imageId) {
        verifier = IRiscZeroVerifier(_verifier);
        GUEST_IMAGE_ID = _imageId;
        initializeMap();
    }

    function joinGame() external {
        require(!players[msg.sender].registered, "Already registered");
        require(currentPlayerCount < MAX_PLAYERS, "Game full");
        
        players[msg.sender].registered = true;
        currentPlayerCount++;
        
        // TODO: Assign random large village
        assignStartingVillage(msg.sender);
        emit PlayerRegistered(msg.sender);
    }

    function performAction(
        bytes calldata journal,
        bytes32 postStateDigest,
        bytes calldata seal,
        uint8 actionType,
        uint8 fromX,
        uint8 fromY,
        uint8 toX,
        uint8 toY,
        uint256 elixirAmount
    ) external {
        require(players[msg.sender].registered, "Not a player");
        
        bytes memory input = abi.encode(
            msg.sender,
            actionType,
            fromX,
            fromY,
            toX,
            toY,
            elixirAmount,
            gameMap[fromX][fromY],
            gameMap[toX][toY]
        );

        verifier.verify(
            GUEST_IMAGE_ID,
            input,
            journal,
            postStateDigest,
            seal
        );

        if (actionType == 0) { // TODO: Implement Conquer
            executeConquer(fromX, fromY, toX, toY, elixirAmount);
        } else { // TODO: Implement Reinforce
            executeReinforce(fromX, fromY, toX, toY, elixirAmount);
        }

        emit ActionVerified(msg.sender, true);
    }

    function getVillageInfo(uint8 x, uint8 y) external view returns (Village memory) {
        require(isVillageVisible(msg.sender, x, y), "Village not visible");
        return gameMap[x][y];
    }

    function isVillageVisible(address player, uint8 x, uint8 y) internal view returns (bool) {
        // Check if village is adjacent to any of player's villages
        for (uint8 i = 0; i < MAP_SIZE; i++) {
            for (uint8 j = 0; j < MAP_SIZE; j++) {
                if (gameMap[i][j].owner == player) {
                    if (isAdjacent(i, j, x, y)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    // Private helper functions
    function initializeMap() private {
        // Initialize 100 villages with random types and positions
        for (uint8 x = 0; x < MAP_SIZE; x++) {
            for (uint8 y = 0; y < MAP_SIZE; y++) {
                uint8 vType = uint8(uint256(keccak256(abi.encodePacked(x, y))) % 3);
                uint256 baseElixir = getBaseElixir(vType);
                uint256 baseDefense = getBaseDefense(vType);
                
                gameMap[x][y] = Village({
                    x: x,
                    y: y,
                    villageType: vType,
                    elixir: baseElixir,
                    defense: baseDefense,
                    owner: address(0),
                    isRevealed: false
                });
            }
        }
    }

    function getBaseElixir(uint8 vType) private pure returns (uint256) {
        if (vType == 0) return 1000; // small
        if (vType == 1) return 2000; // medium
        return 3000; // large
    }

    function getBaseDefense(uint8 vType) private pure returns (uint256) {
        if (vType == 0) return 100; // small
        if (vType == 1) return 200; // medium
        return 300; // large
    }

    function isAdjacent(uint8 x1, uint8 y1, uint8 x2, uint8 y2) private pure returns (bool) {
        return (
            (x1 == x2 && (y1 == y2 + 1 || y1 == y2 - 1)) ||
            (y1 == y2 && (x1 == x2 + 1 || x1 == x2 - 1))
        );
    }
}
