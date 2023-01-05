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
from scripts.helpful_script import fund_advanced_collectible
from dotenv import load_dotenv
import os
import time

drexStableCoin = DRExStable[-1]
drexTokens = DRExToken[-1]
drex_treasury = DrexTreasury[-1]


def main():
    dev = accounts.add(config["wallets"]["from_key"])

    # keep a limited ammount of drex for testing
    print("approving user to send tokens to contract ")
    time.sleep(2)

    # make sure drex treasury has enough  drex stable coins

    total_balance_of_nftHolder = drexTokens.balanceOf(dev, {"from": dev})
    print(total_balance_of_nftHolder)
    if total_balance_of_nftHolder == 0:
        print("not enough balance to redeem")
    else:
        drexTokens.approve(drex_treasury, total_balance_of_nftHolder, {"from": dev})
        time.sleep(10)
        print("transfering to the user now--> repemption function")
        drex_treasury.redeem({"from": dev})
