from brownie import (
    AssetManagement,
    accounts,
    config,
    network,
    DaiToken,
    AssetManagement,
)
from scripts.helpful_script import get_breed, fund_advanced_collectible
import time
import os
from pathlib import Path
from dotenv import load_dotenv
import json
from metadata import sample_metadata
import requests

load_dotenv()
os.environ["UPLOAD_IPFS"] = "true"

nft_contract = AssetManagement[-1]


def main():
    print("enter the nft token id")
    id = int(input())
    getting_token_data(id)


def getting_token_data(token_id):
    if token_id >= nft_contract.tokenCounter():
        print("invalid token id")
    else:
        token_uri = nft_contract.tokenURI(token_id)
        res = requests.get(token_uri)
        print(res.json())
