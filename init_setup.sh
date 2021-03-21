#!/bin/bash

# Script for the initial setup process for Linux systems.
# Jared Stevens (jrodd96)
# Updated: 03/06/2021 06:54 PM

# ===================================================================

# Global constant variables

readonly TERMINUS='./packages/terminus-1.0.134-linux.deb'

readonly APT_UPDATE='./scripts/apt_update.sh'
readonly ARCH_UPDATE='./scripts/arch_update.sh'

readonly APT_INSTALL='./packages/apt-packages.txt'
readonly ARCH_INSTALL='./packages/arch-packages.txt'
readonly KALI_INSTALL='./packages/apt-packages-kali.txt'

readonly GNOME_INSTALL='./packages/gnome-packages.txt'
readonly XFCE4_INSTALL='./packages/xfce4-packages.txt'
readonly KDE_INSTALL='./packages/kde-packages.txt'

# ====================================================================


# Ensure script is run as root (sudo)
if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Script must be run as root or using 'sudo'..."
    exit 1
fi


# Check for successful exit status of last command
check_exit_status() {

    if [ $? -eq 0 ]; then
        echo "[SUCCESS]"
    else
        echo "[ERROR] The last command failed with an error status..."
        read -p "Exit script? (y/n): " exit_answer

        if ["$exit_answer" == "y" || "$exit_answer" == "Y" ]; then
            echo "Exitting script..."
            exit 1
        fi
    fi
}


# Update commands (apt) for Ubuntu/Debian distros
apt_update() {

    echo "Executing update commands..."
    bash "$APT_UPDATE";
    check_exit_status
}


# Update commands (pacman) for Arch distros
arch_update() {

    echo "Executing update commands..."
    bash "$ARCH_UPDATE";
    check_exit_status
}


# Ask if Terminus is to be installed (only for Ubuntu or Debian):
terminus() {

    read -p "Would you like to try and install Terminus? (y/n): " $answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        echo "Installing Terminus Debian package..."
        dpkg -i $TERMINUS;
        check_exit_status

        # Prevents aptitude from replacing Terminus with a different package of the same name
        apt-mark hold terminus;
        check_exit_status
    else
        exit 0
    fi
}


# Install dependencies (APT)
apt_depend() {

    echo "Installing dependencies..."
    for file in $(cat "$APT_INSTALL"); do apt-get install -y $file; done
    check_exit_status
}


# Install dependencies (PACMAN)
arch_depend() {

    echo "Installing dependencies..."
    for file in $(cat "$ARCH_INSTALL"); do pacman -S $file; done
    check_exit_status
}


# Install dependencies (kali ONLY)
kali_depend() {

    echo "Installing dependencies..."
    for file in $(cat "$KALI_INSTALL"); do apt-get install -y $file; done
    check_exit_status
}


# Main function
main() {

    echo "Please select the display manager you are using:"
    printf "\t(1) GNOME\n"
    printf "\t(2) XFCE4\n"
    printf "\t(3) KDE\n"
    printf "\t(4) Other (will exclude ALL display manager specific packages)\n"

    read -p "Selection (1-4): " selection

    output=$(less /etc/os-release | grep "^ID=")

    # IF Ubuntu AND GNOME display
    if [[ "$output" == "ID=ubuntu" && "$selection" == "1" ]]; then
        apt_update
        apt_depend
        echo "Installing GNOME packages..."
        for file in $(cat "$GNOME_INSTALL"); do apt-get install -y $file; done
        check_exit_status
        terminus
        exit 0

    # IF Ubuntu AND XFCE4 display

    # IF Ubuntu AND KDE display

    # IF Ubuntu and Other
    elif [[ "$output" == "ID=ubuntu" && "$selection" == "4" ]]; then
        apt_update
        apt_depend
        terminus
        exit 0

    # IF Debian AND GNOME display

    # IF Debian AND XFCE4 display

    # IF Debian AND KDE display

    # IF Debian AND Other

    # IF Pop! OS AND GNOME display
    elif [[ "$output" == "ID=pop" && "$selection" == "1" ]]; then
        apt_update
        apt_depend
        echo "Installing GNOME packages..."
        for file in $(cat "$GNOME_INSTALL"); do apt-get install -y $file; done
        check_exit_status
        terminus
        exit 0

    # IF Pop! OS AND Other (Pop! OS defaults to GNOME under normal installation)
    elif [[ "$output" == "ID=pop" && "$selection" == "4" ]]; then
        apt_update
        apt_depend
        terminus
        exit 0

    # IF Kali AND GNOME display
    elif [[ "$output" == "ID=kali" && "$selection" == "1" ]]; then
        apt_update
        kali_depend
        echo "Installing GNOME packages..."
        for file in $(cat "$GNOME_INSTALL"); do apt-get install -y $file; done
        check_exit_status
        terminus
        exit 0

    # IF Kali AND XFCE4 display

    # IF Kali AND KDE display

    # IF Kali AND Other
    elif [[ "$output" == "ID=kali" && "$selection" == "4" ]]; then
        apt_update
        kali_depend
        terminus
        exit 0

    # IF Arch AND GNOME display
    elif [[ "$output" == "ID=arch" && "$selection" == "1" ]]; then
        arch_update
        arch_depend
        echo "Installing GNOME packages..."
        for file in $(cat "$GNOME_INSTALL"); do pacman -S $file; done
        check_exit_status
        exit 0

    # IF Arch AND XFCE4 display

    # IF Arch AND KDE display

    # IF Arch AND Other
    elif [[ "$output" == "ID=arch" && "$selection" == "4" ]]; then
        arch_update
        arch_depend
        exit 0

    # Else exit w/ nonzero status
    else
        echo "[ERROR] Incorrect responses given. Please try again..."
        exit 1
    fi
}

main
