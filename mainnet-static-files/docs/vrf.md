# Tutorial to run VRF.

This tutorial is meant for the executors running the VRF feature of Oraichain, and the number of members is fixed. Below are the steps for the executors to start contributing to the VRF.

## 1. Submit your address's public key.

This step proves that you are actually the owner of the address you submitted to participate in the program, and that you have officially registered.

### 1.1 Collect your public key.

Please go to the [Oraichain wallet](https://api.wallet.orai.io) to get your public key. You will need to sign in if you have not. 

In the home page, you will see an account icon located at the top right of the page. Clicking on it will show your public key like shown below:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/pubkey-example.png" alt="Public key of an address example"/>
</p>

Please copy it and prepare for the next step.

*) Note that, if you have already signed in, but you do not see your public key. Please kindly sign out and sign in again, then your public key will be displayed.

## 1.2 Submit your public key.

This step requires you to create a **send transaction** to the following address: **orai17n62uccsxaryx3lnwdk4pxxvh09rsdm570zavk**.

The **memo** must be your **public key**, and the amount is **0.000001 ORAI**.

An example is:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/send-vrf-example.png" alt="Send VRF example"/>
</p>

## 2. Download the VRF runner binary.

Since us, the Oraichain team need your public keys to begin the initialization process, the VRF binary will not be available until we have collected all executors' public keys.

Once the initialization process has finished, please run the following command to download the VRF runner binary (the command will be updated accordingly to the provided binary):

```
curl http://ipfs.io/ipfs/ > vrf_runner && chmod +x vrf_runner
```

The above command will download a binary and set its name as ```vrf_runner```.

## 2. Create an environment file to run the binary.

The content of the environment file is below:

```
MNEMONIC=
FEES=0
GAS=200000
```

where you will need to fill in the ```MNEMONIC``` value with the **mnemonic of your address used to sign up for the Oraichain's sub-network**. 

Meanwhile, ```FEES``` is the transaction fees you spend for your contribution transactions, and ```GAS``` is the gas limit for such transactions.

For example: 
```MNEMONIC=foo bar foo bar foo bar foo bar foo bar foo bar ```

Please use the following command to create the file: 

```nano .env```

and copy the content of the file there. The ```env``` file should be created in the same directory as the ```vrf_runner``` binary.

## 3. Run the binary.

In the directory containing the ```vrf_runner``` binary, type:

```
./vrf_runner
```

### 3.1 First phase.

Running the binary for the first time with correct configurations will submit your initial key shares onto the Oraichain sub-network. 

All executors must finish their first binary run before we can move to the second phase.

Below is an example of a successful phase:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/first-run-successful.png" alt="Send VRF example"/>
</p>

However, the final executor running the binary will receive a different log, which is shown below as an instance:

<p align="center">
  <img src="hhttps://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/first-run-final-successful.png" alt="Send VRF example"/>
</p>

After all members have generated and shared their contribution keys, we can move on to the second phase. 

We will frequently check if all members have shared or not to finish this phase.

### 3.2 Second phase.

Because the VRF binary needs to run continuously to frequently contribute to the execution and verification of the calculation of random data, it is recommended to use ```byobu``` as a way to keep the binary running.

Type:

```byobu```

to enter the byobu terminal. Finally, type:

```
./vrf_runner
```

to begin contributing!

### THANK YOU SO MUCH FOR YOUR CONTRIBUTION!
