BodInstallers
=============

These are the installer Templates used by [Bodhi Linux's](http://www.bodhilinux.com/) offline installers, aka .bod files. While Bodhi supports multiple CPU architectures, for purposes of illustration the installation scripts here are for Bodhi 2.0.1 32 bit.

Understanding Bod Files
-----------------------

Information on understanding bod files can be found on Bodhi Linux's Documentation wiki.

* [.Bod File Command Line Arguments](http://wiki.bodhilinux.com/doku.php?id=bod_cli_arguments)
* [How To Build a .bod File](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_howto_build) Note this wiki is badly out of Date and describes how to build a Bod file manually using the orginal installation script developed by Jeff Hoogland. Since then the Installtions scripts have grown abit in complexity and I use a python library I developed to build the bods on Bodhi Linux's AppCenter.
* [How To Build a .bod File: Ncurses](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_how_to_build_ncurses)
* [Makeself Documentation](http://megastep.org/makeself/) For reference since bod files are created using the **makeself** utility.

Files
-----
* **installer**		This is template for the first installation script found in most bod files. This script does some tests to determine if the bod can be installed and then calls the second script using gksudo to gain root.
* **bodapt**		This is second installation script found in most bod files. Here is where the deb files are actually installed.
* **installer.bodhi-web-dev.sh**		This is the custom installer template script for the bodhi-web-dev package.
* **bodapt.bodhi-web-dev.sh**		This is the custom bodapt template script for the bodhi-web-dev package.
* **installer.gnumeric.sh**			This is the custom installer template script for the gnumeric package.
* **bodapt.gnumeric.sh**			This is the custom bodapt template script for the gnumeric package.
* **README.md**		The readme file you are currently reading ;)

Variable Substitution
---------------------

All strings in the template scripts prefixed and postfixed with '**$$**' are variables which my python bod building script substitutes with the appropriate value for the package we are creating a bod for.

The complete list of such meta-variables is:

* **$$SHNAME$$**		The name of the primary Installation script, by default installer.sh
* **$$SH2NAME$$**		The name of the secondary Installation script, by default bodapt.sh
* **$$DATE$$**			The date the bod was created.
* **$$BODNAME$$**		The name of the bod excluding the extension.
* **$$APPNAME$$**		The application name, ie the name of the deb installed. Usually this is the same as the bod name, but for historical reasons (Hippytaff) not always.
* **$$APPDESC$$**		A short description of the application.
* **$$APPLIST$$**		Most bods install one application and the apps dependencies. But it is possible for a bod to install several applications or packages, for example Bodhi service packs. This is a list of all debs to be installed, not listing of course all dependencies.
* **$$APPINSTR$$**		This is a short description usually telling user the menu location of the application installed or other similar relevant information.
* **$$NCFUNCTION$$**	Some packages use ncurses dialogs to ask questions of the user, this function is a way to aviod any ncurses dialogs by using zemity to ask the questions and debconf to preseed the answers. For a simple example see our wiki,
[How To Build a .bod File: Ncurses](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_how_to_build_ncurses). For bods without any ncurses dialogs this is equal to **ε**, the empty string.
* **$$NCSUB$$**		This is the name of the function defined in $$NCFUNCTION$$. As in $$NCFUNCTION$$ for bods without an ncurses dialog this is also equal to **ε**

License
-------

GPL v3
These files are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
