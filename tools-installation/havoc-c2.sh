#!/bin/bash

# Install havoc
paru -S havoc-c2-git

# change own for the directory
chown -R twilight:twilight /opt/Havoc

# change the host ip address in havoc profile
cp-wlan.sh
nvim /opt/Havoc/profiles/havoc.yaotl

# run the havoc teamserver
havoc server --profile profiles/havoc.yaotl
