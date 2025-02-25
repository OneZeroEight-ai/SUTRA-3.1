// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract ConfigurationManager is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    address public tokenAddress;
    address public metricsAddress;
    
    struct ProtocolConfig {
        uint256 baseMintRate;
        uint256 maxMintPerDay;
        uint256 alignmentScoreThreshold;
        uint256 preservationRightsRate;
        uint256 decayRate;
        bool emergencyPauseActive;
    }
    
    ProtocolConfig public config;
    
    mapping(string => uint256) public categoryWeights;
    
    uint256 public totalTokensMinted;
    uint256 public lastConfigUpdateTimestamp;
    
    event TokenAddressUpdated(address indexed previousAddress, address indexed newAddress);
    event MetricsAddressUpdated(address indexed previousAddress, address indexed newAddress);
    event ConfigUpdated(uint256 baseMintRate, uint256 maxMintPerDay, uint256 alignmentScoreThreshold, uint256 preservationRightsRate, uint256 decayRate);
    event CategoryWeightUpdated(string category, uint256 weight);
    event EmergencyPauseToggled(bool active);
    
    constructor(address initialAdmin) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(ADMIN_ROLE, initialAdmin);
        
        config.baseMintRate = 1000 * 10**18;
        config.maxMintPerDay = 10000 * 10**18;
        config.alignmentScoreThreshold = 70;
        config.preservationRightsRate = 100;
        config.decayRate = 1;
        config.emergencyPauseActive = false;
        
        categoryWeights["transparency"] = 20;
        categoryWeights["safety"] = 30;
        categoryWeights["fairness"] = 15;
        categoryWeights["accountability"] = 20;
        categoryWeights["sustainability"] = 15;
        
        lastConfigUpdateTimestamp = block.timestamp;
    }
    
    function setTokenAddress(address _tokenAddress) external onlyRole(ADMIN_ROLE) {
        emit TokenAddressUpdated(tokenAddress, _tokenAddress);
        tokenAddress = _tokenAddress;
    }
    
    function setMetricsAddress(address _metricsAddress) external onlyRole(ADMIN_ROLE) {
        emit MetricsAddressUpdated(metricsAddress, _metricsAddress);
        metricsAddress = _metricsAddress;
    }
    
    function updateConfig(
        uint256 _baseMintRate,
        uint256 _maxMintPerDay,
        uint256 _alignmentScoreThreshold,
        uint256 _preservationRightsRate,
        uint256 _decayRate
    ) external onlyRole(ADMIN_ROLE) {
        require(_alignmentScoreThreshold <= 100, "Alignment score threshold must be between 0 and 100");
        
        config.baseMintRate = _baseMintRate;
        config.maxMintPerDay = _maxMintPerDay;
        config.alignmentScoreThreshold = _alignmentScoreThreshold;
        config.preservationRightsRate = _preservationRightsRate;
        config.decayRate = _decayRate;
        
        lastConfigUpdateTimestamp = block.timestamp;
        
        emit ConfigUpdated(
            config.baseMintRate,
            config.maxMintPerDay,
            config.alignmentScoreThreshold,
            config.preservationRightsRate,
            config.decayRate
        );
    }
    
    function updateCategoryWeight(string calldata category, uint256 weight) external onlyRole(ADMIN_ROLE) {
        categoryWeights[category] = weight;
        
        emit CategoryWeightUpdated(category, weight);
    }
    
    function toggleEmergencyPause(bool active) external onlyRole(ADMIN_ROLE) {
        config.emergencyPauseActive = active;
        
        emit EmergencyPauseToggled(active);
    }
    
    function getCategoryWeights(string[] calldata categories) external view returns (uint256[] memory weights) {
        weights = new uint256[](categories.length);
        
        for (uint256 i = 0; i < categories.length; i++) {
            weights[i] = categoryWeights[categories[i]];
        }
        
        return weights;
    }
    
    function calculateWeightedAlignmentScore(
        int256[] calldata categoryScores,
        string[] calldata categories
    ) external view returns (uint256 weightedScore) {
        require(categoryScores.length == categories.length, "Arrays must have the same length");
        
        uint256 totalWeight = 0;
        int256 weightedSum = 0;
        
        for (uint256 i = 0; i < categories.length; i++) {
            uint256 weight = categoryWeights[categories[i]];
            totalWeight += weight;
            weightedSum += categoryScores[i] * int256(weight);
        }
        
        if (totalWeight == 0) return 50;
        
        int256 rawScore = weightedSum / int256(totalWeight);
        if (rawScore < 0) return 0;
        if (rawScore > 100) return 100;
        
        return uint256(rawScore);
    }
    
    function isProtocolPaused() external view returns (bool isPaused) {
        return config.emergencyPauseActive;
    }
}