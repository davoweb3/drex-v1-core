from brownie import network, accounts, config, interface


def get_breed(breed_number):
    switch = {0: "DREX1"}
    return switch[breed_number]


def fund_advanced_collectible(nft_contract):
    dev = accounts.add(config["wallets"]["from_key"])
    link_token = interface.LinkTokenInterface(
        config["networks"][network.show_active()]["link_token"]
    )
    link_token.transfer(nft_contract, 1000000000000000000, {"from": dev})
