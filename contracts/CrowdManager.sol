pragma solidity ^0.8.4;
import "./Vault.sol";

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}

contract CrowdManager {

    struct Crowd {
        uint256 id;
        string  title;
        address extensionManager;
        CrowdVault vault;
        address creator;
    }

    uint256 private total_crowds;
    mapping(string => Crowd) title_to_crowd;
    mapping(uint256 => Crowd) id_to_crowd;
    mapping(uint256 => address) id_to_token;

    constructor() {}

    function getCrowd(uint256 crowd_id) public view returns (Crowd memory) {
        require(crowd_id > 0 && crowd_id <= total_crowds, "Crowd: Crowd doesn't exist");
        return id_to_crowd[crowd_id];
    }

    function totalCrowds() public view returns (uint256) {
        return total_crowds;
    }

    function newCrowd(string memory title, address extension_manager) public {
        require(title_to_crowd[title].id == 0, "Crowd: Crowd with that title already exists");
        total_crowds++;
        CrowdVault vault = new CrowdVault(extension_manager);
        Crowd memory crowd = Crowd(total_crowds, title, extension_manager, vault, msg.sender);
        title_to_crowd[title] = crowd;
        id_to_crowd[total_crowds] = crowd;
    }

    function isMember(address user, uint crowd_id) public view returns (bool) {
        address governance_token_address = id_to_token[crowd_id];
        if (governance_token_address == address(0)) {
            if (user == id_to_crowd[crowd_id].creator) return true;
            return false;
        }

        if (IERC20(governance_token_address).balanceOf(user) > 0) return true;
        return false;
    }

}
