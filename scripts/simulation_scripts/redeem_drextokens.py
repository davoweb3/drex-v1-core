from brownie import accounts, network, config, AdvancedCollectible, DRExToken, Client
from scripts.helpful_script import fund_advanced_collectible
from dotenv import load_dotenv
import os
import time

nft_contract = AdvancedCollectible[-1]
drex_token = DRExToken[-1]


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print("user redeming drex tokens")

    # check whether there are sufficient drex tokens in the nft contract to transfer it to the user
    token_id = nft_contract.tokenToOwner(dev)
    value = nft_contract.tokenidToValue(token_id)
    print(value)
    # nft_contract.approve_erc_20(dev, (value * 10**19), {"from": dev})
    # print(drex_token.allowance(nft_contract, dev))
    # time.sleep(10)
    nft_contract.claim({"from": dev})
