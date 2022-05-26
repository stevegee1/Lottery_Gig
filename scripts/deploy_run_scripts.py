from brownie import Lottery, accounts, config


def get_randomValue():
    account = accounts.add(config["wallets"]["from_key"])
    lottery = Lottery.deploy(
        "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
        "0x8A753747A1Fa494EC906cE90E9f37563A8AF630e",
        {"from": account, "gas_limit": 1389776},
    )


def main():
    get_randomValue()
