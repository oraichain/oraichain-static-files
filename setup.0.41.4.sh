# PRINT EVERY COMMAND
set -ux

if [ ! -d "$(pwd)/.oraid" ]; then
    apk add curl

    moniker=${MONIKER:-"NODE_SYNC"}

    # make orai state sync directories
    mkdir .oraid

    SNAP_IP2=${SNAP_IP2:-"34.75.13.200"}
    SNAP_IP1=${SNAP_IP1:-"3.134.19.98"}
    CHAIN_ID="Oraichain"
    TRUST_HEIGHT_RANGE=${TRUST_HEIGHT_RANGE:-200}

    PEER_RPC_PORT=26657
    PEER_P2P_PORT=26656

    SNAP_RPC2=http://$SNAP_IP2:$PEER_RPC_PORT
    SNAP_RPC1=http://$SNAP_IP1:$PEER_RPC_PORT

    PEER_ID2=$(curl --no-progress-meter $SNAP_RPC2/status | jq -r '.result.node_info.id')
    PEER_ID1=$(curl --no-progress-meter $SNAP_RPC1/status | jq -r '.result.node_info.id')

    echo "peer id 2: $PEER_ID2"
    echo "peer id 1: $PEER_ID1"

    # persistent_peers
    PEER2="$PEER_ID2@$SNAP_IP2:$PEER_P2P_PORT"
    PEER1="$PEER_ID1@$SNAP_IP1:$PEER_P2P_PORT"

    # MAKE HOME FOLDER AND GET GENESIS
    oraid init $moniker --chain-id $CHAIN_ID --home=.oraid
    wget -O .oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/genesis.json

    # reset the node
    oraid tendermint unsafe-reset-all --home=.oraid

    # change app.toml values
    STATESYNC_APP_TOML=.oraid/config/app.toml

    # state_sync
    sed -i -E 's|^(snapshot-interval[[:space:]]+=[[:space:]]+).*$|\1200|' $STATESYNC_APP_TOML

    # change config.toml values
    STATESYNC_CONFIG=.oraid/config/config.toml

    # state sync node
    sed -i -E 's|tcp://127.0.0.1:26657|tcp://0.0.0.0:26657|g' $STATESYNC_CONFIG

    # Change config files (set the node name, add persistent peers, set indexer = "null")
    sed -i -e "s%^moniker *=.*%moniker = \"$moniker\"%; " $STATESYNC_CONFIG
    sed -i -e "s%^indexer *=.*%indexer = \"null\"%; " $STATESYNC_CONFIG

    # GET TRUST HASH AND TRUST HEIGHT
    LATEST_HEIGHT=$(curl -s $SNAP_RPC2/block | jq -r .result.block.header.height); \
    BLOCK_HEIGHT=$((LATEST_HEIGHT - $TRUST_HEIGHT_RANGE)); \
    TRUST_HASH=$(curl -s "$SNAP_RPC2/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

    # TELL USER WHAT WE ARE DOING
    echo "LATEST HEIGHT: $LATEST_HEIGHT"
    echo "TRUST HEIGHT: $BLOCK_HEIGHT"
    echo "TRUST HASH: $TRUST_HASH"

    sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \

    s|^(allow_duplicate_ip[[:space:]]+=[[:space:]]+).*$|\1true| ; \

    s|^(addr_book_strict[[:space:]]+=[[:space:]]+).*$|\1false| ; \

    s|^(persistent_peers[[:space:]]+=[[:space:]]+).*$|\1\"$PEER1,$PEER2\"| ; \

    s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC1,$SNAP_RPC2\"| ; \

    s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \

    s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \

    s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $STATESYNC_CONFIG

    echo "Waiting 1 seconds to start state sync"
    sleep 1
fi


# THERE, NOW IT'S SYNCED AND YOU CAN PLAY
oraivisor start --home=.oraid --minimum-gas-prices=0.001orai
