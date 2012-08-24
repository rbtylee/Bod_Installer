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

BOD_NAME="bodhi-web-dev"
APP_NAME="bodhi-web-dev"
APP_DESC="Web Development Suite"
PKG_LIST="bodhi-web-dev"
MENU_STR="\nApplications Installed"
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
    sudo cp *.deb /var/cache/apt/archives/ | zenity --progress --pulsate --auto-kill --title="Bodhi Application Installer" --text="<i>Preparing Files...</i>" --width=600
}

assert_package() {
    is_installed=$(apt-cache policy $APP_NAME | grep 'Installed: (none)' | wc -l)
    if [ "$is_installed" -eq "1" ]; then
        echo "Installation Failure!!"
        zenity --error --title="Bodhi Application Installer" --text="<b>${BOD_NAME^} Failed to Install</b>"
    else
        zenity --info --title="Bodhi Application Installer" --text="<b>${BOD_NAME^} Installed</b>\n$MENU_STR"
        apt-cache policy $APP_NAME
    fi
}


mySql_Password(){
  while [ 1 ]; do
    PSS=$(zenity --entry --hide-text --title="Configuring mysql-server-5.1" --text="While not mandatory, it is highly recommended that you set a password \nfor the MySQL administrative \"root\" user.\n\nIf this field is left blank, the password will not be changed.\n\nNew password for the MySQL \"root\" user:")
    if [ $? == 1 ]; then
      return 1
    fi
    PS2=$(zenity --entry --hide-text --title="Configuring mysql-server-5.1" --text="\n\nRepeat password for the MySQL \"root\" user:")
    if [ $? == 1 ]; then
      PS2=0
    fi
    if [ $PSS == $PS2 ]; then
      return 0
    else
      zenity --warning --title="Configuring mysql-server-5.1" --text="Password input error\n\nThe two passwords you entered were not the same. Please try again. "
     fi
  done
}

phpAdmin_Password(){
  while [ 1 ]; do
    PHP_PSS=$(zenity --entry --hide-text --title="Configuring phpmyadmin" --text="Please provide a password for phpmyadmin to register with the database\n server.  If left blank, a random password will be generated.\n\nMySQL application password for phpmyadmin:")
  if [ $? == 1 ]; then
      return 1
  fi
  PHP_PS2=$(zenity --entry --hide-text --title="Configuring phpmyadmin" --text="Password confirmation:")
  if [ $? == 1 ]; then
      PHP_PS2=0
  fi
  if [ $PHP_PSS == $PHP_PS2 ]; then
      return 0
  else
      zenity --warning --title="Configuring phpmyadmin" --text="Password input error\n\nThe two passwords you entered were not the same. Please try again. "
  fi
  done
}

rmAptCache

if [ "$1" == debug ]; then
    echo "Moving data into apt cache"
    copyAptCache
    # set mySql admin password
    mySql_Password
    if [ $? == 1 ] || [ -z $PSS ]; then
      sudo echo "mysql-server-5.1 mysql-server/root_password select (password omitted)" | sudo debconf-set-selections
      sudo echo "mysql-server-5.1 mysql-server/root_password_again select (password omitted)" | sudo debconf-set-selections
    else
      sudo echo "mysql-server-5.1 mysql-server/root_password password $PSS" | sudo debconf-set-selections
      sudo echo "mysql-server-5.1 mysql-server/root_password_again password $PSS" | sudo debconf-set-selections

    fi

    # Select phpmyadmin Web server
    WEB_S=$(zenity --list --radiolist --title="Configuring phpmyadmin" --text="Please choose the web server that should be automatically configured to \nrun phpMyAdmin. \n\n"  --column="" --column="Web server" TRUE apache2 FALSE lighttpd)
    if [ $? == 1 ]; then
          WEB_S="apache2"
    fi
    if [ $WEB_S == "lighttpd" ]; then
      sudo echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect lighttpd" | sudo debconf-set-selections
    else
      sudo echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections
    fi

    # Set phpmyadmin admin password for sql
    sudo echo "phpmyadmin phpmyadmin/mysql/admin-pass password $PSS" | sudo debconf-set-selections
    # Use dbconfig-common
    zenity --question --title="Configuring phpmyadmin" --text="The phpmyadmin package must have a database installed and configured before it can be used. This can be optionally handled with dbconfig-common.\n\nIf you are an advanced database administrator and know that you want to perform this configuration manually, or if your database has already been installed and configured, you should refuse this option.  Details on what needs to be done should most likely be provided in /usr/share/doc/phpmyadmin.\n\n Otherwise, you should probably choose this option.\n\n Configure database for phpmyadmin with dbconfig-common?"
    if [ $? == 0 ]; then
      sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
    else
      sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | sudo debconf-set-selections
    fi

    # Set phpmyadmin app password for sql
    phpAdmin_Password
    # If left blank or cancelled generate random password
    if [ $? == 1 ] || [ -z $PHP_PSS ]; then
      PHP_PSS=$(echo `</dev/urandom tr -dc A-Za-z0-9 | head -c8`)
    fi
    sudo echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHP_PSS" | sudo debconf-set-selections


    echo "Installing $APP_NAME via apt..."
    sudo apt-get -y --force-yes --no-download --ignore-missing install $PKG_LIST | zenity --text-info --title="Bodhi Application Installer" --width=800 --height=600
    assert_package
    rmAptCache
    sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
    sudo rm /etc/apt/sources.list.bak
    if [ "$2" == update ]; then
       sudo apt-get update
    fi
    exit $is_installed
