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

    # time.sleep(2)

    # print("calling the random function to get a random number")

    # random_amount = 5 * 10**18
    # print(random_amount)
    # print("approving user to send tokens to contract ")
    # drexStableCoin.approve(drex_treasury, random_amount, {"from": dev})

    # time.sleep(2)

    # print("sending from smes to treasury")

    # drex_treasury.pay_fees(random_amount, {"from": dev})
    # print(drexStableCoin.balanceOf(drex_treasury))

    # print("transfering to the user now--> repemption function")

    # total_balance_of_nftHolder = drexTokens.balanceOf(dev, {"from": dev})
    # print(total_balance_of_nftHolder)
    # if total_balance_of_nftHolder == 0:
    #     print("not enough balance to redeem")
    # else:
    #     drexTokens.approve(drex_treasury, total_balance_of_nftHolder, {"from": dev})
    #     drex_treasury.redeem({"from": dev})
