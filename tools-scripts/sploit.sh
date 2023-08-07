#!/bin/bash

# Installing Ruby environment version 3.0.5 and set it to default
# https://github.com/rapid7/metasploit-framework/blob/master/.ruby-version
source "$HOME/.config/zsh/.zprofile"
rvm install 3.0.5
rvm use 3.0.5 --default

# Source the newly created RVM installation 
source "$HOME/.rvm/scripts/rvm"

# Add gem executables directory to PATH
echo 'export PATH="$PATH:$HOME/.config/.local/share/gem/ruby/3.0.0/bin"' >> "$HOME/.config/zsh/.zshrc"

# Install all gems necessary to run Msfconsole
cd /opt/metasploit/vendor/bundle/ruby/3.0.0/gems/
gem install bundler
bundle install
cd -

# Setting up the PostgreSQL database
sudo -iu postgres <<EOF
initdb -D /var/lib/postgres/data
exit
EOF
echo "[*] PostgreSQL setup completed."

# Start and enable the PostgreSQL service
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service

# Initialize the database
msfdb init --connection-string=postgresql://postgres@localhost:5432/postgres
echo "[*] Metasploit database has been properly initialized."

echo 'Run db_status to verify that database connection is properly established:'
echo '  msf6 > db_status'
