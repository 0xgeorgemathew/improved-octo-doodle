// SPDX-License-Identifier: MIT
// Import the required Superfluid and Solidity contract interfaces
import "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperToken.sol";
import "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// Set up the contract
contract AdStream {
    // Define the Superfluid contracts
    ISuperfluid private _superfluid;
    IConstantFlowAgreementV1 private _cfa;
    ISuperToken private _acceptedToken;
 bytes32 private _adStreamId;

    // Define the constructor
    constructor(
        address superfluidHost,
        address cfaAddress,
        address acceptedToken
    ) {
        // Set up the Superfluid contracts
        _superfluid = ISuperfluid(superfluidHost);
        _cfa = IConstantFlowAgreementV1(cfaAddress);
        _acceptedToken = ISuperToken(acceptedToken);
    }
    // Create a new stream for the ad
    function createStream(uint256 flowRate) public {
        // Approve the token for the Superfluid contract
        _acceptedToken.approve(address(_cfa), flowRate);

