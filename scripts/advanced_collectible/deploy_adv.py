from brownie import accounts, network, config, DRExToken, DaiToken, AssetManagement
from scripts.helpful_script import fund_advanced_collectible
from dotenv import load_dotenv
import os
import time

load_dotenv()

address_of_erc_token = 0
address_array = []

erc20Token = DRExToken[-1]
daiToken = DaiToken[-1]
print(erc20Token)


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    erc20Token = DRExToken.deploy(
        57896044618658097711785492504343953926634992332820282019728792003956564819968,
        {"from": dev},
    )

    time.sleep(0.1)
    erc20Token.setAddress(erc20Token, {"from": dev})
    time.sleep(1)
    add_file = open("address.txt", "r")
    address_list = add_file.readlines()
    for i in address_list:
        address_array.append(i[:-1])
    add_file.close()
    assetManagement = AssetManagement.deploy(
        erc20Token,
        daiToken,
        address_array,
        20,
        {"from": dev},
        publish_source=False,
    )
    add_file = open("address.txt", "a")
    add_file.write(str(assetManagement) + "\n")
    add_file.close()
    return assetManagement
