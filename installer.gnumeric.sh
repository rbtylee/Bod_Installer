#!/bin/bash
#
#   $$SHNAME$$ Version 2.00.0
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
SCR_DIR=`dirname $BASH_SOURCE`

echo -e "\nBodhi Application Installer\n      ${BOD_NAME^}: $APP_DESC\n"

ARCH=`cat /proc/cpuinfo | grep ARM`

if [ -n "$ARCH" ]; then
  echo "FATAL ERROR: ARM Processor detected."

  zenity --window-icon=/usr/share/icons/bodhi.png  --error --title "FATAL ERROR" --text "This bod file does not support\nthe cpu architecure detected.\n\nPlease Download the appropriate\nbod file for your machine."
  echo "aborting installation ..."
  exit 1
fi

RELEASE=`cat /etc/lsb-release | grep 10.04`
if [ -n "$RELEASE" ]; then
  echo "FATAL ERROR: Bodhi 1.x detected"
  zenity --window-icon=/usr/share/icons/bodhi.png  --error --title "FATAL ERROR" --text "This bod file only supports bodhi 2.0."
  echo "aborting installation ..."
  exit 1
fi

CPU_B=`/bin/uname -m | grep i686`
if [ -z "$CPU_B" ]; then
  echo "FATAL ERROR: Cpu not supported"
  zenity --window-icon=/usr/share/icons/bodhi.png  --error --title "FATAL ERROR" --text "This bod file only supports 32 bit Bodhi."
  echo "aborting installation ..."
  exit 1
fi

zenity --window-icon=/usr/share/icons/bodhi.png  --question --title="Bodhi Application Installer" --text="Would you like to install ${BOD_NAME^}: $APP_DESC?"

if [ $? == 1 ]; then
    zenity --window-icon=/usr/share/icons/bodhi.png  --info --title="Bodhi Application Installer" --text="${BOD_NAME^}: $APP_DESC was <i>not</i> installed. Thanks for using Bodhi!"
    echo -e "${BOD_NAME^} installation aborted.\n"
    exit 1
fi

zenity --window-icon=/usr/share/icons/bodhi.png  --info --title="Bodhi Application Installer" --text="Click <b>OK</b> and enter your password to install $BOD_NAME"

DO="bash $SCR_DIR/bodapt.sh $@"
gksudo -D "Bodhi Installation Script" $DO
exit $?

# All Wrongs Reserved.
