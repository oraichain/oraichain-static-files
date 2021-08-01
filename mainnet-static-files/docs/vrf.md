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

### 1.2 Submit your public key.

This step requires you to create a **send transaction** to the following address: **orai17n62uccsxaryx3lnwdk4pxxvh09rsdm570zavk**.

The **memo** must be your **public key**, and the amount is **0.000001 ORAI**.

An example is:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/send-vrf-example.png" alt="Send VRF example"/>
</p>

## 2. Download the VRF runner binary.

Since us, the Oraichain team need your public keys to begin the initialization process, the VRF binary will not be available until we have collected all executors' public keys.

Once the initialization process has finished, please go to the following link to download the VRF runner binary (the link will be updated accordingly to the provided binary):

**For dedicated Linux servers (no GUI)**

Type the following in your Terminal:

```
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1AcczSfKKPPQRfd_K9RZfL3SkKjvfxTSz' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1AcczSfKKPPQRfd_K9RZfL3SkKjvfxTSz" -O vrf_runner.zip && rm -rf /tmp/cookies.txt
```

**For local machines (Linux, MacOS and Windows)**

Use your favorite browser and go to the below link to download the zip file:

```
https://drive.google.com/uc?export=download&id=1AcczSfKKPPQRfd_K9RZfL3SkKjvfxTSz
```

The above link will provide you a zip file containing an environment variable and three binaries for Linux, Windows and MacOS respsectively.

Please extract the env file and the binary that is suitable for your OS. Next, rename the binary file to ```vrf_runner``` (for Windows it should be ```vrf_runner.exe```).

## 3. Update the environment file to run the binary.

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

## 4. Run the binary.

In the directory containing the ```vrf_runner``` binary, please use Terminal and type:

**For Linux and MacOS users:**

```
./vrf_runner
```

**For Windows users:**

You can click on the exe file to start running!

### 3.1 First phase.

Running the binary for the first time with correct configurations will submit your initial key shares onto the Oraichain sub-network. 

All executors must finish their first binary run before we can move to the second phase.

Below is an example of a successful phase:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/first-run-successful.png" alt="Send VRF example"/>
</p>

However, the final executor running the binary will receive a different log, which is shown below as an instance:

<p align="center">
  <img src="https://raw.githubusercontent.com/oraichain/oraichain-static-files/master/mainnet-static-files/docs/images/first-run-final-successful.png" alt="Send VRF example"/>
</p>

After all members have generated and shared their contribution keys, we can move on to the second phase. 

We will frequently check if all members have shared or not to finish this phase.

### 3.2 Second phase.

**For Linux and MacOS users:**

Type the following in Terminal:

```
./vrf_runner
```

to begin contributing!

**For Windows users:**

Type the following in Windows Powershell:

You can click on the exe file to start running!

### THANK YOU SO MUCH FOR YOUR CONTRIBUTION!
