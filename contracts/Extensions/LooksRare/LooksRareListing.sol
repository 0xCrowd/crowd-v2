pragma solidity ^0.8.4;
import "../IProposal.sol";

contract LooksRareListing {

    Proposal public listing_proposal = Proposal(
        "worker",                           // type
        "Listing",                          // title
        "Sell item via LooksRare exchange", // description ("for / against / etc.")
        ProposalStatus.INACTIVE,            // status
        false,                              // closed
        new string[](2),                    // options ()
        new string[](3),                    // params types (address, uint256, uint256)
        new string[](3),                    // params_names(NFT address, NFT id, listing price)
        0
    );

    constructor() {
        listing_proposal.options[0] = "for";
        listing_proposal.options[1] = "against";

        listing_proposal.params_types[0] = "address";
        listing_proposal.params_types[1] = "uint256";
        listing_proposal.params_types[2] = "uint256";

        listing_proposal.params_names[0] = "Collection address";
        listing_proposal.params_names[1] = "Item ID";
        listing_proposal.params_names[2] = "Listing Price";
    }

//    function execute_listing(bytes memory) internal override {}
//
//    function getListingProposal() external override returns (Proposal memory) {
//        return proposal;
//    }
}
