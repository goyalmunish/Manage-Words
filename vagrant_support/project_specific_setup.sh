#!/usr/bin/env bash


###### Installing Ruby ######
echo "<--- Installing Rubies --->"
# checking all installed rubies
rvm list
# installing ruby 1.9.3
if [[ `rvm list` == *'ruby-1.9.3'* ]] ; then
  echo "ruby-1.9.3 is already installed"
else
  rvm install 1.9.3 --with-openssl-dir=$rvm_path/usr
fi
# installation ruby 2.1.2
if [[ `rvm list` == *'ruby-2.1.2'* ]] ; then
  echo "ruby-2.1.2 is already installed"
else
  rvm install 2.1.2 --with-openssl-dir=$rvm_path/usr
fi
# checking installation details
rvm list

###### Installing Memcache Server ######
echo "<--- Installing Memcached Server --->"
if which memcached > /dev/null ; then
    echo 'Memcached Server is already installed'
else
    sudo apt-get install build-essential
    sudo apt-get install memcached
fi
which memcached 

###### THE END ######
echo "<--- End of 'project_specific_setup' Script --->"

