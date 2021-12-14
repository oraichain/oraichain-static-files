# Oraichain 2.0 Upgrade Instructions

This document describes the steps for validator and full node operators for the successful execution of the Oraichain 2.0 Upgrade, which migrates the network to a new genesis state. This migration will help validator & full node operators reduce the amount of storage used. It will also allow new nodes to synchornize with the network quickly due to a new genesis height.

The Oraichain team
will post an official Oraichain 2.0 genesis file, but it is recommended that validators
execute the following instructions in order to verify the resulting genesis file.

  - [Summary](#summary)
  - [Migrations](#migrations)
  - [Preliminary](#preliminary)
  - [Major Updates](#major-updates)
  - [Risks](#risks)
  - [Recovery](#recovery)
  - [Upgrade Procedure](#upgrade-procedure)
  - [Guidance for Full Node Operators](#guidance-for-full-node-operators)
  - [Notes for Service Providers](#notes-for-service-providers)
 
# Summary

The Oraichain will undergo a scheduled upgrade to Oraichain 2.0 on **a specific date here**.

The following is a short summary of the upgrade steps:
    1. Stopping the running Orai v0.40.2 instance 
    2. Backing up configs, data, and keys used for running Oraichain
    3. Resetting state to clear the local Oraichain state using the command: ```oraid unsafe-reset-all```
    4. Copying the Oraichain 2.0 genesis file to the Orai config folder (either after migrating an existing Oraichain genesis export, or downloading the Oraichain 2.0 genesis from the mainnet github)
    1. Starting the instance to resume the chain at the upgrade height + 1.

Specific instructions for validators are available in [Upgrade Procedure](#upgrade-procedure), 
and specific instructions for full node operators are available in [Guidance for Full Node Operators](#guidance-for-full-node-operators).

Upgrade coordination and support for validators will be available on the [Oraichain validators telegram channel](https://t.me/+yH9nMLrokQRhZGY1).

The network upgrade can take the following potential pathways:
1. Happy path: Validator successfully migrates the Oraichain genesis file to a Oraichain 2.0 genesis file, and the validators can successfully start the network with the Oraichain 2.0 genesis within 1-2 hours of the scheduled upgrade.
1. Not-so-happy path: Validators have trouble migrating the Oraichain genesis to a Oraichain 2.0 genesis, but can obtain the genesis file from the Oraichain github repo and can successfully start the network a few hours of the scheduled upgrade.  
1. Abort path: In the rare event that the team becomes aware of critical issues, which result in an unsuccessful migration within a few hours, the upgrade will be announced as aborted 
   on the [Oraichain validators telegram channel](https://t.me/+yH9nMLrokQRhZGY1), and validators will need to recover the latest snapshot of the Oraichain network using the initial genesis file without any updates or changes. 
   An update for the upgrade will need to be issued.

# Migrations

These chapters contains all the migration guides to update your app and modules to Oraichain 2.0.

## Risks

As a validator performing the upgrade procedure on your consensus nodes carries a heightened risk of
double-signing and being slashed. The most important piece of this procedure is verifying your
software version and genesis file hash before starting your validator and signing.

The riskiest thing a validator can do is discover that they made a mistake and repeat the upgrade
procedure again during the network startup. If you discover a mistake in the process, the best thing
to do is wait for the network to start before correcting it. If the network is halted and you have
started with a different genesis file than the expected one, seek advice from an Oraichain developer
before resetting your validator.

## Recovery

Prior to exporting `Oraichain` state, validators are encouraged to take a full data snapshot at the
export height before proceeding. Snapshotting depends heavily on infrastructure, but generally this
can be done by backing up the `.oraid` directory.

It is critically important to back-up the `.oraid/data/priv_validator_state.json` file after stopping your oraid process. This file is updated every block as your validator participates in a consensus rounds. It is a critical file needed to prevent double-signing, in case the upgrade fails and the previous chain needs to be restarted.

In the event that the upgrade does not succeed, validators and operators must restore to their latest snapshot before restarting their nodes.

## Upgrade Procedure

__Note__: It is assumed you are currently operating a full-node running orai v0.40.2 with v0.42.11 of the _Cosmos SDK_.

The version/commit hash of Orai v0.40.2: `e8153326d4d752d8a6be3bb726afbb77fc3b522e`

1. Verify you are currently running the correct version (v0.40.2) of _oraid_:

   ```bash
    $ oraid version --long
    name: orai
    server_name: oraid
    version: v0.40.1
    commit: e8153326d4d752d8a6be3bb726afbb77fc3b522e
    build_tags: netgo,ledger
    go: go version go1.15.3 linux/amd64
   ```

1. Make sure your chain halts at the right block height:
    The halt height is: `1613628000`

    ```bash
    sed -i 's/^halt-height =.*/halt-height = 1613628000/' .oraid/config/app.toml
    ```

 1. After the chain has halted, make a backup of your `.oraid` directory

    ```bash
    mv .oraid .oraid_backup
    ```

    **NOTE**: It is recommended for validators and operators to take a full data snapshot at the export
   height before proceeding in case the upgrade does not go as planned or if not enough voting power
   comes online in a sufficient and agreed upon amount of time. In such a case, the chain will fallback
   to continue operating `Oraichain`. See [Recovery](#recovery) for details on how to proceed.

1. Download the new genesis state:

   ```bash
   $ wget https://orai.s3.us-east-2.amazonaws.com/testnet/genesis.json -O genesis.json
   ```
   _this might take a while_

1. Verify the SHA256 of the (sorted) exported genesis file:

    Compare this value with other validators / full node operators of the network. 
    Going forward it will be important that all parties can create the same genesis file export.

   ```bash
   $ jq -S -c -M '' genesis.json | shasum -a 256
   [SHA256_VALUE]  genesis.json
   ```
1. Reset state:

   **NOTE**: Be sure you have a complete backed up state of your node before proceeding with this step.
   See [Recovery](#recovery) for details on how to proceed.

   ```bash
   $ oraid unsafe-reset-all
   ```

1. Move the new `genesis.json` to your `.oraid/config/` directory

    ```bash
    cp genesis.json ~/.oraid/config/
    ```

1. Start your blockchain 

    ```bash
    oraivisor start
    ```

    Automated audits of the genesis state can take 30-120 min using the crisis module. This can be disabled by 
    `oraivisor start --x-crisis-skip-assert-invariants`.

# Guidance for Full Node Operators

1. Verify you are currently running the correct version (v0.40.2) of _oraid_:

   ```bash
    $ oraid version --long
    name: orai
    server_name: oraid
    client_name: gaiacli
    version: 2.0.15
    commit: e8153326d4d752d8a6be3bb726afbb77fc3b522e
    build_tags: netgo,ledger
    go: go version go1.15 darwin/amd64
   ```

1. Stop your Orai v0.40.2 instance.

1. After the chain has halted, make a backup of your `.oraid` directory

   ```bash
   mv ~/.oraid ./gaiad_backup
   ```

   **NOTE**: It is recommended for validators and operators to take a full data snapshot at the export
   height before proceeding in case the upgrade does not go as planned or if not enough voting power
   comes online in a sufficient and agreed upon amount of time. That means the backup of `.oraid` should 
   only take place once the chain has halted at UNIX time `1613628000`.
   In such a case, the chain will fallback
   to continue operating `Oraichain`. See [Recovery](#recovery) for details on how to proceed.

1. Download the Oraichain 2.0 genesis file from the [Cosmos Mainnet Github](https://github.com/cosmos/mainnet).
   This file will be generated by a validator that is migrating from Oraichain to Oraichain 2.0.
   The Oraichain 2.0 genesis file will be validated by community participants, and
   the hash of the file will be shared on the #validators-verified channel of the [Cosmos Discord](https://discord.gg/cosmosnetwork).

1. Install v4.0.2 of [Orai](https://github.com/cosmos/orai).

   **NOTE**: Go [1.15+](https://golang.org/dl/) is required!

   ```bash
   $ git clone https://github.com/cosmos/orai.git && cd orai && git checkout v4.0.2; make install
   ```

1. Verify you are currently running the correct version (v4.0.2) of the _Gaia_:

   ```bash
    name: orai
    server_name: oraid
    version: 4.0.2
    commit: 6d46572f3273423ad9562cf249a86ecc8206e207
    build_tags: netgo,ledger
    ...
   ```
   
   The version/commit hash of Orai v4.0.2: `6d46572f3273423ad9562cf249a86ecc8206e207`

1. Reset state:

   **NOTE**: Be sure you have a complete backed up state of your node before proceeding with this step.
   See [Recovery](#recovery) for details on how to proceed.

   ```bash
   $ oraid unsafe-reset-all
   ```

1. Move the new `genesis.json` to your `.oraid/config/` directory

    ```bash
    cp genesis.json ~/.oraid/config/
    ```

1. Start your blockchain

    ```bash
    oraid start
    ```

   Automated audits of the genesis state can take 30-120 min using the crisis module. This can be disabled by
   `oraid start --x-crisis-skip-assert-invariants`.
   
## Notes for Service Providers

# REST server

In case you have been running REST server with the command `gaiacli rest-server` previously, running this command will not be necessary anymore.
API server is now in-process with daemon and can be enabled/disabled by API configuration in your `.oraid/config/app.toml`:

```
[api]
# Enable defines if the API server should be enabled.
enable = false
# Swagger defines if swagger documentation should automatically be registered.
swagger = false
```

`swagger` setting refers to enabling/disabling swagger docs API, i.e, /swagger/ API endpoint.

# gRPC Configuration

gRPC configuration in your `.oraid/config/app.toml`

```yaml
[grpc]
# Enable defines if the gRPC server should be enabled.
enable = true
# Address defines the gRPC server address to bind to.
address = "0.0.0.0:9090"
```

# State Sync

State Sync Configuration in your `.oraid/config/app.toml`

```yaml
# State sync snapshots allow other nodes to rapidly join the network without replaying historical
# blocks, instead downloading and applying a snapshot of the application state at a given height.
[state-sync]
# snapshot-interval specifies the block interval at which local state sync snapshots are
# taken (0 to disable). Must be a multiple of pruning-keep-every.
snapshot-interval = 0
# snapshot-keep-recent specifies the number of recent snapshots to keep and serve (0 to keep all).
snapshot-keep-recent = 2
```