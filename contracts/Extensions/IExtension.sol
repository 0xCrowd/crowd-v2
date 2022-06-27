pragma solidity ^0.8.4;
import "./IProposal.sol";
import "./IWorker.sol";

interface IExtension {

    function name() external pure returns (string memory);

    function execute(address caller, address target, uint256 worker, bytes memory data) external;

    function workersCount() external view returns (uint256);

    function proposalsCount() external view returns (uint256);

    function getProposal(uint256) external view returns (Proposal memory);

    function getProposalTypes(uint256) external view returns (Proposal memory);

    function getWorkerTypes(uint256 proposal_id) external view returns (Worker memory);

}
