// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SentinelVault {
    
    // --- Structs ---
    struct AppRelease {
        string version;      
        string ipfsCid;      
        string checksum;     // <--- ADDED: The SHA-256 hash of the APK file
        string releaseNotes; 
        uint256 timestamp;   
    }

    // --- State Variables ---
    address public admin;             
    AppRelease[] public releaseHistory; 

    // --- Events ---
    // Update event to include the checksum so external tools can see it
    event ReleasePublished(string indexed version, string ipfsCid, string checksum, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Security Alert: Unauthorized Access Attempt");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Publish a new verified APK version with integrity check.
     */
    function publishRelease(
        string memory _version, 
        string memory _cid, 
        string memory _checksum, // <--- ADDED: Argument for the hash
        string memory _notes
    ) public onlyAdmin {
        AppRelease memory newRelease = AppRelease({
            version: _version,
            ipfsCid: _cid,
            checksum: _checksum, // <--- ADDED: Store the hash
            releaseNotes: _notes,
            timestamp: block.timestamp
        });

        releaseHistory.push(newRelease);
        
        // Emit the checksum in the event
        emit ReleasePublished(_version, _cid, _checksum, block.timestamp);
    }

    /**
     * @notice Fetches the latest release details including the checksum.
     */
    function getLatestRelease() public view returns (
        string memory version, 
        string memory cid, 
        string memory checksum // <--- ADDED: Return the hash
    ) {
        require(releaseHistory.length > 0, "No releases published yet");
        
        AppRelease memory latest = releaseHistory[releaseHistory.length - 1];
        return (latest.version, latest.ipfsCid, latest.checksum);
    }
}