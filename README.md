## Linux Initial Setup Script

If you're anything like me, then you may find yourself repeatedly setting up Linux virtual machines for development and/or testing new distribution releases. Most popular distros nowadays like Ubuntu and Pop! OS will automatically run updates and install some optional packages during their installation. 

However, I still often find myself having to install development packages and other programs that I have become accustomed to using after the installation. Executing this process over and over again can be tedious and time-consuming. So that's where this script comes in! 

##### This script is designed to:

* Determine your Linux distribution via the `/etc/os-release` file before running the appropriate update scripts.
* Read and install a list of packages from a text file using the appropriate package manager.
* Ask and install optional packages for a variety of display managers (i.e. GNOME, KDE, etc.).
* Install downloaded Debian packages directly rather than via the package manager _(work in progress)_.
* Install downloaded AUR packages directly using Yay _(work in progress)_.

This script is still in its early stages, and I plan on adding additional functionality and more Linux distros over time. If you would like to support me with suggestions, it would be truly appreciated.

##### As of now, the script works for the following distros/package managers and display managers:

###### Distros:
* Ubuntu (aptitude)
* Debian (aptitude)
* Pop! OS (aptitude)
* Arch Linux (pacman)
* Kali Linux (aptitude)

###### Display Managers:
* GNOME
* XFCE4
* KDE
