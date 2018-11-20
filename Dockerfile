# Creates a BCH wormhole API Server and bitcoin-abc v18.0 Full Node.
# Based on this gist:
# https://gist.github.com/christroutner/d43eebbe99e155b0558f97e450451124

#IMAGE BUILD COMMANDS
FROM ubuntu:18.04
MAINTAINER Chris Troutner <chris.troutner@gmail.com>

#Update the OS and install any OS packages needed.
RUN apt-get update
RUN apt-get install -y sudo git curl nano gnupg

#Install Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs build-essential

#Create the user 'wormhole' and add them to the sudo group.
RUN useradd -ms /bin/bash wormhole
RUN adduser wormhole sudo

#Set password to 'password' change value below if you want a different password
RUN echo wormhole:password | chpasswd

#Set the working directory to be the connextcms home directory
WORKDIR /home/wormhole

#Setup NPM for non-root global install
RUN mkdir /home/wormhole/.npm-global
RUN chown -R wormhole .npm-global
RUN echo "export PATH=~/.npm-global/bin:$PATH" >> /home/wormhole/.profile
RUN runuser -l wormhole -c "npm config set prefix '~/.npm-global'"

# Install dependencies for building full node from source
RUN apt-get install -y build-essential libtool autotools-dev automake \
  pkg-config libssl-dev libevent-dev bsdmainutils libminiupnpc-dev libzmq3-dev \
  libboost-all-dev libdb++-dev libboost-system-dev libboost-filesystem-dev \
  libboost-chrono-dev libboost-program-options-dev libboost-test-dev \
  libboost-thread-dev


RUN mkdir /home/wormhole/.bitcoin
# Testnet configuration file
COPY config/testnet-example/bitcoin.conf /home/wormhole/.bitcoin/bitcoin.conf
# Mainnet configuration file
#COPY config/mainnet-example/bitcoin.conf /home/wormhole/.bitcoin/bitcoin.conf

# Clone the coppernet fork of the bitcoin-abc wormhole BCH full node
RUN git clone https://github.com/copernet/wormhole.git

# Generate build.h
WORKDIR /home/wormhole/wormhole/share
RUN ./genbuild.sh ../src/obj/build.h

# Build the binaries
WORKDIR /home/wormhole/wormhole
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

#Create a directory for holding blockchain data
VOLUME /home/wormhole/blockchain-data

# Expose the different ports

# Mainnet
#EXPOSE 8332
# Testnet
EXPOSE 18333

# ZeroMQ websockets
EXPOSE 28332

# Switch to user account.
USER wormhole
# Prep 'sudo' commands.
#RUN echo 'password' | sudo -S pwd


# Startup bitcore, wormhole, and the full node.
CMD ["/home/wormhole/wormhole/src/wormholed"]

#COPY finalsetup finalsetup
#ENTRYPOINT ["./finalsetup", "/home/wormhole/.npm-global/bin/bitcore", "start"]
