pragma solidity ^0.8.4;
import "../IProposal.sol";

contract LooksRareBuyout {

    Proposal public buyout_proposal = Proposal(
        "fundraising",                      // type
        "Buyout",                           // title
        "Buy an NFT at LooksRare exchange", // description
        ProposalStatus.INACTIVE,             // status
        false,                              // closed
        new string[](0),                    // options
        new string[](3),                    // params_types (address, uint256, uint256)
        new string[](3),                    // params_names (NFT address, NFT id, funds to collect (should cover the price))
        0
    );

    constructor() {
        buyout_proposal.params_types[0] = "address";
        buyout_proposal.params_types[1] = "uint256";
        buyout_proposal.params_types[2] = "uint256";

        buyout_proposal.params_names[0] = "Collection address";
        buyout_proposal.params_names[1] = "Item ID";
        buyout_proposal.params_names[2] = "Amount to collect";
    }

    function execute_buyout(bytes memory) internal {}
}
