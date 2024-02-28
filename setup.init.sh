# PRINT EVERY COMMAND
set -ux

if [ ! -d "$(pwd)/.oraid" ]; then
    apk add curl

    moniker=${MONIKER:-"NODE_SYNC"}
    CHAIN_ID="Oraichain"
    GAS_PRICE="0.001orai"
    SEED=e18f82a6da3a9842fa55769955d694f62f7f48bd@seed1.orai.zone:26656,893f246ffdffae0a9ef127941379303531f50d5c@seed2.orai.zone:26656,4fa7895fc43f618b53cd314585b421ee47b75639@seed3.orai.zone:26656,defeea41a01b5afdb79ef2af155866e122797a9c@seed4.orai.zone:26656

    # MAKE HOME FOLDER AND GET GENESIS
    oraid init $moniker --chain-id $CHAIN_ID --home=.oraid

    # DOWNLOAD GENESIS FILE
    wget -O .oraid/config/genesis.json https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/genesis.json

    # change app.toml values
    APP_TOML=.oraid/config/app.toml
    sed -i -E "s|^(minimum-gas-prices[[:space:]]+=[[:space:]]+).*$|\1\"$GAS_PRICE\"|" $APP_TOML

    # change config.toml values
    CONFIG_TOML=.oraid/config/config.toml
    sed -i -E "s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEED\"|" $CONFIG_TOML

    echo "Waiting 1 seconds to start state sync"
    sleep 1
fi
