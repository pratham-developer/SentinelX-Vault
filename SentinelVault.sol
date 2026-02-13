// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Sentinel-X Vault (Secure App Registry)
 * @author Sentinel-X Security Team
 * @notice This contract serves as the "Source of Truth" for the Sentinel-X Android App.
 * @dev It stores an immutable history of app versions and their IPFS hashes to prevent supply chain attacks.
 */
contract SentinelVault {
    
    // --- Structs ---
    struct AppRelease {
        string version;      // e.g., "v1.0.2"
        string ipfsCid;      // The unique IPFS Content Identifier
        string releaseNotes; // Brief description (e.g., "Critical Hotfix")
        uint256 timestamp;   // When it was published
    }

    // --- State Variables ---
    address public admin;             // The deployer/owner
    AppRelease[] public releaseHistory; // Array of all past versions

    // --- Events (For Blockchain Explorers) ---
    // These allow external tools to track updates in real-time
    event ReleasePublished(string indexed version, string ipfsCid, uint256 timestamp);

    // --- Modifiers ---
    modifier onlyAdmin() {
        require(msg.sender == admin, "Security Alert: Unauthorized Access Attempt");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Publish a new verified APK version to the blockchain.
     * @dev Only the admin can call this. Emits a ReleasePublished event.
     */
    function publishRelease(
        string memory _version, 
        string memory _cid, 
        string memory _notes
    ) public onlyAdmin {
        AppRelease memory newRelease = AppRelease({
            version: _version,
            ipfsCid: _cid,
            releaseNotes: _notes,
            timestamp: block.timestamp
        });

        releaseHistory.push(newRelease);
        
        emit ReleasePublished(_version, _cid, block.timestamp);
    }

    /**
     * @notice Fetches the latest verified release details.
     */
    function getLatestRelease() public view returns (string memory version, string memory cid) {
        require(releaseHistory.length > 0, "No releases published yet");
        
        AppRelease memory latest = releaseHistory[releaseHistory.length - 1];
        return (latest.version, latest.ipfsCid);
    }
}