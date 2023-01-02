from brownie import accounts, network, config, AdvancedCollectible, DRExToken
from scripts.helpful_script import fund_advanced_collectible

from dotenv import load_dotenv
import os
import time


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    erc20Token = DRExToken.deploy(
        {"from": dev},
    )

    time.sleep(0.1)
    erc20Token.setAddress(erc20Token, {"from": dev})
