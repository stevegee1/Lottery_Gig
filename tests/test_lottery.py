from brownie import Lottery, accounts, config, network
from web3 import Web3

# testing our getEntrancefee function in Lottery.sol
def test_getEntrancefee():
    account = accounts[0]
    lottery_git_deploy = Lottery.deploy(
        config["networks"][network.show_active()]["eth_usd_priceFeed"],
        {"from": account},
    )
    assert lottery_git_deploy.getEntrancefee() > Web3.toWei(0.019, "ether")
    assert lottery_git_deploy.getEntrancefee() < Web3.toWei(0.03, "ether")


def main():
    test_getEntrancefee()
