pragma solidity ^0.8.4;
import "../IExtension.sol";
import "../IProposal.sol";
import "./LooksRareBuyout.sol";
import "./LooksRareListing.sol";
import "../IWorker.sol";

contract LooksRare is IExtension, LooksRareBuyout, LooksRareListing {

    uint256 constant private proposalsCount_ = 2;
    Proposal[proposalsCount_] moduleProposals;

//    uint256 constant private workersCount_ = 0;
//    uint[workersCount_] moduleWorkers;

    constructor() LooksRareBuyout() {}

    function name() external pure override returns (string memory) {
        return "LooksRare Marketplace";
    }

    function proposalsCount() external view override returns (uint256) {
        return proposalsCount_;
    }

    function workersCount() external view override returns (uint256) {
//        return workersCount_;
        return 0;
    }

    function execute(address caller, address target, uint256 worker_id, bytes memory data) external override {

    }

    function getProposalTypes(uint256 proposal_id) external view override returns (Proposal memory) {
        require(proposal_id < proposalsCount_);
        if (proposal_id == 0) {
            return buyout_proposal;
        }
        return listing_proposal;
    }

    // ToDo getWorkerTypes, no need to getWorker - they're one-shots

    function getProposal(uint256 proposal_id) external view override returns (Proposal memory) {
        return moduleProposals[proposal_id];
    }

    function getWorkerTypes(uint256 proposal_id) external virtual view override returns (Worker memory) {
        Worker memory empty;
        return empty;
    }
}
