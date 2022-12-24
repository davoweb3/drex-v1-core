from brownie import AdvancedCollectible, accounts, network, config
from metadata import sample_metadata
from scripts.helpful_script import get_breed


drex_meta_dic = {
    "DREX1": "https://ipfs.io/ipfs/QmPSvV47hgs8PcfjzUdDfgga5dwQCLA5N9zSP8bxCB7RtA?filename=0-DREX1.json",
    "DREX3": "https://ipfs.io/ipfs/QmWDZd4V3VigGJfNCPzMaMwCn1N2QMtuVaRpKR7kGkLpsL?filename=0-DREX1.json",
    "DREX2": "https://ipfs.io/ipfs/QmWDZd4V3VigGJfNCPzMaMwCn1N2QMtuVaRpKR7kGkLpsL?filename=0-DREX1.json",
}

OPENSEA_FORMAT = "https://testnets.opensea.io/assests/rinkeby/{}/{}"


def main():
    print("Working on " + network.show_active())
    advanced_collectible = AdvancedCollectible[len(AdvancedCollectible) - 1]
    number_of_advanced_collectibles = advanced_collectible.tokenCounter()
    print(
        "The number of tokens you've deployed is: "
        + str(number_of_advanced_collectibles)
    )
    for token_id in range(number_of_advanced_collectibles):
        breed = get_breed(advanced_collectible.tokenIdToBreed(token_id))
        if not advanced_collectible.tokenURI(token_id).startswith("https://"):
            print("Setting tokenURI of {}".format(token_id))
            set_tokenURI(token_id, advanced_collectible, drex_meta_dic[breed])
        else:
            print("Skipping {}, we already set that tokenURI!".format(token_id))


def set_tokenURI(token_id, nft_contract, tokenURI):
    dev = accounts.add(config["wallets"]["from_key"])
    nft_contract.setTokenURI(token_id, tokenURI, {"from": dev})
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(nft_contract.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button')
