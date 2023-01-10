from brownie import accounts, network, config, AssetManagement, DRExToken

from dotenv import load_dotenv
import os
import time


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    erc20Token = DRExToken.deploy(
        {"from": dev},
    )

    time.sleep(0.1)
    erc20Token.set_address(erc20Token, {"from": dev})
