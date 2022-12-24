from brownie import (
    accounts,
    network,
    config,
    AdvancedCollectible,
    DRExToken,
    DRExStable,
)
from scripts.helpful_script import fund_advanced_collectible

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
    drexStable.setAddress(drexStable, {"from": dev})
