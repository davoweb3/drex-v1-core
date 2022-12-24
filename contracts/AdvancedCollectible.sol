// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Our_ERC20.sol";

interface Nft_interface {
    function update_nft_balance(uint256 amount) external;
}

contract AdvancedCollectible is ERC721URIStorage {
    enum Breed {
        DREX1
    }
    // add other things
    address public _token;
    IERC20 private _daiTokens;
    mapping(uint256 => address) public requestIdToSender;
    mapping(uint256 => string) public requestIdToTokenURI;
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(uint256 => uint256) public requestIdToTokenId;
    mapping(address => uint256) public tokenToOwner;
    mapping(uint256 => uint256) public participationValue;
    mapping(address => uint256) public ownerToValue;
    mapping(uint256 => uint256) public tokenidToValue;
    mapping(address => bool) public Wallets;
    address[] public previousContracts;

    //events
    event CREATE_NFT(uint256 indexed requestId);
    event CLAIM(address _destAddr, uint256 _amount);
    event UPDATE_NFT_BALANCE(uint256 amount);
    event MINT(uint256 indexed requestId, uint256 randomNumber);

    uint256 public totalTokenTransfered; //amount of drex tokens transfered till date
    uint256 public tokenCounter;
    uint256 public fParticipation;
    uint256 public RequestId; //hardcoded value
    uint256 public randomNumber; //harcoded value
    address public Admin;
    uint256 public nft_count;
    uint256 public amount_to_send;
    uint256 public token_Id;

    // uint256 public curr_balance_for_each_token;

    constructor(
        address erc_token_address,
        IERC20 dai_token_address,
        address[] memory prevContracts,
        uint256 no_of_nfts
    ) public ERC721("DREX", "DRx") {
        Admin = msg.sender;
        previousContracts = prevContracts;
        _token = erc_token_address;
        _daiTokens = dai_token_address;
        RequestId = 1;
        randomNumber = 10;
        tokenCounter = 0;
        totalTokenTransfered = 0;
        nft_count = no_of_nfts;
        amount_to_send = 0;
        // curr_balance_for_each_token = 0;
    }

    /// @notice Creates the nft
    /// @param  tokenURI -> the token uri of the each nft, it can be empty also
    function create_nft(string memory tokenURI) public payable {
        require(
            _daiTokens.balanceOf(msg.sender) > 50000,
            "balance not enought to mint nft"
        );
        _daiTokens.transferFrom(msg.sender, address(this), 50000);
        uint256 requestId = RequestId; //requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        mint(requestId, randomNumber);
        RequestId = RequestId + 1;
        randomNumber = randomNumber + 1;
        emit CREATE_NFT(requestId);
    }

    /// @notice Used to set each of the user who have bought the nft
    /// @param _wallet -> address of tge nft holder
    function setWallet(address _wallet) public {
        Wallets[_wallet] = true;
    }

    /// @notice Helper fucntion called by create_nft, calls the 'safemint fucntion'
    /// @param requestId -->a uint256 number unique for each nft
    /// @param RandomNumber -->  a uint256 number for each of the nft
    function mint(uint256 requestId, uint256 RandomNumber) public {
        address DrexOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(Admin, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setWallet(DrexOwner);
        Breed breed = Breed(RandomNumber % 1);
        tokenIdToBreed[newItemId] = breed;
        requestIdToTokenId[requestId] = newItemId;

        // bug in the tokenToowner Mapping , have to fix it

        tokenToOwner[DrexOwner] = newItemId;
        tokenCounter = tokenCounter + 1;
        emit MINT(requestId, RandomNumber);
    }

    ///@notice Sets tokenURI for each nft minted
    /// @param tokenId --> a tokenId of each of the nft
    /// @param _tokenURI --> string which refers the tokenuri for the nft
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    //correct this functions --> find new function for each contract
    function participationCalculation() public {
        require(previousContracts.length > 0, "this is the first contract");

        //needs another check to remove the first contract after 25 years or after 25 contracts have been created

        uint256 totalContracts = previousContracts.length + 1;
        uint256 totalNfts = totalContracts * nft_count; //no of nfts per collection is a variable and find a way to make it variable
        uint256 fEmission = nft_count / totalNfts; //decide how to deal with floating points --> need to be different for each collection
        uint256 fYear = 1 / totalContracts;
        fParticipation = (fEmission + fYear) / 2;
    }

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
        uint256 curr_balance_for_each_token = amount / (nft_count);
        for (uint256 token_id = 0; token_id < nft_count; token_id++) {
            tokenidToValue[token_id] += curr_balance_for_each_token;
        }
        emit UPDATE_NFT_BALANCE(amount);
    }

    /// @notice NFt holder claims there drexTokens to stable coins using this function
    function claim() public {
        require(Wallets[msg.sender] == true, "sender dont hold a nft");
        token_Id = tokenToOwner[msg.sender];
        address rec = payable(msg.sender);
        amount_to_send = (tokenidToValue[token_Id]);
        drex_token_interface erc20 = drex_token_interface(_token);
        erc20.tranferingfunds(payable(rec), amount_to_send);
        emit CLAIM(msg.sender, amount_to_send);
    }
}
