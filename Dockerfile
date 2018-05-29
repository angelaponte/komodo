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
