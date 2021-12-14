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
can be done by backing up the `.oraid` directory using the command: ```mv .oraid .oraid_backup```.

It is critically important to back-up the `.oraid/data/priv_validator_state.json` file after stopping your oraid process. This file is updated every block as your validator participates in a consensus rounds. It is a critical file needed to prevent double-signing, in case the upgrade fails and the previous chain needs to be restarted. If that happens, please use the snapshot and compare the priv_validator_state.json file in the snapshot with the one you back-up.

It is also extremely crucial to back-up the `.oraid/config/node_key.json` & `.oraid/config/priv_validator_key.json` files. They are your validator identity, and without them, you will not be able to produce new blocks.

In the event that the upgrade does not succeed, validators and operators must restore to their latest snapshot before restarting their nodes.

## Upgrade Procedure

__Note__: It is assumed you are currently operating a full-node running orai v0.40.2 with v0.42.11 of the _Cosmos SDK_. The procedure also requires your node to have at least 16GB of RAM when starting with the new genesis state. Hence, you should choose a server provider that allows adjusting the hardware specs. After your node starts producing or syncing new blocks, you are can downgrade your node to a lower spec to reduce the node cost.

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