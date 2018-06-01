#Start with Ubuntu 16.4 as the base image
FROM ubuntu:xenial

#The sources.list file contains the repositories that will be needed to install the subsequent packages
COPY sources.list /etc/apt/

#Update the apt-get repository list, based on the sources.list file above
RUN apt-get -y update

#####Start Komodo installation#####
#Install the Komodo dependencies
RUN apt-get -y install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget libcurl4-openssl-dev bsdmainutils automake curl

#Clone the komodo repository
RUN cd /opt && git clone https://github.com/jl777/komodo

#Fetch the komodo parameters
RUN /opt/komodo/zcutil/fetch-params.sh

#Build komodo; the number after the -j sets the number of threads used to build
RUN /opt/komodo/zcutil/build.sh -j2

#Create .komodo directory in root's home
RUN mkdir /root/.komodo

#Use default configuration for zcashd
RUN touch /root/.komodo/komodo.conf

#Run and synchronize the komodo daemon
RUN /opt/komodo/src/komodod -daemon
#####End Komodo installation#####

#####Start Litecoin installation#####
#Install Litecoin dependencies
RUN apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils libboost-all-dev libdb++-dev

#Clone the LiteCoin repository
RUN cd /opt && git clone https://github.com/litecoin-project/litecoin

#Generate the litecoin configure script
RUN cd /opt/litecoin && ./autogen.sh

#Configure litecoin based on building machine's hardware
RUN cd /opt/litecoin && ./configure --with-incompatible-bdb --with-gui=no --prefix=/opt/litecoin

#Build litecoin, based on system configuration
RUN cd /opt/litecoin && make 

#Install litecoin
RUN cd /opt/litecoin && make install

#Create the .litecoin directory in root's home
RUN mkdir /root/.litecoin

#Copy the litecoin.conf file to root's home
COPY litecoin.conf /root/.litecoin

#Start the litecoin daemon
RUN /opt/litecoin/bin/litecoind -daemon
#####End Litecoin installation#####

#####Start BarterDEX installation#####
#Install BarterDEX dependencies
RUN apt-get -y install cmake git libcurl4-openssl-dev build-essential

#Clone the nanomsg repository
RUN cd /opt && git clone https://github.com/nanomsg/nanomsg

#Configure nanomsg
RUN cd /opt/nanomsg && cmake -DNN_TESTS=OFF -DNN_ENABLE_DOC=OFF

#Build nanomsg
RUN cd /opt/nanomsg && make -j2

#Install nanomsg
RUN cd /opt/nanomsg && make install

#Link and cache shared libraries for nanomsg
RUN ldconfig

#Clone the SuperNet repository
RUN cd /opt && git clone https://github.com/jl777/SuperNET

#Check out the dev branch
RUN cd /opt/SuperNET/iguana/exchanges && git checkout dev

#Install SuperNET
RUN cd /opt/SuperNET/iguana/exchanges && ./install
