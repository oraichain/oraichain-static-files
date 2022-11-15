#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/docker-compose-sync-zero-block.yml && mv docker-compose-sync-zero-block.yml docker-compose.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/orai.env

# modify the orai.env name & content