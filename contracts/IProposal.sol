pragma solidity ^0.8.4;

enum ProposalStatus{ INACTIVE, CREATED, ACTIVE, FAILED, PASSED, EXECUTED }
struct Proposal {
    string          proposal_type; // Used by frontend to properly render proposal
    string          title;
    string          description;
    ProposalStatus  status;
    bool            active;

    string[]        options;
    string[]        params_types;
    string[]        params_names;

    uint256         requiredQuorum;
}

struct Vote {
    uint256     option_id;
    bytes[]     params;
}
