pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ContextTester {

    constructor() {}

    address public _contextSender;
    address public _actualSender;
    address public _operator;

    function context() internal returns (address) {
        return msg.sender;
    }

    function transferplz(
        address item
    ) public {

    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes   calldata data
    ) external returns (bytes4) {

        _operator = operator;
        _contextSender = context();
        _actualSender = msg.sender;

        return this.onERC721Received.selector;
    }

}
