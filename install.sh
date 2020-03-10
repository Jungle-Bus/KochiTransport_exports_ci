#!/bin/bash

set -ev

#install feedvalidator
wget https://github.com/google/transitfeed/archive/1.2.16.zip --output-document=transitfeed.zip
unzip transitfeed.zip

# install osm2gtfs
git clone https://github.com/grote/osm2gtfs

cd osm2gtfs

pip install -e .
