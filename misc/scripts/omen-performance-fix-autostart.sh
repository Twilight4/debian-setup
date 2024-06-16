#!/bin/bash

# Move the service to correct PATH
sudo cp ~/desktop/workspace/arch-setup/config-files/omen-performance-fix.service /etc/systemd/system/

# Set permissions and reload systemd
sudo chmod 644 /etc/systemd/system/omen-performance-fix.service
sudo systemctl daemon-reload

# Set permissions and reload systemd
sudo systemctl enable omen-performance-fix.service
sudo systemctl start omen-performance-fix.service
