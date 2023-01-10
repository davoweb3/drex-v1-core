from brownie import accounts, network, config, DRExToken, DaiToken, AssetManagement
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
