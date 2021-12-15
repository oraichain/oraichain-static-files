---
id: become-a-validator
title: Become a Validator

---

## Step by step guide to participate in Oraichain testnet as a validator node:

This tutorial allows validators and full nodes synchronize with the Oraichain testnet from scratch using the traditional synchronization method from Tendermint.

## Hardware specifications for an Oraichain testnet node:

Since we have migrated the testnet to a new genesis file, joining the network requires a strong node with a ***minimum of 16GB RAM***. All of the memory will be used initially to start and fetch all the genesis state & files. After processing the first new block, you can stop the node & downgrade it to match the minimum requirement. For more information, please refer to an example of [genesis migration from the Cosmos network](https://github.com/cosmos/gaia/blob/main/docs/migration/cosmoshub-3.md#preliminary)

**Minimum requirements**

```
The number of CPUs: 2vCPUs
RAM: 2GB
Storage: 25GB SSD
```

**Recommended requirements**

```
The number of CPUs: 2vCPUs
RAM: 2GB
Storage: 50GB SSD
```

## Setup the validator node

### 1. Download and run the setup file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/testnet-static-files/setup.sh && chmod +x ./setup.sh && ./setup.sh
```

### 2. Edit wallet name and moniker you prefer to create a new wallet and validator in the orai.env file you have just downloaded

### 3. Build and enter the container

```bash
docker-compose pull && docker-compose up -d --force-recreate
```

### 4. Type the following command to initiate your node

```bash
docker-compose exec orai bash -c 'wget -O /usr/bin/fn https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/testnet-static-files/fn.sh && chmod +x /usr/bin/fn' && docker-compose exec orai fn init
```

After running, there will be an account.txt file generated, which stores your account information as well as its mnemonic. Please keep it safe, and remove the file when you finish storing your account information.

You need to store two following files: **.oraid/config/node_key.json, .oraid/config/priv_validator_key.json**. They contain your validator information for voting. Create backups for these files, otherwise you will lose your validator node if something wrong happens.

## Join the network

As a validator, you shoud provide public ip addresses and node ids of your sentry nodes your that other nodes can connect to. You can expose your validator node directly, or you can use sentry nodes. Remember to expose at least one port: **26656**

Please exit the container and follow the below steps to start the nodes

### 1. Start the node

If you do not specify the flags, you must add at least a persistent peer connection in the **.oraid/config/config.toml** file before running the below command

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start'
```

or if you want to use flags instead:

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --p2p.pex false --p2p.persistent_peers "<node-id1>@<ip-address1>:26656,<node-id2>@<ip-address2>:26656"'
```

eg: 
```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --p2p.pex false --p2p.persistent_peers "826756ec4c4aaa621c71de120ceb19c91925c0f3@1.2.3.4:26656,0baa806b3a4dd17be6e06369d899f140c3897d6e@4.5.6.7:26656"'
```

The above commands run as the background process. You can always run them in the foreground process by removing the "-d" flag

If the synchronization process seems to be stuck, please try to increase the ```max_packet_msg_payload_size``` value in ```.oraid/config/config.toml``` from 1024 to 102400000. Below is a useful command to change it:

```bash
sed -i 's/max_packet_msg_payload_size *= *.*/max_packet_msg_payload_size = 102400000/g' .oraid/config/config.toml
```

### 3. Wait until your node is fully synchronized

Please wait until your node is fully synchronized by typing: ```oraid status &> status.json && cat status.json | jq '{catching_up: .SyncInfo.catching_up}'```. If the **catching up** status is **false**, you can continue. Now, you can safely reduce the ```max_packet_msg_payload_size``` to 1024 again using the following command:

```bash
sed -i 's/max_packet_msg_payload_size *= *.*/max_packet_msg_payload_size = 1024/g' .oraid/config/config.toml
```

### 4. Get some tokens

Please use the [Oraichain testnet faucet](https://testnet-faucet.web.app/) to collect some test ORAIs.
You can check your wallet information by typing: ```oraid query auth account <your-wallet-address>``` or through the explorer, where you import your wallet.

### 4. Create validator transaction

please enter the container and type:

```bash
fn createValidator
```

## Check your node status with voting power

```bash
oraid status &> status.json && cat status.json | jq '{catching_up: .SyncInfo.catching_up, voting_power: .ValidatorInfo.VotingPower}'
```

If you see that your VotingPower is greater than 0, and the catching_up is false, then congratulations, you are a validator now!

# IMPORTANT NOTE

**YOU MUST NOT RUN TWO VALIDATOR NODES WITH THE SAME NODE KEY AND VALIDATOR KEY AT THE SAME TIME. OTHERWISE, YOUR VALIDATOR WILL BE TOMBSTONED BECAUSE OF DOUBLE SIGNING, AND IT WILL NEVER BE ABLE TO JOIN THE VALIDATORSET EVER AGAIN.**