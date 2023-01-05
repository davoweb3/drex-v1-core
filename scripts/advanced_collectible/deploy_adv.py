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
    # erc20Token = DRExToken.deploy(
    #     57896044618658097711785492504343953926634992332820282019728792003956564819968,
    #     {"from": dev},
    # )

    # time.sleep(0.1)
    # erc20Token.setAddress(erc20Token, {"from": dev})
    # time.sleep(1)
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
    # # fund_advanced_collectible(advancedCollectible)
    return assetManagement


# advance_collectible -> 0x3f09Bc94D43DE9a7Fdfd52a1750D40dc4E99D122
# 0x881483C0D16F7C0497F1326AEFAAB6B1A3D2003B
# 0x2ED0FEB3E7FD2022120AA84FAB1945545A9F2FFC9076FD6156FA96EAFF4C1311
