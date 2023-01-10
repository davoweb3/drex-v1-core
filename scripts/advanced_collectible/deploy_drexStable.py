from brownie import (
    accounts,
    network,
    config,
    AssetManagement,
    DRExToken,
    DRExStable,
)
from dotenv import load_dotenv
import os
import time


def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(dev)
    drexStable = DRExStable.deploy(
        100000000000000000000000000000000000000000000000,
        {"from": dev},
    )

    time.sleep(0.1)
    drexStable.set_address(drexStable, {"from": dev})
