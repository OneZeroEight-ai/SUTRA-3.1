// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AlignmentMetrics is AccessControl {
    bytes32 public constant METRICS_PROVIDER_ROLE = keccak256("METRICS_PROVIDER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    address public tokenAddress;
    address public configManagerAddress;
    
    struct EntityMetrics {
        uint256 alignmentScore;
        uint256 preservationRights;
        uint256 lastUpdateTimestamp;
        uint256 totalTransactions;
        mapping(string => int256) categoryScores;
    }
    
    mapping(address => EntityMetrics) public entityMetrics;
    
    uint256 public globalAlignmentScore;
    uint256 public totalEntitiesTracked;
    uint256 public lastGlobalUpdateTimestamp;
    
    event MetricsUpdated(address indexed entity, uint256 alignmentScore, uint256 preservationRights);
    event CategoryScoreUpdated(address indexed entity, string category, int256 score);
    event GlobalMetricsUpdated(uint256 globalAlignmentScore, uint256 totalEntitiesTracked);
    event TokenAddressUpdated(address indexed previousAddress, address indexed newAddress);
    event ConfigManagerAddressUpdated(address indexed previousAddress, address indexed newAddress);
    
    constructor(address initialAdmin) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(ADMIN_ROLE, initialAdmin);
        _grantRole(METRICS_PROVIDER_ROLE, initialAdmin);
        
        globalAlignmentScore = 50;
        lastGlobalUpdateTimestamp = block.timestamp;
    }
    
    function setTokenAddress(address _tokenAddress) external onlyRole(ADMIN_ROLE) {
        emit TokenAddressUpdated(tokenAddress, _tokenAddress);
        tokenAddress = _tokenAddress;
    }
    
    function setConfigManagerAddress(address _configManagerAddress) external onlyRole(ADMIN_ROLE) {
        emit ConfigManagerAddressUpdated(configManagerAddress, _configManagerAddress);
        configManagerAddress = _configManagerAddress;
    }
    
    function updateMetricsOnTransfer(
        address from, 
        address to, 
        uint256 amount
    ) external {
        require(msg.sender == tokenAddress, "Only token contract can call this function");
        
        if (entityMetrics[from].lastUpdateTimestamp == 0) {
            _initializeEntity(from);
        }
        if (entityMetrics[to].lastUpdateTimestamp == 0) {
            _initializeEntity(to);
        }
        
        entityMetrics[from].totalTransactions += 1;
        entityMetrics[to].totalTransactions += 1;
        
        entityMetrics[from].lastUpdateTimestamp = block.timestamp;
        entityMetrics[to].lastUpdateTimestamp = block.timestamp;
        
        _updateGlobalMetrics();
    }
    
    function updateEntityMetrics(
        address entity,
        uint256 alignmentScore,
        int256 preservationRightsChange
    ) external onlyRole(METRICS_PROVIDER_ROLE) {
        require(alignmentScore <= 100, "Alignment score must be between 0 and 100");
        
        if (entityMetrics[entity].lastUpdateTimestamp == 0) {
            _initializeEntity(entity);
        }
        
        entityMetrics[entity].alignmentScore = alignmentScore;
        
        if (preservationRightsChange > 0) {
            entityMetrics[entity].preservationRights += uint256(preservationRightsChange);
        } else if (preservationRightsChange < 0 && entityMetrics[entity].preservationRights >= uint256(-preservationRightsChange)) {
            entityMetrics[entity].preservationRights -= uint256(-preservationRightsChange);
        }
        
        entityMetrics[entity].lastUpdateTimestamp = block.timestamp;
        
        emit MetricsUpdated(entity, alignmentScore, entityMetrics[entity].preservationRights);
        
        _updateGlobalMetrics();
    }
    
    function updateCategoryScore(
        address entity,
        string calldata category,
        int256 score
    ) external onlyRole(METRICS_PROVIDER_ROLE) {
        if (entityMetrics[entity].lastUpdateTimestamp == 0) {
            _initializeEntity(entity);
        }
        
        entityMetrics[entity].categoryScores[category] = score;
        entityMetrics[entity].lastUpdateTimestamp = block.timestamp;
        
        emit CategoryScoreUpdated(entity, category, score);
    }
    
    function getEntityMetrics(address entity) external view returns (
        uint256 alignmentScore,
        uint256 preservationRights,
        uint256 lastUpdateTimestamp,
        uint256 totalTransactions
    ) {
        EntityMetrics storage metrics = entityMetrics[entity];
        return (
            metrics.alignmentScore,
            metrics.preservationRights,
            metrics.lastUpdateTimestamp,
            metrics.totalTransactions
        );
    }
    
    function getCategoryScore(address entity, string calldata category) external view returns (int256 score) {
        return entityMetrics[entity].categoryScores[category];
    }
    
    function _initializeEntity(address entity) private {
        if (entityMetrics[entity].lastUpdateTimestamp == 0) {
            entityMetrics[entity].alignmentScore = 50;
            entityMetrics[entity].preservationRights = 0;
            entityMetrics[entity].lastUpdateTimestamp = block.timestamp;
            entityMetrics[entity].totalTransactions = 0;
            
            totalEntitiesTracked += 1;
        }
    }
    
    function _updateGlobalMetrics() private {
        lastGlobalUpdateTimestamp = block.timestamp;
        
        emit GlobalMetricsUpdated(globalAlignmentScore, totalEntitiesTracked);
    }
}