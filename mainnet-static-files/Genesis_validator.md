# Tutorial to participate in the genesis phase

## Setup the genesis node

### 1. Run the genesis setup file

```bash
curl https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/setup_genesis.sh | sh
```

### 2. Edit wallet name and moniker you prefer to create a new wallet and validator in the orai.env file you have just downloaded

Since we are genesis validators, we need to expose nodes with public ip addresses for other nodes to connect to. Please edit the orai.env by adding a list of your public ip addresses in the WEBSITE key. Example: WEBSITE=1.2.3.4,2.3.4.5

### 3. Build and enter the container

```bash
sudo chmod +x init_genesis.sh && mv docker-compose.genesis.yml docker-compose.yml && docker-compose pull && docker-compose up -d --force-recreate && docker-compose exec orai bash
```

### 4. Type the following command to initiate your genesis node

```bash
setup
```

After running, there will be an **account.txt** file generated, which stores your genesis account information as well as its mnemonic. Please keep it safe, and remove the file when you finish storing your account information.

You also need to store two following files: **.oraid/config/node_key.json, .oraid/config/priv_validator_key.json**. They contain your validator information for voting. Create backups for these files, otherwise you will lose your validator node if something wrong happens.

### 5. Copy the validtor information

Please send the result of this command to the support member via telegram :  
`apk add curl && curl -F "file=@$(ls .oraid/config/gentx/gentx-*.json)" https://file.io | jq '.link' -r`

### 6. Wait for the team to setup the genesis file

### 7. Download the common genesis file

Firstly, download the new genesis file containing all the information of the genesis nodes.

```bash
wget -O .oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/genesis.json
```

After downloading, please check if it contains your account and validator information. If it does not, please inform us so we can add your information.

## Setup your sentry nodes

This section is optional if you want to follow the sentry architecture. For more information about the sentry architecture, please click [here](https://docs.tendermint.com/master/nodes/validators.html). We also show a short demonstration in the section [Setup the sentry architecture](#setup-the-sentry-architecture) on how to setup the sentry architecture. Otherwise, if you only want to run a simple genesis node, please move to the section [Start the network](#start-the-network).

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
docker-compose up -d --force-recreate && docker-compose exec orai bash
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
unconditional_peer_ids (optional) = <list of sentry node ids>
```

To get a node id, type:

```bash
oraid tendermint show-node-id
```

some configuration values can only be changed in the **.oraid/config/config.toml** file, like **addr_book_strict**

Example:

```bash
# change addr_book_strict to false
sed -i 's/addr_book_strict *= *.*/addr_book_strict = false/g' .oraid/config/config.toml
# --p2p.unconditional_peer_ids (optional)
oraivisor start --p2p.pex false \
  --p2p.persistent_peers "014b6fa1fd8d14fa7e08c353497baa1f5581a089@1.2.3.4:26656,bc806159212529879b42c737c2338042e396b1dd@2.3.4.5:26656" \
  --p2p.unconditional_peer_ids "014b6fa1fd8d14fa7e08c353497baa1f5581a089,bc806159212529879b42c737c2338042e396b1dd"
```

### 2. Sentry node configuration

```bash
pex = true
unconditional_peer_ids = <validator node id>
persistent_peers = <validator nodes, optionally other sentry nodes>
private_peer_ids = <validator node ids>
addr_book_strict = false
external_address = <your-public-address. Eg: tcp://1.2.3.4:26656>
when starting, set flag --rpc.laddr tcp://0.0.0.0:26657
```

Example:

```bash
# change addr_book_strict to false
sed -i 's/addr_book_strict *= *.*/addr_book_strict = false/g' .oraid/config/config.toml
# update your external_address
public_ip=1.2.3.4
sed -i 's/external_address *= *".*"/external_address = "tcp:\/\/'$public_ip':26656"/g' .oraid/config/config.toml
# --p2p.unconditional_peer_ids (optional)
oraivisor start --p2p.pex true --rpc.laddr tcp://0.0.0.0:26657 \
  --p2p.persistent_peers "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc@5.6.7.8:26656" \
  --p2p.unconditional_peer_ids "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc" \
  --p2p.private_peer_ids "cc433de0f3d7e8e125ca40396e7cedb12a5d68bc"
```

You should also set up firewalls for your genesis nodes.

## Start the network

As a validator, you shoud provide public ip addresses and node ids of your sentry nodes your that other nodes can connect to. You can expose your validator node directly, or you can use sentry nodes. Remember to expose at least two ports: **26656 and 26657**

Please exit the container and follow the below steps to start the nodes

### 1. Connect your nodes to other genesis nodes

The Oraichain team will also provide some public ip addresses for others as a starting point. You can check the genesis.json file, at the **website** part to look for our addresses. You should add them in the config.toml file, in the pair **persistent_peers** or through the flags to connect with us.

### 2. Start the genesis node

If you do not specify the flags, you must add at least a persistent peer connection in the **.oraid/config/config.toml** file before running the below command

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start'
```

or if you want to use flags instead:

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656"'
```

### 3. Start the sentry nodes (optional if you have such nodes)

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --rpc.laddr tcp://0.0.0.0:26657'
```

or:

```bash
docker-compose restart orai && docker-compose exec -d orai bash -c 'oraivisor start --rpc.laddr tcp://0.0.0.0:26657 --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656" --p2p.unconditional_peer_ids "<id1>,<id2>,<id3>" --p2p.private_peer_ids "<id1>,<id2>,<id3>"'
```

## Check your node status

Similarly to the medium article, you can check your node status through:

```bash
oraid status 2>&1 | jq '{catching_up: .SyncInfo.catching_up, voting_power: .ValidatorInfo.VotingPower}'
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

If you have problem with error caused by mistype `oraid collect-gentxs`, you can run `cd .oraid/data && find . -not -name '*.json' -delete` then re-run
