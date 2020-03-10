#!/bin/bash

set -ev

mkdir output

osm2gtfs -c kochi.json

cp ./data/kochi.zip ./output/kochi.zip

cd output

python ../transitfeed-1.2.16/feedvalidator.py kochi.zip || :

unzip kochi.zip

cd ..
