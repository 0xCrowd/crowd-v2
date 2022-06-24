pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MockNFT is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Crowd Logo", "CROWD") {}

    function awardItem(address recipient, address redirect)
    public
    returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);

        safeTransferFrom(recipient, redirect, newItemId);

        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return "https://lh3.google.com/u/0/d/1K3EkdAiFj9XZbwRp_HrJBGWX1BeXFYOj=w2880-h1642-iv1";
    }

}
