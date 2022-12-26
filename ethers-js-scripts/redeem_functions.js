const ethers = require('ethers')
const provider = new ethers.providers.JsonRpcProvider('https://moonbeam-alpha.api.onfinality.io/public')
const axios = require('axios')
var fs = require('fs');

//abis for each of the smart contracts
var nft_parsed= JSON.parse(fs.readFileSync('./contracts/AdvancedCollectible.json'));
var nft_abi = nft_parsed.abi;
var parsed= JSON.parse(fs.readFileSync('./contracts/DrexTreasury.json'));
var treasury_abi = parsed.abi;
var stable_parsed= JSON.parse(fs.readFileSync('./contracts/DRExStable.json'));
var stable_abi = stable_parsed.abi;
var parsed= JSON.parse(fs.readFileSync('./contracts/DRExToken.json'));
var drex_abi = parsed.abi;
var dai_parsed = JSON.parse(fs.readFileSync('./contracts/DaiToken.json'));
var dai_abi = dai_parsed.abi



//deploying contracts using ethers 

const DREX_TOKEN_CONTRACT = "0x7621005DD5Db3073968Df0Ee469e6f148960D6b0" // TODO: will need to update this token address later
const drex_treasury = "0x9C4611bF1f8D1e8DEC4B8Ec75D75D84f648d0D3d"
const NFT_CONTRACT_ADDRESS = '0x085b046b7528d8bc42354412df372ff2d261ce3c'
const drex_stable_coin = "0xf1CaC41C01477723f2F9473Ff60ad7cCB5Bdd4a5"
const dai_tokens = "0x268a20877F514015C2a7bf6Ca4147e9DF42ff3CB"
const nft_contract = new ethers.Contract(NFT_CONTRACT_ADDRESS,nft_abi,provider)
const drex_stable_contract = new ethers.Contract(drex_stable_coin,stable_abi,provider)
const treasury_contract = new ethers.Contract(drex_treasury,treasury_abi,provider)
const drex_contract = new ethers.Contract(DREX_TOKEN_CONTRACT,drex_abi,provider)
const dai_contract = new ethers.Contract(dai_tokens,dai_abi,provider)

//public addr and private key for making calls

const accountFrom = {
    address: '0xDcC33A14c3c52A0aD25C783C5f03052bBa78507b',
    privateKey: '6c1ab2f5134f68a2e3a904fe2827eb2d339200b86b15fafb3e354fe9149af4ba',
};


const wallet =new ethers.Wallet(accountFrom["privateKey"],provider)


const get_balance = async (wallet_addr) => {
    const balance = await drex_contract.balanceOf(wallet_addr)
    console.log(ethers.utils.formatEther(balance))
    return balance 
}  
// get_balance("0xDcC33A14c3c52A0aD25C783C5f03052bBa78507b")

///@notice -> this fucntion sets the token uri for the nft
/// @param -> unique token_id and string token_uri for each nft
const setTokenURI = async (token_id,token_uri) => {
    const connectwallet = nft_contract.connect(wallet)
    const setting_token_uri = await connectwallet.setTokenURI(token_id,token_uri)
    console.log(setting_token_uri)
}


///@notice -> this function mints the nft from nft_contract
///@param amount --> amount required to mint the nft
const create_nft = async (amount) => {
    const connectwallet = nft_contract.connect(wallet)
    const token_id = await nft_contract.tokenCounter()
    const approve_dai = await approve_dai_tokens(amount)
    const minting_nft = await connectwallet.create_nft("")
    // .then(() => setTokenURI(token_id,""))
    console.log(minting_nft)

}
create_nft(500000)

const dai_balance = async (wallet_addr) => {
    const balance = await dai_contract.balanceOf(wallet_addr)
    console.log(ethers.utils.formatEther(balance))
    console.log(balance)
    return balance 

}
dai_balance("0xDcC33A14c3c52A0aD25C783C5f03052bBa78507b")


///@notice function for redeeming drex Tokens
const redeem_drex_token = async () => {
    const connectwallet = nft_contract.connect(wallet)
    const get_drex = await connectwallet.claim()
    console.log(get_drex)
}


///@notice function for approving drex stable coins
///@param amount -> the amount of token to approve
const approve_tokens_stable_coins = async (amount) => {
    const connectwallet = drex_stable_contract.connect(wallet)
    const approved = await connectwallet.approve(treasury_contract.address,amount)
    console.log(approved)
}

///@notice function for approving drex tokens
///@param amount -> the amount of token to approve
const approve_tokens_drex_tokens = async (amount) => {
    const connectwallet = drex_contract.connect(wallet)
    const approved = await connectwallet.approve(accountFrom["address"],amount)
    console.log(approved)
}
///@notice function for approving dai coins
///@param amount -> the amount of dai token to approve
const approve_dai_tokens = async (amount) => {
    const connectwallet = dai_contract.connect(wallet)
    const approved = await connectwallet.approve(accountFrom["address"],amount)
    console.log(approved)
}

///@notice  This function is used by smes to send the stable coins
///@param amount -> amount of stable coins to send 
const pay_fees_smes = async (amount) => {
    const connectwallet = treasury_contract.connect(wallet)
    const x = await approve_tokens_stable_coins(amount * 10 ** 18
        ).then(() => connectwallet.pay_fees(amount))

    console.log(x)
}

///@notice This function is used to convert the drex tokens to stable coins

const redemption = async () => {
    const user_drex_amount = await drex_contract.balanceOf(accountFrom["address"])
    const connectwallet = treasury_contract.connect(wallet)
    const x = await approve_tokens_drex_tokens(user_drex_amount
        ).then(() => connectwallet.redeem())
    console.log(x)
}

