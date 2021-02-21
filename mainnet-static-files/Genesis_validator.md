# Tutorial to participate in the genesis phase

## Setup the genesis node

### 1. Download the genesis setup file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/setup_genesis.sh
```

### 2. Run the genesis setup file

```bash
sudo chmod +x setup_genesis.sh && ./setup_genesis.sh
```

### 3. Edit wallet name and moniker you prefer to create a new wallet and validator in the orai.env file you have just downloaded

Since we are genesis validators, we need to expose nodes with public ip addresses for other nodes to connect to. Please edit the orai.env by adding a list of your public ip addresses in the WEBSITE key.

### 4. Build and enter the container

```bash
sudo chmod +x init_genesis.sh && mv docker-compose.genesis.yml docker-compose.yml && docker-compose pull && docker-compose up -d && docker-compose exec orai bash
```

### 5. Type the following command to initiate your genesis node

```bash
setup
```

After running, there will be an account.txt file generated, which stores your genesis account information as well as its mnemonic. Please keep it safe, and remove the file when you finish storing your account information.

You also need to store two following files: .oraid/config/node_key.json and .oraid/config/priv_validator_key.json. They contain your validator information for voting. Create backups for these files, otherwise you will lose your validator node if something wrong happens.

### 6. Copy the validtor information

Please enter the .oraid/config/gentx/ directory. You'll see a json file which contains your validator information. Please copy its content and send us through the email support@orai.io

### 7. Wait for the team to setup the genesis file

### 8. Download the common genesis file

Firstly, download the new genesis file containing all the information of the genesis nodes.

```bash
wget -O .oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/genesis.json
```

After downloading, please check if it contains your account and validator information. If it does not, please inform us so we can add your information.

## Setup your sentry nodes (optional if you want to follow the sentry architecture)

### 1. Download the docker-compose file

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docker-compose.yml && chmod +x docker-compose.yml
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

## Setup the sentry architecture (optional if you want to follow the sentry architecture)

You can set the following configurations in the file .oraid/config/config.toml directly. Some pairs can be configured through the start command. This architecture will help you connect your genesis nodes with your sentry nodes, and your sentry nodes are responsible for connecting to other nodes within the network. For more information, please click [here](https://docs.tendermint.com/master/nodes/validators.html). To start using flags, please type:

```bash
oraivisor start --help
```

You also need to prepare your own VPC network beforehand.

### 1. Validator node configuration

```bash
pex = false
persistent_peers = <list of sentry nodes with node id, private ips, port 26656>
addr_book_strict = false
double-sign-check-height = 10
unconditional-peer-ids (optional) = <list of sentry node ids>
```

To get a node id, type:

```bash
oraid tendermint show-node-id
```

Example:

```bash
pex = false
persistent_peers = "014b6fa1fd8d14fa7e08c353497baa1f5581a089@1.2.3.4:26656,bc806159212529879b42c737c2338042e396b1dd@2.3.4.5:26656"
addr_book_strict = false
double-sign-check-height = 10
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

### 1. Connect your nodes to other genesis nodes

The Oraichain team will also provide some public ip addresses for others as a starting point. You can check the genesis.json file, at the **website** part to look for our addresses. You should add them in the config.toml file, in the pair **persistent_peers** or through the flags to connect with us.

### 2. Start the genesis node

```bash
oraivisor start
```

or:

```bash
oraivisor start --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656"
```

### 3. Start the sentry nodes

```bash
oraivisor start
```

or:

```bash
oraivisor start --rpc.laddr tcp://0.0.0.0:26657 --p2p.pex false --p2p.persistent_peers "<node-id1>@<private-ip1>:26656,<node-id2>@<private-ip2>:26656" --p2p.unconditional_peer_ids "<id1>,<id2>,<id3>" --p2p.private_peer_ids "<id1>,<id2>,<id3>"
```

## Check your node status

Similarly to the medium article, you can check your node status through:

```bash
oraid status &> status.json && cat status.json | jq '{catching_up: .SyncInfo.catching_up, voting_power: .ValidatorInfo.VotingPower}'
```

If you see that your VotingPower is greater than 0, and the catching_up is false, then congratulations, you are a validator now!
