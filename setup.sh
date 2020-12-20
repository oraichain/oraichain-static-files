#!/bin/sh
# download the docker-compose & orai.env file

wget https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/docker-compose.yml

wget https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/orai.env

# modify the orai.env name & content

# run docker-compose up -d or docker-compose up to check the node log.

docker-compose up -d