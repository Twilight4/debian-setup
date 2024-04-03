#!/bin/bash

# Update system
sudo pacman -Syu

# Install necessary packages
sudo pacman -S metasploit postgresql

# RVM single-user installation
curl -L get.rvm.io > rvm-install
bash < ./rvm-install
rm rvm-install
zsh          # Close out your current shell or terminal session and open a new one

# Installing Ruby environment version 3.0.5 and set it to default
# https://github.com/rapid7/metasploit-framework/blob/master/.ruby-version
rvm install 3.0.5
rvm use 3.0.5 --default           # it only works for bash, so use /bin/bash --login before that command

# Source the newly created RVM installation 
source "~/.rvm/scripts/rvm"

# Add gem executables directory to PATH (are there any execs?)
echo 'export PATH="$PATH:$HOME/.config/.local/share/gem/ruby/3.0.0/bin"' >> "$HOME/.config/zsh/.zshrc"

# Install all gems necessary to run Msfconsole
#cd /opt/metasploit/vendor/bundle/ruby/3.0.0/gems/   # if the latter doesn't work
cd /opt/metasploit
gem install bundler
bundle install
cd -

# Start and enable the PostgreSQL service
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service

# Setting up the PostgreSQL database
sudo -iu postgres <<EOF
initdb -D /var/lib/postgres/data
createuser twilight
psql
alter user twilight createdb;
\du
\q
exit
EOF
createdb msfdb
echo "[*] PostgreSQL setup completed."

# Initialize the database
msfdb init --connection-string=postgresql://postgres@localhost:5432/postgres
# OR
msfdb init --connection-string=postgresql://twilight@localhost:5432/msfdb

# Run db_status to verify that database connection is properly established:
# msf6 > db_status
# [*] postgresql connected to msf

# Connect to database from metasploit
msf6 > db_connect postgres@localhost:5432/postgres
# OR
msf6 > db_connect twilight@localhost:5432/msfdb
