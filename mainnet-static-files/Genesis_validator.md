# Tutorial to participate in the genesis phase

### 1. Download the setup file.

```bash
curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/setup_genesis.sh
```

### 2. Run the setup file.

```bash
sudo chmod +x setup_genesis.sh && ./setup_genesis.sh
```

### 3. Edit wallet name and moniker you prefer to create a new wallet and validator in the orai.env file you have just downloaded.

### 4. Run the following commands:

```bash
sudo chmod +x init_genesis.sh && mv docker-compose.genesis.yml docker-compose.yml && docker-compose pull && docker-compose up -d
```

### 5. Enter the container through the command:

```bash
docker-compose exec orai bash
```

### 6. Type the following command to initiate your genesis node:

```bash
setup
```

After running, there will be a account.txt file generated, which stores your genesis account information as well as its mnemonic. Please keep it safe, and remove the file when you finish storing your account infromation.

### 7. Copy the validtor information

Please enter the .oraid/config/gentx/ directory. You'll see a json file which contains your validator information. Please copy its content and submit it to the goggle form [here](https://forms.gle/s9tXqtQt5YKcVXvK6)

### 8. Wait for the team to setup the genesis file

### 9. After the team has finished setting up, type the following commands:

```bash
sed -i 's/persistent_peers *= *".*"/persistent_peers = "'"<list-of-private-ips-here>"'"/g' .oraid/config/config.toml 
```

Remember to replace the <list-of-private-ips-here> values to the one that the team provides.

Next, download the new genesis file containing all the information of the genesis nodes.

```bash
wget -O .oraid/config/genesis.json $GENESIS_URL
```

After downloading, please check if it contains your account and validator information. If it does not, please inform us so we can add your information.

### 10. Exit the container and type the following command to start your node:

```
docker-compose exec -d orai fn start --log_level error --seeds "db17ded030e8e7589797514f7e1b343b98357612@178.128.61.252:26656,1e65e100baa0b7381df47606c12c5d0bdb99cdb2@157.230.22.169:26656,a1440e003576132b5e96e7f898568114d47eb2df@165.232.118.44:26656"
```

to check if the node has run successfully, you can make a simple http request as follows:

```bash
curl  -X GET http://localhost:1317/cosmos/staking/v1beta1/validators
```

if you see your validator information as well as others, then your node is running well

```json
{
  "validators": [
    {
      "operator_address": "oraivaloper13fw6fhmcnllp4c4u584rjsnuun2stddjgngk4y",
      "consensus_pubkey": {
        "@type": "/cosmos.crypto.ed25519.PubKey",
        "key": "B5zXxXtJ3fGOp9Ngxn5GtemEuX7JrAZL/ysayZSU2V4="
      },
      "jailed": false,
      "status": "BOND_STATUS_BONDED",
      "tokens": "250000000",
      "delegator_shares": "250000000.000000000000000000",
      "description": {
        "moniker": "phamthanhtu",
        "identity": "",
        "website": "",
        "security_contact": "",
        "details": ""
      },
      "unbonding_height": "0",
      "unbonding_time": "1970-01-01T00:00:00Z",
      "commission": {
        "commission_rates": {
          "rate": "0.100000000000000000",
          "max_rate": "0.200000000000000000",
          "max_change_rate": "0.010000000000000000"
        },
        "update_time": "2021-01-27T07:46:51.048265860Z"
      },
      "min_self_delegation": "1"
    }
  ],
  "pagination": {
    "next_key": null,
    "total": "1"
  }
}
```

### NOTE
Since we are using a script to simplify the commands you have to use to run the nodes, we will be updating it frequently. To update the script file, type:

```bash
docker-compose exec orai bash -c 'wget -O /usr/bin/fn https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/fn.sh && chmod +x /usr/bin/fn'
```
