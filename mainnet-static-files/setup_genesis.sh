#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/mainnet_launch/docker-compose.genesis.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/mainnet_launch/orai.env

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/mainnet_launch/init_genesis.sh

# modify the orai.env name & content