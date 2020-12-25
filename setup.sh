#!/bin/sh
# download the docker-compose & orai.env file

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/docker-compose.yml

curl -OL https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/orai.env

# modify the orai.env name & content
