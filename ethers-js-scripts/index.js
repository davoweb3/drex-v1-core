const ethers = require('ethers')
const provider = new ethers.providers.JsonRpcProvider('https://moonbeam-alpha.api.onfinality.io/public');
//parsing the files and getting the abis

var fs = require('fs');
var parsed= JSON.parse(fs.readFileSync('./contracts/AdvancedCollectible.json'));
var nft_abi = parsed.abi;


//abi for advanced collectible

const NFT_CONTRACT_ADDRESS = '0xa62D32475E30E9e4072707c9c5A07eE51b443040'
const accountFrom = {
    address: '0xD2D49002Ec4cDD56FC064450a5749f4Da1fBA61c',
    privateKey: '4c80e8f3a4809d21957c92466c5d42cd00cbd41726093ce9e8c6fa1bc82002db',
};


const nft_contract = new ethers.Contract(NFT_CONTRACT_ADDRESS,nft_abi,provider)
// console.log(nft_contract)
const nft_main = async () => {
    const balance = await nft_contract.totalTokenTransfered();
    console.log(balance)
}
nft_main()


var parsed= JSON.parse(fs.readFileSync('./contracts/DRExToken.json'));
var drex_abi = parsed.abi;

const DREX_TOKEN_CONTRACT = "0x26d37a3276AF83eEB4576C27Ecc3ef1864964E11" // TODO: will need to update this token address later
const tokenHolder = "0xD2D49002Ec4cDD56FC064450a5749f4Da1fBA61c" // TODO: add Metamask wallet connect here to get user address

const contract = new ethers.Contract(DREX_TOKEN_CONTRACT,drex_abi,provider)
// console.log(contract)
const main = async () => {
    const balance = await contract.totalTokenSupplied();
    console.log(ethers.utils.formatEther(balance))
}
