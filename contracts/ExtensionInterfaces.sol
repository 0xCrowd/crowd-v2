pragma solidity ^0.8.4;
import "./IProposal.sol";

interface IExtension {

    function name() external pure returns (string memory);

    function execute(bytes memory) external;

    function workersCount() external view returns (uint256);

    function proposalsCount() external view returns (uint256);

    function getProposal(uint256) external view returns (Proposal memory);

    function getProposalTypes(uint256) external view returns (Proposal memory);

}
