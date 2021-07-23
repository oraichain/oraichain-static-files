# Tutorial to run the websocket binary.

This tutorial is meant for the validators running on the [Oraichain mainnet](https://scan.orai.io). Full nodes will not be able to broadcast AI reports since they have no validator accounts. Below are the steps to start listening and executing AI request. You are free to use any node you like to run this binary.

## 1. Download the binary.

Run the following command to download the websocket binary:

```
curl http://ipfs.io/ipfs/QmdFUCd99viiMdhaaWxDniiNyeMGZ89t8neRmY8LMGN6n9 > oracle_runner && chmod +x oracle_runner
```

The above command will download a binary and set its name as ```oracle_runner```.

## 2. Create an environment file to run the binary.

The content of the environment file is below:

```
WEBSOCKET_URL=wss://rpc.orai.io
URL=https://lcd.orai.io
CHAIN_ID=Oraichain
GAS=50000000
TX_FEES=0
ENCRYPTED_PASSWORD=
DOCKER_SOCK=/var/run/docker.sock
```

where you will need to fill in the ```ENCRYPTED_PASSWORD``` value with the encrypted password stored on your browser after you import your Oraichain wallet. 

For example: 
```ENCRYPTED_PASSWORD=U2FsdGVkX1/9CxMN06sTmNsBrGSf20PSaA+WuDDNu+8ez2FyNpaJSfSOFZn8Y4FYUQzJsjIrD5duMpABvBS1jc8qpaJEEMM9O0IQrQpcnrNQHfjJfHtMQI4Gi/H+1XaY4G9eKwxO0MmhL+SKTw/mQmD7k01dE5BITuhCVoYF6RjX0V+0B7eCkzWIogYgztcr2tdh+JJhdUKSAFt8L7KWWxBYw2ZOJDb6wZf03jBUH5s=```

Please use the following command to create the file: 

```nano .env```

and copy the content of the file there. The ```env``` file should be created in the same directory as the ```oracle_runner``` binary.

An important note is that you must use the **validator wallet account** to run the binary. Otherwise, you will not be able to create and broadcast AI request reports. 

## 3. Run the binary.

In the directory containing the ```oracle_runner``` binary, type:

```
./oracle_runner
```

Running the binary requires your PIN (the one you use to sign transactions when using the Oraichain wallet mobile version) to decrypt the password, which is prompted on the terminal.

Afterward, the websocket will listen to the node specified in the environment file to process the AI requests.

## 4. Run the binary as a background process

Because the websocket binary needs to run continuously to serve the AI requests, it is recommended to use ```byobu``` as a way to keep the websocket running.

Type:

```byobu```

to enter the byobu terminal. Finally, you can follow [section 3](#3-run-the-binary) to run the binary.

## Notes on the environment file.

You can edit the ```WEBSOCKET_URL``` and ```URL``` values corresponding to your node if you think that the team nodes are too slow when processing the AI requests.

You can edit the ```GAS``` and ```TX_FEES``` to control the gas limit and number of tokens you expect to spend for the reports.

### THANK YOU SO MUCH FOR YOUR CONTRIBUTION!
