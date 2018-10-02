# wormhole-docker
This responsitory contains a Dockerfile and bash shell scripts for building
a Wormhole full node on the Bitcoin Cash (BCH) network. By default, this node
is setup for **testnet**, and the setup is based on
[this tutorial](https://developer.bitcoin.com/tutorials/wormhole-2-full-node.html).


## Installation
These directions are geared at Ubuntu 18.04 OS with at least 2GB of RAM,
and a non-root user with sudo privledges.
The testnet blockchain data takes up about 25GB of space.
Your mileage may vary.

1. It's always a good idea to add
[swap space](https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04)
to a new system. I recommend 8GB of swap typically.

2. Install Docker on the host system. Steps 1 and 2 in
[this tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
shows how to install Docker on a Ubuntu system.

3. Clone this repository:

`git clone https://github.com/christroutner/wormhole-docker && cd wormhole-docker`

* Create a `blockchain-data` directory in your home directory:

`mkdir ~/blockchain-data`

* Build the Docker images by running the 'build' shell script:

`./build-image`

* After the Docker image has been build, you can start it with the 'run' shell script:

`./run-image`

* After the blockchain syncs, you can access the insight server at port 3001.
You can check on progress with the command `docker logs insight-bch`.

**Note**: It's important that the
[bitcoin.conf](config/testnet-example/bitcoin.conf)
file get copied to the `~/blockchain-data` directory. If it is not, bitcore
will generate it's own (incorrect) copy. If things are behaving unexpectedly,
inspect the `~/blockchain-data/bitcoin.conf` file first. The `./run-image` script
will copy the config file before starting the image.


## Ideas for future improvement:
* Expand the setup for mainnet
* Figure out a way to skip building bitcoin-abc from source.
