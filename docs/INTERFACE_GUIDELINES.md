# SUTRA 3.2 Interface Guidelines

## Interface Design Principles

1. **Explicit Boundaries**
   - Interfaces should clearly define component boundaries
   - All interactions between components must go through interfaces

2. **Comprehensive Events**
   - Every state change should emit an appropriate event
   - Events should contain all relevant information about the change

3. **Access Control**
   - Functions should have explicit access control requirements
   - Interfaces should indicate which roles can call which functions

4. **Return Values**
   - Functions should return meaningful values indicating success/failure
   - Return values should be consistent across similar functions

5. **Error Handling**
   - Use custom errors rather than revert strings
   - Error messages should be descriptive and helpful

## Interface Naming Conventions

1. **Interface Names**
   - Prefix with "I" (e.g., `IAlignmentRegistry`)
   - Use PascalCase for interface names

2. **Function Names**
   - Use camelCase for function names
   - Start with a verb (get, set, update, calculate, is, has, etc.)
   - Be descriptive about what the function does

3. **Event Names**
   - Use PascalCase for event names
   - Name should indicate what happened (e.g., `ScoreUpdated`)
   - Past tense for state changes

4. **Parameter Names**
   - Use camelCase for parameter names
   - Be descriptive about what the parameter represents
   - Avoid abbreviations unless widely understood

## Documentation Standards

1. **NatSpec Comments**
   - All interfaces must have NatSpec documentation
   - Include `@title`, `@dev`, `@param`, and `@return` tags
   - Describe what the function does, not how it does it

2. **Function Documentation**
   - Describe the purpose of the function
   - Document all parameters and return values
   - Include any constraints or requirements

3. **Event Documentation**
   - Describe when the event is emitted
   - Document the meaning of each parameter
   - Explain how to interpret the event data

## Implementation Requirements

1. **Interface Conformance**
   - Implementations must conform exactly to interfaces
   - Function signatures must match precisely
   - Return types must be compatible

2. **Gas Optimization**
   - Consider gas costs in interface design
   - Balance between functionality and efficiency
   - Document gas considerations for complex operations

3. **Upgradeability**
   - Design interfaces with future upgrades in mind
   - Avoid tight coupling between components
   - Consider using proxy patterns for upgradeable contracts

4. **Security**
   - Follow security best practices
   - Include access control in interface design
   - Consider potential attack vectors

## Code Style

1. **Solidity Version**
   - Use Solidity ^0.8.17 for all contracts
   - Lock pragma to specific version

2. **Imports**
   - Import interfaces directly
   - Use relative paths for local imports
   - Use package paths for external imports

3. **Formatting**
   - Use 4 spaces for indentation
   - Maximum line length of 100 characters
   - Braces on same line as control statements

4. **Comments**
   - Use `//` for single-line comments
   - Use `/* */` for multi-line comments
   - Comment complex logic and business rules

## Interface Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title IExampleInterface
 * @dev Example interface demonstrating the expected format and style
 */
interface IExampleInterface {
    /**
     * @dev Emitted when an example action occurs
     * @param user The address performing the action
     * @param value The value associated with the action
     */
    event ExampleAction(address indexed user, uint256 value);
    
    /**
     * @dev Performs an example action
     * @param value The value to use for the action
     * @return success True if the action was successful
     */
    function performAction(uint256 value) external returns (bool success);
    
    /**
     * @dev Gets the result of a previous action
     * @param user The address of the user
     * @return result The result of the action
     */
    function getActionResult(address user) external view returns (uint256 result);
}
```

## Interface Review Checklist

Before finalizing an interface, ensure:
- [ ] All functions have NatSpec documentation
- [ ] All events are properly documented
- [ ] Function names follow conventions
- [ ] Parameter names are descriptive
- [ ] Return values are meaningful
- [ ] Access control is considered
- [ ] Gas efficiency is considered
- [ ] Upgradeability is considered
- [ ] Security considerations are addressed
