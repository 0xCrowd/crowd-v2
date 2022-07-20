pragma solidity ^0.8.4;

import "./Fundraising.sol";

interface IApprovable {
    function approve(address, uint256) external;
    function setApprovalForAll(address, bool) external;
}

interface IValidator {
    function isValidSignature(bytes32, bytes memory) external view returns (bytes4);
    function isTrusted(address) external view returns (bool);
}

contract CrowdVault {

    IValidator operator;

    constructor(address _operator) {
        operator = IValidator(_operator);
//        shared_fundraising = _shared_fundraising;
    }

    function grantAllowanceNonFungible(address asset_operator, address asset) external {
        require(operator.isTrusted(msg.sender), "CrowdVault: msg.sender is not trusted");
        IApprovable(asset).setApprovalForAll(asset_operator, true);
    }

    function grantAllowanceERC20(address asset_operator, address asset, uint amount) external {
        require(operator.isTrusted(msg.sender), "CrowdVault: msg.sender is not trusted");
        IApprovable(asset).approve(asset_operator, amount);
    }

    function isValidSignature(bytes32 digest, bytes memory signature) external view returns (bytes4) {
        return operator.isValidSignature(digest, signature);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes   calldata data
    ) external returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
