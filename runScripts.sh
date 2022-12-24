#!usr/bin/sh

brownie run  ./scripts/advanced_collectible/deploy_adv.py --network rinkeby
brownie run  ./scripts/advanced_collectible/create_collectible.py --network rinkeby
brownie run  ./scripts/advanced_collectible/create_metdata.py --network rinkeby