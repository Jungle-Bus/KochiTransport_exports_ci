#!/bin/bash

set -ev

wget https://github.com/mecatran/gtfsvtor/releases/download/v0.1.1/gtfsvtor.zip
unzip gtfsvtor.zip

git clone --branch=csv https://github.com/Jungle-Bus/prism

cd prism

poetry install

cd ..

git clone https://github.com/Jungle-Bus/bifidus_cli

cd bifidus_cli

poetry install
