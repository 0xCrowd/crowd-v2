pragma solidity ^0.8.4;
import "../IExtension.sol";
import "../IProposal.sol";
import "../IWorker.sol";
import "../INonFungible.sol";

contract NftGifter is IExtension {

    Worker public gift_worker = Worker(
        "Gift NFT",                                             // title
        "Transfers your NFT to the Vault. Just a demo worker",  // description
        new string[](2),                                        // params_types (address, uint256, uint256)
        new string[](2)                                         // params_names (NFT address, NFT id, funds to collect (should cover the price))
    );

    uint256 constant private workersCount_ = 1;
    uint[workersCount_] moduleWorkers;

    constructor() {
        gift_worker.params_types[0] = "address";
        gift_worker.params_types[1] = "uint256";

        gift_worker.params_names[0] = "Collection address";
        gift_worker.params_names[1] = "Item ID";
    }

    function name() external pure override returns (string memory) {
        return "NFT Gifter";
    }

    function proposalsCount() external pure override returns (uint256) {
        return 0;
    }

    function workersCount() external view override returns (uint256) {
        return workersCount_;
    }

    function getProposalTypes(uint256 proposal_id) external view override returns (Proposal memory) {
        Proposal memory empty;
        return empty;
    }

    function getProposal(uint256 proposal_id) external view override returns (Proposal memory) {
        Proposal memory empty;
        return empty;
    }

    function getWorkerTypes(uint256 worker_id) external virtual view override returns (Worker memory) {
        require(worker_id == 0, "NftGifter: unexisted worker");
        return gift_worker;
    }

    function execute(address caller, address target, uint256 worker_id, bytes memory data) external override {
        require(worker_id == 0, "NftGifter: attempt to run an unexisted worker");
        address collection;
        uint256 id;
        (collection, id) = abi.decode(data, (address, uint256));
        INonFungible asset = INonFungible(collection);
        asset.safeTransferFrom(caller, target, id);
    }

}
