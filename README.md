# Bitcoin Node JSON RPC API (Part 1/3/4)

## Background
To expand Urbit’s Bitcoin-related capabilities, we are building a Gall app which can comprehensively control a Bitcoin Core full node via the JSON RPC API. The app is contained in this branch of the Urbit repo, and the original conception of this idea is discussed here. Our ultimate goal is to create Bitcoin libraries for Urbit, enabling Bitcoin to serve as a "money primitive" for future Gall apps.

Bitcoin Core is the reference implementation for Bitcoin nodes, which can be run as bitcoind or bitcoin-qt.

##Bounty Description
This bounty is to create a portion of the Gall app library for Remote Procedure Calls to a Bitcoin Core full node, written in Hoon.

Specifically, this bounty is to create types and JSON conversions for commands and responses of the sections of the [Bitcoin Core API reference](https://bitcoincore.org/en/doc/0.18.0/) titled "Wallet" and "ZMQ".
Create type definitions in Hoon for structuring commands and responses. Specify poke-action types that map to each command. Use logic specified in Bitcoin Core API resource and the template contained in the guidelines, and fill in this code where appropriate in [pkg/arvo/lib/btc-node-json.hoon](https://github.com/urbit/urbit/blob/9bb9b20c71a0a46edc6c52dd869017d3a51ede30/pkg/arvo/lib/btc-node-json.hoon).
The application will be structured as two Gall agents: one “Store” and one “Hook”. The store should act as a data store for data received from the Bitcoin full node, and the Hook should send commands to the node as well as parsing the responses and poking them into the Store. A [template branch](https://github.com/urbit/urbit/tree/btc-node-grant) has been created to set up skeletons of these files to make your work easier.
##Resources
- [Store/Hook proposal for userspace architecture](https://docs.google.com/document/d/1hS_UuResG1S4j49_H-aSshoTOROKBnGoJAaRgOipf54/edit?usp=sharing)
- [Urbit Gall App documentation](https://urbit.org/docs/learn/arvo/gall/)
- Bitcoin Core API reference documentation: [Here](https://bitcoincore.org/en/doc/0.18.0/), [here](https://bitcoin.org/en/developer-reference#remote-procedure-calls-rpcs).
- Distinctions between bitcoind and bitcoin-qt: Differences between them discussed [here](https://bitcoin.stackexchange.com/questions/13368/whats-the-difference-between-bitcoind-and-bitcoin-qt-different-commands)
- [JSON RPC API standards](https://www.jsonrpc.org/specification)

## Install

`npm install` will install all dependencies.

## Deploy to Urbit

Modify the path to your pier in `.urbitrc` and then, after `|mount /=base=` has been ran in your urbit, run `npm run serve` and then `|commit %base` from your urbit.

## Bitcoin Node

Copy `./bitcoin.conf` to your local path. Documentation can be found [here](https://en.bitcoin.it/wiki/Running_Bitcoin). Then run `./bitcoind`

If something doesn't work, the manual command is:
```
bitcoind  -server=1 -rpcuser=urbitcoiner -rpcport=18443 -rpcpassword=urbitcoiner  -regtest  -rpcallowip=127.0.0.1 -daemon
```

After a named wallet is created from your urbit with `:btc-node-hook|action [%create-wallet 'wallet' ~ ~]`, funding your wallet to get some data onto the blockchain can be done with:

```
bitcoin-cli -regtest -rpcwallet='wallet' generatetoaddress 101 $(bitcoin-cli -regtest -rpcwallet='wallet' getnewaddress)
```
