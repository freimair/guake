#!/bin/bash

# This script is used by the main developer to quickly compile and install the current version
# of Guake sources. Nothing say it will work directly on your environment. Use with caution!

NO_INSTALL=false
EXEC_AUTOGEN=false

echo "execute guake for developer."
echo "use --no-install to avoid installing guake on your system"
echo "(beware, gconf schema will be altered)"
echo "use --reinstall to force complete reinstall"

if [[ $1 == "--no-install" ]]; then
    NO_INSTALL=true
fi

if [[ $1 == "--reinstall" ]]; then
    EXEC_AUTOGEN=true
fi

if [[ ! -f configure ]]; then
    EXEC_AUTOGEN=true
fi

if [[ $EXEC_AUTOGEN == true ]]; then
    sudo apt-get install -y build-essential python autoconf
    sudo apt-get install -y gnome-common gtk-doc-tools libglib2.0-dev libgtk2.0-dev libgconf2-dev
    sudo apt-get install -y python-gtk2 python-gtk2-dev python-vte glade python-glade2
    sudo apt-get install -y python-vte python-gconf python-appindicator
    sudo apt-get install -y notify-osd libutempter0 glade-gtk2
    if [[ -f Makefile ]]; then
        make clean
    fi
    ./autogen.sh
fi

make || exit 1

if [[ $NO_INSTALL == true ]]; then
    gconftool-2 --install-schema-file=data/guake.schemas
    PYTHONPATH=src python src/guake/main.py
else
  sudo make install && gconftool-2 --install-schema-file=/usr/local/etc/gconf/schemas/guake.schemas || exit 1

  guake --quit 2> /dev/null
  guake
fi
