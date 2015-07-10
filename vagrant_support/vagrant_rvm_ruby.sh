#!/usr/bin/env bash

echo "<--- Start of 'vagrant_rvm_ruby' Script --->"

###### Installing RVM ######
echo "<--- Installing RVM (under 'vagrant' user) --->"
echo User: $USER
if which rvm > /dev/null ; then
    echo 'RVM is already installed'
else
    echo "Note: You would be required to manually accept the key be executing command similar to following:"
    echo "gpg --keyserver hkp://keys.gnupg.net --recv-keys the-given-key"
    # install RVM stable
    sudo apt-get -y install curl
    \curl -sSL https://get.rvm.io | bash -s stable
    # adding a line to ~/.bashrc to load RVM everytime you open the terminal
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
    # reloading bash
    exec bash   # TODO: Note: it reloads bashrc
fi
# checking installation details
which rvm
rvm --version


###### Some Settings ######
echo "Adding 'vagrant' user to 'rvm' group"
echo User: $USER
sudo usermod -a -G rvm vagrant


###### Installing Ruby ######
echo "<--- Installing Rubies (under 'vagrant' user) --->"
# checking all installed rubies
echo User: $USER
rvm list
# Installation ruby 2.1.6
if [[ `rvm list` == *'ruby-2.1.6'* ]] ; then
  echo "ruby-2.1.6 is already installed"
else
  rvm install 2.1.6 --with-openssl-dir=$rvm_path/usr
fi
# checking installation details
rvm list


###### THE END ######
echo "<--- END of 'vagrant_rvm_ruby' Script --->"

