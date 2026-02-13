# 🛡️ Sentinel-X Vault (Blockchain Layer)

The **Sentinel-X Vault** is an immutable registry deployed on the **Sepolia Testnet**. It acts as the "Root of Trust" for application distribution.

## Why Blockchain?
Traditional servers can be compromised. If a hacker replaces our APK on the server with malware, the **Hash (CID)** will not match the immutable record on the blockchain. The client app verifies this hash before allowing any download.

## Smart Contract Details
- **Contract Name:** `SentinelVault.sol`
- **Network:** Ethereum Sepolia
- **Language:** Solidity ^0.8.0
- **Key Features:**
  - `publishRelease()`: Admin-only function to anchor new builds.
  - `getLatestRelease()`: Public function for client verification.
  - **Audit Trail:** All updates emit `ReleasePublished` events for transparency.

## Deployment
Deployed via Remix IDE & MetaMask.