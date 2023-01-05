// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./DRExToken.sol";

interface IUpdateBalance {
    function update_nft_balance(uint256 amount) external;
}

contract AssetManagement is ERC721URIStorage {
    // enum Breed {
    //     DREX1
    // }
    IERC20 public _drexToken;
    IERC20 private _daiTokens;
    mapping(uint256 => address) public requestIdToSender;
    mapping(uint256 => string) public requestIdToTokenURI;
    // mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(uint256 => uint256) public requestIdToTokenId;
    mapping(address => uint256[]) public tokenToOwner;
    // mapping(uint256 => uint256) public participationValue;
    mapping(address => uint256) public ownerToValue;
    mapping(uint256 => uint256) public tokenidToValue;
    mapping(address => bool) public Wallets;
    address[] public previousContracts;

    //events
    event Create_Bond(uint256 indexed requestId);
    event Claim(address _destAddr, uint256 _amount);
    event Update_Balance(uint256 amount);
    event Mint(uint256 indexed requestId);

    uint256 public totalTokensTransferred; //amount of drex tokens transfered till date
    uint256 public tokenCounter;
    // uint256 public fParticipation;
    uint256 public RequestId; //hardcoded value
    // uint256 public randomNumber; //harcoded value
    address public admin;
    uint256 public nftCount;
    uint256 public sendAmount;
    uint256 public tokenId;

    // uint256 public curr_balance_for_each_token;

    constructor(
        IERC20 drex_token_address,
        IERC20 dai_token_address,
        address[] memory prevContracts,
        uint256 nft_Count
    ) public ERC721("DREX", "DRx") {
        admin = msg.sender;
        previousContracts = prevContracts;
        _drexToken = drex_token_address;
        _daiTokens = dai_token_address;
        RequestId = 1;
        tokenCounter = 0;
        totalTokensTransferred = 0;
        nftCount = nft_Count;
        sendAmount = 0;
        // curr_balance_for_each_token = 0;
    }

    ///remove the random number
    /// @notice Creates the nft
    /// @param  tokenURI -> the token uri of the each nft, it can be empty also
    function create_bond(string memory tokenURI) public payable {
        require(
            _daiTokens.balanceOf(msg.sender) > 50000,
            "balance not enought to mint nft"
        );
        _daiTokens.transferFrom(msg.sender, address(this), 50000);
        uint256 requestId = RequestId; //requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        mint(requestId);
        RequestId = RequestId + 1;
        // randomNumber = randomNumber + 1;
        emit Create_Bond(requestId);
    }

    /// @notice Used to set each of the user who have bought the nft
    /// @param _wallet -> address of tge nft holder
    /// makes this function private
    function setWallet(address _wallet) private {
        Wallets[_wallet] = true;
    }

    /// @notice Helper fucntion called by create_nft, calls the 'safemint fucntion'
    /// @param requestId -->a uint256 number unique for each nft

    /// this should be a internal function
    function mint(uint256 requestId) internal {
        address DrexOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(admin, newItemId);
        //_setTokenURI(newItemId, tokenURI);
        setWallet(DrexOwner);
        // Breed breed = Breed(RandomNumber % 1);
        // tokenIdToBreed[newItemId] = breed;
        requestIdToTokenId[requestId] = newItemId;

        tokenToOwner[DrexOwner].push(newItemId);
        tokenCounter = tokenCounter + 1;
        emit Mint(requestId);
    }

    ///@notice Sets tokenURI for each nft minted
    /// @param tokenId --> a tokenId of each of the nft
    /// @param _tokenURI --> string which refers the tokenuri for the nft
    /// make it an internal function
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    //correct this functions --> find new function for each contract
    // function participationCalculation() public {
    //     require(previousContracts.length > 0, "this is the first contract");

    //     //needs another check to remove the first contract after 25 years or after 25 contracts have been created

    //     uint256 totalContracts = previousContracts.length + 1;
    //     uint256 totalNfts = totalContracts * nft_count; //no of nfts per collection is a variable and find a way to make it variable
    //     uint256 fEmission = nft_count / totalNfts; //decide how to deal with floating points --> need to be different for each collection
    //     uint256 fYear = 1 / totalContracts;
    //     fParticipation = (fEmission + fYear) / 2;
    // }

    // function participationReturns() public {
    //     uint256 erc20balance = _token.balanceOf(address(this));
    //     require(
    //         _token.balanceOf(address(this)) > 100,
    //         "balance not sufficient"
    //     );
    //     uint256 costTosend = (erc20balance * fParticipation) / 100;
    //     for (uint256 holder = 0; holder < previousContracts.length; holder++) {
    //         address to = previousContracts[holder];
    //         _token.transfer(to, costTosend);
    //         erc20balance -= costTosend;
    //         // event for transfering funds from token pool to particular contract
    //         emit CLAIM(to, costTosend);
    //     }
    // }

    /// @notice Divides the amount generated in each of the nft holders
    /// @param amount --> amount generated and transfered to the contract
    function update_nft_balance(uint256 amount) external {
        uint256 curr_balance_for_each_token = amount / (nftCount);
        for (uint256 token_id = 0; token_id < nftCount; token_id++) {
            tokenidToValue[token_id] += curr_balance_for_each_token;
        }
        emit Update_Balance(amount);
    }

    ///@notice This function calculates the total drex tokens for each of the msg.sender
    ///@param nft_holder --> address of the nft holder

    function get_total_drex(address nft_holder) public view returns (uint256) {
        uint256 amount_total = 0;
        for (uint32 i = 0; i < tokenToOwner[nft_holder].length; i++) {
            amount_total += tokenidToValue[tokenToOwner[nft_holder][i]];
        }
        return amount_total;
    }

    /// @notice NFt holder claims there drexTokens to stable coins using this function
    function claim() public {
        require(Wallets[msg.sender] == true, "sender dont hold a nft");
        // token_Id = tokenToOwner[msg.sender];
        address rec = (msg.sender);
        sendAmount = get_total_drex(msg.sender);
        _drexToken.approve(address(this), sendAmount);
        _drexToken.transferFrom(address(this), address(msg.sender), sendAmount);
        for (uint32 i = 0; i < tokenToOwner[msg.sender].length; i++) {
            tokenidToValue[tokenToOwner[msg.sender][i]] = 0;
        }
        emit Claim(msg.sender, sendAmount);
    }
}
