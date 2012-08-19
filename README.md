BodInstallers
=============

These are the installer Templates used by [Bodhi Linux's](http://www.bodhilinux.com/) offline installers, aka .bod files. While Bodhi supports multiple CPU architectures, for purposes of illustration the installation scripts here are for Bodhi 2.0.1 32 bit.

Understanding Bod Files
-----------------------

* [.Bod File Command Line Arguments](http://wiki.bodhilinux.com/doku.php?id=bod_cli_arguments)
* [How To Build a .bod File](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_howto_build) Note this wiki is badly out of Date and describes how to build a Bod file manually using the orginal installtion script developed by Jeff Hoogland. Since then the Installtions scripts have grown abit in complexity and I use a python library I developed to build them.
* [How To Build a .bod File: Ncurses](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_how_to_build_ncurses)
* [Makeself Documentation](http://megastep.org/makeself/) For reference since bod files are created using the makeself utility.

Variable Substitution
---------------------

All words prefixed and postfixed with '**$$**' are variables which my python bod building script substitutes with the approbriate value for the package we are creating a bod for.

The complete list of such meta-variables is:

* **$$SHNAME$$**		The name of the primary Installation script, bt default installer.sh
* **$$SH2NAME$$**		The name of the secondary Installation script, by default bodapt.sh
* **$$DATE$$**			The date the bod was created.
* **$$BODNAME$$**		The name of the bod excluding the extension.
* **$$APPNAME$$**		The application name, ie the name of the deb installed. Usually this is the same as the bod name, but not always.
* **$$APPDESC$$**		A short description of the application.
* **$$APPLIST$$**		Most bods install one application and the apps dependencies. But it is possible for a bod to install several applications or packages, for example Bodhi service packs. This is a list of all debs to be installed, not listing of course all dependencies.
* **$$APPINSTR$$**		This is a short description usually telling user the menu location of the application installed.
* **$$NCFUNCTION$$**	Some packages use ncurses dialogs to ask questions of the user, this function is a way to aviod any ncurses dialogs by using zemity to ask the questions and debconf to preseed the answers. For a simple example see our wiki,
[How To Build a .bod File: Ncurses](http://wiki.bodhilinux.com/doku.php?id=bod_files_-_how_to_build_ncurses). For bods without any ncurses dialogs this is equal to **ε**, the empty string.
* **$$NCSUB$$**		This is the name of the function defined in $$NCFUNCTION$$. As in $$NCFUNCTION$$ for bods without an ncurses dialog this is also equal to **ε**

License
-------

GPL v3
These files are free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
