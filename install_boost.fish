#!/usr/bin/fish

set -x boost_version 1_74_0
set -x pretty_boost_version 1.74.0

mkdir -p $HOME/Downloads
cd $HOME/Downloads
wget "https://dl.bintray.com/boostorg/release/$pretty_boost_version/source/boost_$boost_version.tar.bz2"
rm -rf "boost_$boost_version"
tar xjf "boost_$boost_version.tar.bz2"
cd "boost_$boost_version"
sudo mkdir -p "/opt/boost-$pretty_boost_version"
sudo ln -sf "/opt/boost-$pretty_boost_version" /opt/boost
sudo chown $USER "/opt/boost-$pretty_boost_version"
./bootstrap.sh --prefix="/opt/boost-$pretty_boost_version"
./b2 install

