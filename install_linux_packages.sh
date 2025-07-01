#!/usr/bin/env bash

print_logo() {
    cat << "EOF"                                                                                           
     __    _                _____         _                  _____         _       _ _         
    |  |  |_|___ _ _ _ _   |  _  |___ ___| |_ ___ ___ ___   |     |___ ___| |_ ___| | |___ ___ 
    |  |__| |   | | |_'_|  |   __| .'|  _| '_| .'| . | -_|  |-   -|   |_ -|  _| .'| | | -_|  _|
    |_____|_|_|_|___|_,_|  |__|  |__,|___|_,_|__,|_  |___|  |_____|_|_|___|_| |__,|_|_|___|_| 

    Author: Martin Bullman

EOF
}


# clear screen and print logo. 
clear
print_logo

# source utilitiy functions.
source utils.sh

# source packages lists.
if [ ! -f "packages.conf"] then
    echo "Error: packages.conf not found!"
    exit 1
fi

source packages.conf

echo "Starting system setup..."

# update the system first.
sudo apt-get update -y && sudo apt-get upgrade -y 


