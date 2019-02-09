#!/bin/sh

#
#  linux box setup stuff
#  - just do stuff that I ike to have on a linux box
#
#
#
#
#
#

#
# go to users home dir
#
cd ~

# 
# Need to run as root else get outta here
#

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


usage() { echo "Usage: $0 [-s <cent|fed|deb>] this is for the right package manager. \n - cent= yum based \n - fed = dnf based \n deb = apt based" 1>&2; exit 1; }

while getopts ":s:" o; do
    case "${o}" in
        s)
            s=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

pckmgr=""

if [ -z "${s}" ] ; then
    usage
elif [ $s = "cent" ]; then
    pckmgr="yum"
    echo "Indicated a yum based system"
    sudo ${pkgmgr} update -y
    sudo yum groupinstall 'Development Tools' -y  && sudo yum install curl file git vim -y
elif [ $s = "fed" ]; then
    pckmgr="dnf"
    sudo ${pkgmgr} update -y
    echo "Indicated a dnf based system"
    sudo dnf groupinstall 'Development Tools' -y && sudo dnf install curl file git vim -y
elif [ $s = "deb" ]; then
    pckmgr="apt"
    sudo ${pkgmgr} update -y
    sudo ${pkgmgr} upgrade -y
    echo "Indicated a apt based system"
    sudo apt-get install build-essential curl file git vim -y
else
    usage
fi


#
# install bash-it
#
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh

sed -i 's/bobby/sexy/g' .bashrc

#
# need to put my vim stuff in a place to easilly get
#
curl -sL https://raw.githubusercontent.com/egalpin/apt-vim/master/install.sh | sh
git clone https://github.com/morhetz/gruvbox.git ~/.vim/bundle/gruvbox
## cd ~
## wget vim.tar
## 
#
# install linuxbrew
#
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

