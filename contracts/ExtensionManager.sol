pragma solidity ^0.8.4;
import "./IProposal.sol";
import "./ExtensionInterfaces.sol";

interface IBalanceOf {
    function balanceOf(address) external;
}

contract ExtensionManager {

    struct Extension {
        uint256 id;
        string  name;
        address extension_address;
        uint256 proposals_count;
        uint256 workers_count;
    }

    mapping(address => address) dao2token; // ERC20 representation of DAO's voting power

    mapping(address =>
        mapping(uint256 =>
            mapping(uint256 => bool)
        )
    ) dao_workers; // DAO => Extension Module ID => Worker ID => active?

    mapping(uint256 => address) extension_registry; // Extension Module ID => Extension Module address
    uint256 public extensions_total;

    mapping(string => bool) supported_proposal_types;
    address owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerModule(address module) public { // ToDo onlyOwner
        // ToDo require() extension doesn't exist
        extension_registry[extensions_total] = module;
        extensions_total += 1;
    }

    function getExtension(uint256 extension_id) public view returns (Extension memory) {
        address extension_address = extension_registry[extension_id];
        IExtension extension = IExtension(extension_address);

        return Extension (
            extension_id,
            extension.name(),
            extension_address,
            extension.proposalsCount(),
            extension.workersCount()
        );
    }

}
