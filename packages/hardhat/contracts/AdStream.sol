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

        // Create a new stream with the specified flow rate
        (, int96 superflowRate, , ) = _cfa.createFlow(
            _acceptedToken,
            address(this),
            flowRate,
            new bytes(0)
        );

        // Store the stream ID for later use
        _adStreamId = _superfluid.getFlowID(
            address(_acceptedToken),
            address(this),
            _cfa.agreements(address(this)),
            _adStreamId
        );
    }

    // Get the current flow rate for the ad stream
    function getCurrentFlowRate() public view returns (uint256) {
        // Get the current flow rate for the stream
        (, int96 flowRate, , ) = _cfa.getFlow(
            address(_acceptedToken),
            address(this),
            _cfa.agreements(address(this)),
            _adStreamId
        );

        // Convert the flow rate to an unsigned integer
        return uint256(flowRate);
    }
}
