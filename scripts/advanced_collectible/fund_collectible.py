from brownie import AdvancedCollectible
from scripts.helpful_script import fund_advanced_collectible


def main():
    advanced_collectible = AdvancedCollectible[len(AdvancedCollectible) - 1]
    fund_advanced_collectible(advanced_collectible)
