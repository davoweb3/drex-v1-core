from brownie import accounts, network, config, AdvancedCollectible, DRExToken, DaiToken
from scripts.helpful_script import fund_advanced_collectible

from dotenv import load_dotenv
import os
import time


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    dai = DaiToken.deploy(
        578960446186589,
        {"from": dev},
    )

    time.sleep(0.1)
    print("dai tokens have been minted")
