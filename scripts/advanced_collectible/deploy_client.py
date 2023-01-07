from brownie import accounts, network, config, AssetManagement, DRExToken, Client
from scripts.helpful_script import fund_advanced_collectible
from dotenv import load_dotenv
import os
import time

erc20 = DRExToken[-1]
contract_to_transfer = AssetManagement[-1]


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    client = Client.deploy(contract_to_transfer, erc20, {"from": dev})
    print("client address is {}".format(client))
    print(erc20)
    print(contract_to_transfer)
    client.request_sensor_data({"from": dev})
    time.sleep(2 * 60)
    print("calling the volume function")
    time.sleep(4)
    curr_value = client.volume()
    print(curr_value)
