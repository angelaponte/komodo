FROM ubuntu:xenial

#The sources.list file contains the sources that will be needed to install the subsequent packages
COPY sources.list /etc/apt/

#Update the apt-get repository list, based on the sources.list above
RUN apt-get -y update

#Install the Komodo dependencies
RUN apt-get -y install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget libcurl4-openssl-dev bsdmainutils automake curl

#Clone the komodo repository
RUN git clone https://github.com/jl777/komodo

#Fetch the komodo parameters
RUN komodo/zcutil/fetch-params.sh

#Build komodo; the number after the -j sets the number of threads used to build
RUN komodo/zcutil/build.sh -j2

#Create .komodo directory in root's home
RUN mkdir /root/.komodo

#Use default configuration for zcashd
RUN touch /root/.komodo/komodo.conf

#Run and synchronize the komodo daemon
RUN komodo/src/komodod -daemon

#Install Litecoin dependencies
RUN apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libdb++-dev

#Clone the LiteCoin repository
RUN git clone https://github.com/litecoin-project/litecoin

#Generate the litecoin configure script
RUN litecoin/autogen.sh

#Configure litecoin based on building machine's hardware
RUN litecoin/configure --with-incompatible-bdb --with-gui=no --prefix=/litecoin

#Build litecoin, based on system configuration
RUN make 

#Install litecoin
RUN make install

#Create the .litecoin directory in root's home
RUN mkdir /root/.litecoin

#Copy the litecoin.conf file to root's home
COPY litecoin.conf /root/.litecoin

#Start the litecoin daemon
RUN litecoin/bin/litecoind -daemon
