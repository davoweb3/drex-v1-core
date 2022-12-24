const ethers = require('ethers')
const provider = new ethers.providers.JsonRpcProvider('https://moonbeam-alpha.api.onfinality.io/public');
//parsing the files and getting the abis
const axios = require('axios')


var fs = require('fs');
var parsed= JSON.parse(fs.readFileSync('./contracts/AdvancedCollectible.json'));
var nft_abi = parsed.abi;

const NFT_CONTRACT_ADDRESS = '0xB5281093357BD22f3AeFe91e391f894b272acd78'

const accountFrom = {
    address: '0xD2D49002Ec4cDD56FC064450a5749f4Da1fBA61c',
    privateKey: '4c80e8f3a4809d21957c92466c5d42cd00cbd41726093ce9e8c6fa1bc82002db',
};

const nft_contract = new ethers.Contract(NFT_CONTRACT_ADDRESS,nft_abi,provider)

///@notice This fucntions prints the total drex coins transfered from erc20 contract to nfts 
///@return balance transfered
const get_total_drex_transfered = async () => {
    const balance = await nft_contract.totalTokenTransfered();
    console.log(ethers.utils.formatEther(balance))
    return balance
}

/// @notice -> function to get the token uri for each token
///@param token_id -> 
const get_token_uri = async (token_id) => {
    const uri = await nft_contract.tokenURI(token_id);
    // console.log(uri);
    return uri
}

const uriData = async () => {

    const link = await  get_token_uri(6)
    
    axios.get(link)
    .then(res => console.log(res.data))
    .catch(err => console.log(err));
}



