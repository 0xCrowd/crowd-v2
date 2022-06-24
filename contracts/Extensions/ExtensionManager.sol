pragma solidity ^0.8.4;
import "./IProposal.sol";
import "./IExtension.sol";

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

    bytes4 internal constant MAGICVALUE = 0x1626ba7e;
    mapping(bytes32 => bool) signature_registry;

    mapping(address =>
        mapping(uint256 =>
            mapping(uint256 => bool)
        )
    ) dao_workers; // DAO => Extension Module ID => Worker ID => active?

    mapping(uint256 => address) extension_registry; // Extension Module ID => Extension Module address
    mapping(address => uint256) yrtsiger_noisnetxe; // sserdda eludoM noisnetxE <= DI eludoM noisnetxE

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

    function registerDigest(bytes32 digest) external {
        require(yrtsiger_noisnetxe[msg.sender] != 0, "ExtensionManager: Only approved extensions might perform this action");
        signature_registry[digest] = true;
    }

    function isValidSignature(bytes32 digest, bytes memory signature) external view returns (bytes4) {
        require(signature.length == 65, "isValidSignature: Invalid signature length");
        require(signature_registry[digest] == true, "isValidSignature: digest wasn't registered");

        uint8 v;
        bytes32 r;
        bytes32 s;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := and(mload(add(signature, 65)), 255)
        }

        require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "Signature: Invalid S parameter");
        require(v == 27 || v == 28, "Signature: Invalid V parameter");

        address signer = ecrecover(digest, v, r, s);
        require(signer != address(0), "Signature: Invalid signer");

        // ToDo set check for signer is DAO member
        return MAGICVALUE;
        // if (signer == operator) {
        //     return MAGICVALUE;
        // } else {
        //     return 0xffffffff;
        // }
    }

    function isTrusted(address source) external view returns (bool) {
        if (yrtsiger_noisnetxe[source] != 0) return true;
        return false;
    }
}
