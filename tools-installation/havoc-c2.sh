#!/bin/bash

# Install havoc
paru -S havoc-c2-git

# Change own for the directory
chown -R twilight:twilight /opt/Havoc

# Change the host ip address in havoc profile
cp-wlan.sh
nvim /opt/Havoc/profiles/havoc.yaotl

# Run the havoc teamserver
havoc server --profile profiles/havoc.yaotl

# Connect using havoc client
havoc client
