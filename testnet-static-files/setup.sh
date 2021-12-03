#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/testnet-static-files/docker-compose.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/testnet-static-files/orai.env

# modify the orai.env name & content
