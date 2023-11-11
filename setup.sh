#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/docker-compose-sync-zero-block.yml && mv docker-compose-sync-zero-block.yml docker-compose.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/orai.env

# modify the orai.env name & content




# orai_node_setup  | 10:44AM INF Fetching snapshot chunk chunk=22 format=1 height=14325400 module=statesync total=36
# orai_node_setup  | 10:44AM INF Applied snapshot chunk to ABCI app chunk=36 format=1 height=14325400 module=statesync total=36
