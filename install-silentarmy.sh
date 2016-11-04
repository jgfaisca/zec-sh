#!/bin/bash

cd $HOME
sudo apt-get install git ocl-icd-opencl-dev libsodium-dev 
git clone https://github.com/mbevand/silentarmy.git
cd silentarmy
make
