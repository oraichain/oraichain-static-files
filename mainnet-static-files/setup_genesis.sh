#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docker-compose.genesis.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/orai.env

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/init_genesis.sh

# modify the orai.env name & content