#!/usr/bin/fish

set -x boost_version 1_74_0
set -x pretty_boost_version 1.74.0

# Download the distribution if we don't already have it.
mkdir -p $HOME/Downloads
cd $HOME/Downloads
if ! test -f "boost_$boost_version.tar.bz2"
    wget "https://dl.bintray.com/boostorg/release/$pretty_boost_version/source/boost_$boost_version.tar.bz2"
end

# Delete any uncompressed version and re-extract it.
echo Extracting boost-$pretty_boost_version...
rm -rf "boost_$boost_version"
tar xjf "boost_$boost_version.tar.bz2"
cd "boost_$boost_version"

# Delete this version of boost from /opt if it's there. Delete the /opt/boost symlink, too.
sudo rm -rf "/opt/boost-$pretty_boost_version" "/opt/boost"

# Create the destination directory for boost and set up /opt/boost to symlink to it.
sudo mkdir -p "/opt/boost-$pretty_boost_version"
sudo ln -sf "/opt/boost-$pretty_boost_version" /opt/boost
sudo chown $USER "/opt/boost-$pretty_boost_version" /opt/boost

# Bootstrap and build.
./bootstrap.sh --prefix="/opt/boost-$pretty_boost_version"
./b2 install

