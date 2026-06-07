// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract CoalCoin is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {

    uint256 public immutable maxSupply;
    bytes32 public merkleRoot;
    uint256 public mintPrice;
    bool    public publicSaleActive;
    uint256 public whitelistMaxMint;

    mapping(address => bool) public whitelistClaimed;

    event MerkleRootUpdated(bytes32 indexed oldRoot, bytes32 indexed newRoot);
    event WhitelistMinted(address indexed user, uint256 amount);
    event PublicMinted(address indexed user, uint256 amount);
    event PublicSaleToggled(bool active);
    event Withdrawn(address indexed to, uint256 amount);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        bytes32 merkleRoot_,
        uint256 mintPrice_,
        uint256 whitelistMaxMint_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {
        require(maxSupply_ > 0, "CoalCoin: maxSupply must be > 0");
        maxSupply        = maxSupply_;
        merkleRoot       = merkleRoot_;
        mintPrice        = mintPrice_;
        whitelistMaxMint = whitelistMaxMint_;
    }

    function whitelistMint(
        uint256 amount,
        bytes32[] calldata proof
    ) external payable nonReentrant {
        require(!whitelistClaimed[msg.sender],          "CoalCoin: already claimed");
        require(amount > 0 && amount <= whitelistMaxMint, "CoalCoin: invalid amount");
        require(totalSupply() + amount * 1e18 <= maxSupply, "CoalCoin: exceeds maxSupply");
        require(msg.value >= mintPrice * amount,         "CoalCoin: insufficient ETH");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "CoalCoin: invalid proof");

        whitelistClaimed[msg.sender] = true;
        _mint(msg.sender, amount * 1e18);
        emit WhitelistMinted(msg.sender, amount);

        uint256 excess = msg.value - mintPrice * amount;
        if (excess > 0) {
            (bool ok, ) = payable(msg.sender).call{value: excess}("");
            require(ok, "CoalCoin: refund failed");
        }
    }

    function publicMint(uint256 amount) external payable nonReentrant {
        require(publicSaleActive, "CoalCoin: public sale not active");
        require(amount > 0, "CoalCoin: amount must be > 0");
        require(totalSupply() + amount * 1e18 <= maxSupply, "CoalCoin: exceeds maxSupply");
        require(msg.value >= mintPrice * amount, "CoalCoin: insufficient ETH");

        _mint(msg.sender, amount * 1e18);
        emit PublicMinted(msg.sender, amount);

        uint256 excess = msg.value - mintPrice * amount;
        if (excess > 0) {
            (bool ok, ) = payable(msg.sender).call{value: excess}("");
            require(ok, "CoalCoin: refund failed");
        }
    }

    function ownerMint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "CoalCoin: exceeds maxSupply");
        _mint(to, amount);
    }

    function setMerkleRoot(bytes32 newRoot) external onlyOwner {
        emit MerkleRootUpdated(merkleRoot, newRoot);
        merkleRoot = newRoot;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function togglePublicSale() external onlyOwner {
        publicSaleActive = !publicSaleActive;
        emit PublicSaleToggled(publicSaleActive);
    }

    function withdraw() external onlyOwner nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "CoalCoin: nothing to withdraw");
        (bool ok, ) = payable(owner()).call{value: balance}("");
        require(ok, "CoalCoin: withdraw failed");
        emit Withdrawn(owner(), balance);
    }

    function isWhitelisted(
        address account,
        bytes32[] calldata proof
    ) external view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(account));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }
}
