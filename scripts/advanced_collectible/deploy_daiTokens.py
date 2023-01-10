from brownie import accounts, network, config, AssetManagement, DRExToken, DaiToken

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
