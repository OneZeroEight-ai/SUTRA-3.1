// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract AlignmentToken is ERC20Burnable, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    address public alignmentMetricsAddress;
    
    event AlignmentMetricsAddressUpdated(address indexed previousAddress, address indexed newAddress);
    event TokensMinted(address indexed to, uint256 amount, string reason);
    event TokensBurned(address indexed from, uint256 amount, string reason);
    
    constructor(
        string memory name,
        string memory symbol,
        address initialAdmin
    ) ERC20(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(ADMIN_ROLE, initialAdmin);
        _grantRole(MINTER_ROLE, initialAdmin);
        _grantRole(BURNER_ROLE, initialAdmin);
    }
    
    function setAlignmentMetricsAddress(address _alignmentMetricsAddress) external onlyRole(ADMIN_ROLE) {
        emit AlignmentMetricsAddressUpdated(alignmentMetricsAddress, _alignmentMetricsAddress);
        alignmentMetricsAddress = _alignmentMetricsAddress;
    }
    
    function mint(address to, uint256 amount, string memory reason) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
        emit TokensMinted(to, amount, reason);
    }
    
    function burnFrom(address from, uint256 amount, string memory reason) external onlyRole(BURNER_ROLE) {
        _burn(from, amount);
        emit TokensBurned(from, amount, reason);
    }
    
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._update(from, to, amount);
        
        if (from != address(0) && to != address(0) && alignmentMetricsAddress != address(0)) {
            (bool success, ) = alignmentMetricsAddress.call(
                abi.encodeWithSignature("updateMetricsOnTransfer(address,address,uint256)", from, to, amount)
            );
        }
    }
}