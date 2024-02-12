# blast-contracts

## Contract addresses:
```javascript
gameTicketContract: '0x3c1F70e4af2E1693e89Bed7B24f497d8b0b0dB43',
gameContract: {
      escapeFromGerms: '0xdC29E420FbaF9c273d84B5a6548a7936a7ccdb9e',
      tommyJumping: '0xCeB7dA77A08364AD614460E1Fa19782Cf1C6765a',
      snowmanDefender: '0x1e68ED8a770D439300b6a6Ada4082Dd46174dB2C',
      emojiMatch: '0x35Fa871534e1B452DD9Ef25aD597FD9FBaA6334d'
},
forwarderContract: '0xB6A87320DE35F2bEFE2258162360daa3de11C788',
lottoContract: '0xe1087eaE2147563d06f8870469bC022C94233f72',

```

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Steps

gameticket.setApproveForAll - game,lotto
gameticket.addVerifiedGame - game
