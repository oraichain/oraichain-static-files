# Tutorial to participate in the Oraichain mainnet

## Setup the trusted validator node

### 1. Download and run the trusted setup file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/setup.sh && chmod +x ./setup.sh && ./setup.sh
```

### 2. Edit wallet name and moniker you prefer to create a new wallet and validator in the orai.env file you have just downloaded

### 3. Build and enter the container

```bash
docker-compose pull && docker-compose up -d --force-recreate
```

### 5. Type the following command to initiate your trusted node

```bash
docker-compose exec orai bash -c 'wget -O /usr/bin/fn https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/fn.sh && chmod +x /usr/bin/fn' && docker-compose exec orai fn init
```

After running, there will be an account.txt file generated, which stores your account information as well as its mnemonic. Please keep it safe, and remove the file when you finish storing your account information.

You need to store two following files: **.oraid/config/node_key.json, .oraid/config/priv_validator_key.json**. They contain your validator information for voting. Create backups for these files, otherwise you will lose your validator node if something wrong happens.

## Setup your sentry nodes

This section is optional if you want to follow the sentry architecture. For more information about the sentry architecture, please click [here](https://docs.tendermint.com/master/nodes/validators.html). We also show a short demonstration in the section [Setup the sentry architecture](#setup-the-sentry-architecture) on how to setup the sentry architecture

To get a node id, type:

```bash
oraid tendermint show-node-id
```

### 1. Download the docker-compose file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docker-compose.yml && chmod +x docker-compose.yml && touch orai.env
```

### 2. Enter the container

```bash
docker-compose pull && docker-compose up -d && docker-compose exec orai bash
```

### 3. Initiate the node so it has necessary configuration files

```bash
oraid init <moniker> --chain-id Oraichain
```

you can choose whatever moniker as you like, since your sentry nodes will not run as validators.

### 4. Download the common genesis file (If only the common genesis file is set)

```bash
wget -O .oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/genesis.json
```

## Setup the sentry architecture

This section is optional if you want to follow the sentry architecture. You can set the following configurations in the file **.oraid/config/config.toml** directly. Some pairs can be configured through the start command. This architecture will help you connect your genesis nodes with your sentry nodes, and your sentry nodes are responsible for connecting to other nodes within the network. To start using flags, please type:

```bash
oraivisor start --help
```

You also need to prepare your own VPC network beforehand.

### 1. Validator node configuration

```bash
pex = false
persistent_peers = <list of sentry nodes with node id, private ips, port 26656>
addr_book_strict = false
unconditional-peer-ids (optional) = <list of sentry node ids>
```

To get a node id, type:

```bash
oraid tendermint show-node-id
```

some configuration values can only be changed in the **.oraid/config/config.toml** file, like **addr_book_strict**

Example:

```bash
pex = false
persistent_peers = "014b6fa1fd8d14fa7e08c353497baa1f5581a089@1.2.3.4:26656,bc806159212529879b42c737c2338042e396b1dd@2.3.4.5:26656"
addr_book_strict = false
unconditional-peer-ids (optional) = "014b6fa1fd8d14fa7e08c353497baa1f5581a089,bc806159212529879b42c737c2338042e396b1dd"
```

### 2. Sentry node configuration

```bash
pex = true
unconditional-peer-ids = <validator node id>
persistent_peers = <validator nodes, optionally other sentry nodes>
private_peer_ids = <validator node ids>
addr_book_strict = false
external_address = <your-public-address. Eg: tcp://1.2.3.4:26656>
when starting, set flag --rpc.laddr tcp://0.0.0.0:26657
```

Example:

```bash
pex = true
unconditional-peer-ids = "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc"
persistent_peers = "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc@5.6.7.8:26656"
private_peer_ids = "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc"
addr_book_strict = false
external_address = "tcp://1.2.3.4:26656"
when starting: oraivisor start --rpc.laddr tcp://0.0.0.0:26657
```

You should also set up firewalls for your genesis nodes.

## Start the network

As a validator, you shoud provide public ip addresses and node ids of your sentry nodes your that other nodes can connect to. You can expose your validator node directly, or you can use sentry nodes. Remember to expose at least two ports: **26656 and 26657**

Please exit the container and follow the below steps to start the nodes

### 1. Start the trusted node

If you do not specify the flags, you must add at least a persistent peer connection in the **.oraid/config/config.toml** file before running the below command

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start'
```

or if you want to use flags instead:

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656"'
```

The above commands run as the background process. You can always run them in the foreground process by removing the "-d" flag

### 2. Start the sentry nodes (optional if you have such nodes)

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --rpc.laddr tcp://0.0.0.0:26657'
```

or:

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --rpc.laddr tcp://0.0.0.0:26657 --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656" --p2p.unconditional_peer_ids "<id1>,<id2>,<id3>" --p2p.private_peer_ids "<id1>,<id2>,<id3>"'
```

### 3. Wait for the team to distribute tokens to your wallet

Similarly to the [medium article](https://medium.com/oraichain/join-oraichain-testnet-beta-as-a-validator-484149374034), you can check your wallet information. Please wait until you receive tokens as well as the **catching up** status to **false** to continue

### 4. Create validator transaction

please enter the container and type:

```bash
fn createValidator
```

## Check your node status with voting power

Similarly to the [medium article](https://medium.com/oraichain/join-oraichain-testnet-beta-as-a-validator-484149374034), you can check your node status through:

```bash
oraid status &> status.json && cat status.json | jq '{catching_up: .SyncInfo.catching_up, voting_power: .ValidatorInfo.VotingPower}'
```

If you see that your VotingPower is greater than 0, and the catching_up is false, then congratulations, you are a validator now!

## Tips

You should monitor your nodes frequently. Make sure it has the correct tendermint public key to vote. To check, you should take a look at your **tendermint public key** in the **ValidatorInfo** attribute after typing:

```bash
oraid status
```

Please compare the **tendermint public key** to the one when you type:

```bash
oraid query staking validator <operator address>
```

If they match, then your node is still running fine. If not, then you should remove the **.oraid/config/node_key.json, .oraid/config/priv_validator_key.json** files, replace them with your backup files and restart the node.
