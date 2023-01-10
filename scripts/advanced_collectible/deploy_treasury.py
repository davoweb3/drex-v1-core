from brownie import (
    accounts,
    network,
    interface,
    config,
    AssetManagement,
    DRExToken,
    DaiToken,
    DrexTreasury,
    DRExStable,
)
from dotenv import load_dotenv
import os
import time

drexStableCoin = DRExStable[-1]
drexTokens = DRExToken[-1]


def fund_advanced_collectible(nft_contract):
    dev = accounts.add(config["wallets"]["from_key"])
    link_token = interface.LinkTokenInterface(
        config["networks"][network.show_active()]["link_token"]
    )
    link_token.transfer(nft_contract, 1000000000000000000, {"from": dev})


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    drex_treasury = DrexTreasury.deploy(
        drexStableCoin,
        drexTokens,
        {"from": dev},
    )
