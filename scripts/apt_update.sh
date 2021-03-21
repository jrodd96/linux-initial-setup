#!/bin/bash

# Update script for aptitude package manager

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Script must be run as root (sudo)"
    exit 1
fi

# Check for successful exit status
check_exit_status() {

    if [ $? -eq 0 ]; then
        echo "[SUCCESS]"
    else
        echo "[ERROR] The last command failed... exit script? (y/n): " $answer;

	    if [ "$answer" == "y" || "$answer" == "Y" ]; then
            echo "Exitting script..."
            exit 1
        fi
    fi
}

# Update commands
update() {

    apt-get update;
    check_exit_status
}

# Run upgrade commands
upgrade() {

    apt-get upgrade -y;
    check_exit_status

    apt-get dist-upgrade -y;
    check_exit_status
}

# Uninstall unused packages
clean() {

    apt-get autoremove -y;
    check_exit_status
}

# main function
main() {

    echo "Running update script..."
    update
    upgrade
    clean
}

main

if [ $? -eq 0 ]; then
    echo "[DONE]"
    exit 0
else
    echo "[ERROR] Please run script again or manually check for errors..."
    exit 1
fi
