interface INonFungible {
    function approve(address, uint256) external;
    function safeTransferFrom(address, address, uint256) external;
    function balanceOf(address) external view returns (uint256);
    function ownerOf(uint256) external view returns (address);
    function name() external view returns (string memory);
    function tokenURI(uint256) external view returns (string memory);
}