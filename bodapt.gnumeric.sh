#!/bin/bash
#
#   $$SH2NAME$$ Version 2.00.0
#   $$DATE$$
#
#   Bod Installation Script: Bodhi 2.0 i686
#
#   Bodhi Linux (c) 2012
#   Authors : rbt y-lee, Jeff Hoogland
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

BOD_NAME="gnumeric"
APP_NAME="gnumeric"
APP_DESC="Spreadsheet Application"
PKG_LIST="gnumeric"
MENU_STR="\nFind it in your Applications Menu under <i>Office</i>"
SCR_DIR=`dirname $BASH_SOURCE`

rmAptCache(){
    sudo rm -rf /var/lib/apt/lists/*
    sudo mkdir /var/lib/apt/lists/partial
    sudo rm -rf /var/cache/apt/archives/*
    sudo mkdir /var/cache/apt/archives/partial
}

copyAptCache(){
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo cp sources.list /etc/apt/
    sudo cp -f lists/* /var/lib/apt/lists/
    sudo cp *.deb /var/cache/apt/archives/ | zenity --window-icon=/usr/share/icons/bodhi.png  --progress --pulsate --auto-kill --title="Bodhi Application Installer" --text="<i>Preparing Files...</i>" --width=600
}

assert_package() {
    is_installed=$(apt-cache policy $APP_NAME | grep 'Installed: (none)' | wc -l)
    if [ "$is_installed" -eq "1" ]; then
        echo "Installation Failure!!"
        zenity --window-icon=/usr/share/icons/bodhi.png  --error --title="Bodhi Application Installer" --text="<b>${BOD_NAME^} Failed to Install</b>"
    else
        zenity --window-icon=/usr/share/icons/bodhi.png  --info --title="Bodhi Application Installer" --text="<b>${BOD_NAME^} Installed</b>\n$MENU_STR"
        apt-cache policy $APP_NAME
    fi
}

# Hack to deal with weird gnumeric preinst problem

sudo echo "gnumeric gnumeric/existing-process boolean true" | sudo debconf-set-selections
sudo echo "debconf debconf/priority select critical" | sudo debconf-set-selections


rmAptCache

if [ "$1" == debug ]; then
    echo "Moving data into apt cache"
    copyAptCache

    echo "Installing $APP_NAME via apt..."
    sudo apt-get -y --force-yes --no-download --ignore-missing install $PKG_LIST | zenity --window-icon=/usr/share/icons/bodhi.png  --text-info --title="Bodhi Application Installer" --width=800 --height=600
    assert_package
    rmAptCache
    sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
    sudo rm /etc/apt/sources.list.bak
    if [ "$2" == update ]; then
       sudo apt-get update
    fi
    # Restore debconf priority to Bodhi default
    sudo echo "debconf debconf/priority select high" | sudo debconf-set-selections

    exit $is_installed
fi

copyAptCache

sudo apt-get -y --force-yes --no-download --ignore-missing install $PKG_LIST 2>/dev/null | zenity --window-icon=/usr/share/icons/bodhi.png  --progress --pulsate --auto-kill --title="Bodhi Application Installer" --text="<i>Installing ${BOD_NAME^}...</i>" --width=600

assert_package
rmAptCache
sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
sudo rm /etc/apt/sources.list.bak
if [ "$1" == update ]; then
    sudo apt-get update
fi

# Restore debconf priority to Bodhi default
sudo echo "debconf debconf/priority select high" | sudo debconf-set-selections

echo -e "\n${BOD_NAME^} $APP_DESC installation completed.\n"
exit $is_installed

# All Wrongs Reserved.