fi

copyAptCache
# set mySql admin password
mySql_Password
if [ $? == 1 ] || [ -z $PSS ]; then
  sudo echo "mysql-server-5.1 mysql-server/root_password select (password omitted)" | sudo debconf-set-selections
  sudo echo "mysql-server-5.1 mysql-server/root_password_again select (password omitted)" | sudo debconf-set-selections
else
  sudo echo "mysql-server-5.1 mysql-server/root_password password $PSS" | sudo debconf-set-selections
  sudo echo "mysql-server-5.1 mysql-server/root_password_again password $PSS" | sudo debconf-set-selections

fi

# Select phpmyadmin Web server
WEB_S=$(zenity --list --radiolist --title="Configuring phpmyadmin" --text="Please choose the web server that should be automatically configured to \nrun phpMyAdmin. \n\n"  --column="" --column="Web server" TRUE apache2 FALSE lighttpd)
if [ $? == 1 ]; then
      WEB_S="apache2"
fi
if [ $WEB_S == "lighttpd" ]; then
  sudo echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect lighttpd" | sudo debconf-set-selections
else
  sudo echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections
fi

# Set phpmyadmin admin password for sql
sudo echo "phpmyadmin phpmyadmin/mysql/admin-pass password $PSS" | sudo debconf-set-selections
# Use dbconfig-common
zenity --question --title="Configuring phpmyadmin" --text="The phpmyadmin package must have a database installed and configured before it can be used. This can be optionally handled with dbconfig-common.\n\nIf you are an advanced database administrator and know that you want to perform this configuration manually, or if your database has already been installed and configured, you should refuse this option.  Details on what needs to be done should most likely be provided in /usr/share/doc/phpmyadmin.\n\n Otherwise, you should probably choose this option.\n\n Configure database for phpmyadmin with dbconfig-common?"
if [ $? == 0 ]; then
  sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
else
  sudo echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | sudo debconf-set-selections
fi

# Set phpmyadmin app password for sql
phpAdmin_Password
# If left blank or cancelled generate random password
if [ $? == 1 ] || [ -z $PHP_PSS ]; then
  PHP_PSS=$(echo `</dev/urandom tr -dc A-Za-z0-9 | head -c8`)
fi
sudo echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHP_PSS" | sudo debconf-set-selections


sudo apt-get -y --force-yes --no-download --ignore-missing install $PKG_LIST | zenity --progress --pulsate --auto-kill --title="Bodhi Application Installer" --text="<i>Installing ${BOD_NAME^}...</i>" --width=600

assert_package
rmAptCache
sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list
sudo rm /etc/apt/sources.list.bak
if [ "$1" == update ]; then
    sudo apt-get update
fi
echo -e "\n${BOD_NAME^} $APP_DESC installation completed.\n"
exit $is_installed

# All Wrongs Reserved.
