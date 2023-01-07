from brownie import accounts, network, config, AdvancedCollectible, DRExToken, Client
from scripts.helpful_script import fund_advanced_collectible
from dotenv import load_dotenv
import os
import time

erc20 = DRExToken[-1]
contract_to_transfer = AdvancedCollectible[-1]
client = Client[-1]


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    contract_to_transfer.update_nft_balance(1000, {"from": dev})
