#!/usr/bin/env bash

echo "<--- Start of 'root_java_mysql_postgres_git_memcached_R' Script --->"
###### Initial check ######
if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi
echo `pwd`
echo 'this script works on Ubuntu 14.04 - 64 bit'


###### Setting up Variables ######
echo "<--- Setting up Variables --->"
echo User: $USER
# Java
java_file=jdk-6u37-linux-x64
java_dir=jdk1.6.0_37
java_resource=/vagrant/vagrant_support/external_resources
# Mysql
mysql_root_passwd=root
export mysql_root_passwd  # making the variable available to subshells
# Postgres
postgres_postgres_passwd=postgres  # TODO: it is duplicated in the below script, to correct it
export postgres_postgres_passwd # making the variable available to subshells
# Setting locale (required for PG)
sudo cat - > /etc/default/locale <<EOF
 LANG=en_US.UTF-8
 LANGUAGE=en_US.UTF-8
 LC_CTYPE=en_US.UTF-8
 LC_NUMERIC=en_US.UTF-8
 LC_TIME=en_US.UTF-8
 LC_COLLATE=en_US.UTF-8
 LC_MONETARY=en_US.UTF-8
 LC_MESSAGES=en_US.UTF-8
 LC_PAPER=en_US.UTF-8
 LC_NAME=en_US.UTF-8
 LC_ADDRESS=en_US.UTF-8
 LC_TELEPHONE=en_US.UTF-8
 LC_MEASUREMENT=en_US.UTF-8
 LC_IDENTIFICATION=en_US.UTF-8
 LC_ALL=en_US.UTF-8
EOF
locale  # printing the locale


###### Installing Oracle Java 8 ######
echo "<--- Installing Oracle Java 8 --->"
echo User: $USER
if which java > /dev/null ; then
    echo 'Java is already installed'
else
    # installing java
    sudo apt-add-repository -y ppa:webupd8team/java
    sudo apt-get -y update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer
    # additional setup
    echo JAVA_HOME=/usr/lib/jvm/$java_dir >> ~/.bashrc
    echo export 'PATH=$PATH:$JAVA_HOME' >> ~/.bashrc
    # reloading profile
    . /etc/profile
fi
# check installation details
which java
java -version
javac -version
javaws -version | grep 'Web Start'



###### Installing Oracle Java 6 ######
echo "<--- Installing Oracle Java 6 --->"
echo User: $USER
if which java > /dev/null ; then
    echo 'Java is already installed'
else
    # installing java 6, if installation of java 8 failed
    sudo mkdir -p /usr/lib/jvm
    cd $java_resource
    sudo cp $java_file.bin /usr/lib/jvm
    cd /usr/lib/jvm
    sudo chmod u+x $java_file.bin
    sudo ./$java_file.bin
    # setting up java
    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/$java_dir/bin/javac" 1
    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/$java_dir/jre/bin/java" 1
    sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/$java_dir/bin/javaws" 1
    sudo update-alternatives --set javac /usr/lib/jvm/$java_dir/bin/javac
    sudo update-alternatives --set java /usr/lib/jvm/$java_dir/jre/bin/java
    sudo update-alternatives --set javaws /usr/lib/jvm/$java_dir/bin/javaws
    # java plugin support for mozilla
    mkdir -p ~/.mozilla/plugins
    cd ~/.mozilla/plugins
    rm -f libnpj*
    ln -s /usr/lib/jvm/$java_dir/jre/lib/amd64/libnpjp2.so ~/.mozilla/plugins/
    # additional setup
    echo JAVA_HOME=/usr/lib/jvm/$java_dir >> ~/.bashrc
    echo export 'PATH=$PATH:$JAVA_HOME' >> ~/.bashrc
    # reloading profile
    . /etc/profile
fi
# check installation details
which java
java -version
javac -version
javaws -version | grep 'Web Start'


###### Installing GIT ######
echo "<--- Installing GIT --->"
echo User: $USER
if which git > /dev/null ; then
    echo 'GIT is already installed'
else
    # install GIV and RVM dependencies
    sudo apt-get -y install libcurl4-gnutls-dev libexpat1-dev gettext zlib1g-dev libssl-dev libreadline-dev libssl-dev libxml2-dev
    # install non-latest GIT
    sudo apt-get -y install git-core
    # install latest GIT
    git clone http://github.com/git/git.git ~/git_cloned
    cd ~/git_cloned
    make prefix=/usr/local all
    sudo make prefix=/usr/local install
    # check installed GIT version
    . ~/.profile
    . ~/.bashrc
fi
# checking installation details
which git
git --version


###### Installing Memcache Server ######
echo "<--- Installing Memcached Server --->"
echo User: $USER
if which memcached > /dev/null ; then
    echo 'Memcached Server is already installed'
else
    sudo apt-get install build-essential
    sudo apt-get install memcached
fi
which memcached 


###### Installing R Base ######
echo "<--- Installing R Base MANUALLY --->"
echo User: $USER
sudo apt-get install r-base
# R
# > install.packages("ggplot2")


###### Installing MySQL Server and MySQL Workbench ######
echo "<--- Installing MySQL --->"
echo User: $USER
if which mysql > /dev/null ; then
    echo 'Mysql is already installed'
else
    # update ubuntu repository
    sudo apt-get -y update
    # setting root password
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_passwd"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_passwd"
    # Note that this creates a cleartext copy of your password in /var/cache/debconf/passwords.dat
    # install 'mysql-server' and 'mysql-client' metapackages:
    sudo apt-get -y install mysql-server mysql-client
    # install 'mysql-workbench' metapackage for GUI client
    sudo apt-get -y install mysql-workbench
    # support for compiling mysql gem
    sudo apt-get -y install libmysqlclient-dev
    # reloading profile
    . /etc/profile
fi
# check installation details
which mysql
mysql -V


###### Installing PostgreSQL Server and pgAdminIII ######
echo "<--- Installing Postgres --->"
echo User: $USER
if which psql > /dev/null ; then
    echo 'Postgres is already installed'
else
    # install libpq-dev
    sudo apt-get -y install libpq-dev
    # update ubuntu repository
    sudo apt-get -y update
    # install postgresql with official ppa
    sudo apt-get -y install postgresql postgresql-contrib
    # installing GUI client
    sudo apt-get -y install pgadmin3
    # reloading profile
    . /etc/profile
    # setting password
    echo "listen_addresses = 'localhost'" | sudo tee --append /etc/postgresql/*/main/postgresql.conf    # TODO: Note: use of 'tee' command
    echo "# local   all   vagrant   trust" | sudo tee --append /etc/postgresql/*/main/pb_hba.conf    # permissions for vagrant user 
    # Note: Still the BELOW COMMAND is not running successfully and had to run it manually
    sudo su - postgres <<EOF
      postgres_postgres_passwd_quoted="'$postgres_postgres_passwd'"
      psql -d template1 -c "ALTER USER postgres with encrypted password $postgres_postgres_passwd_quoted;" -a # TODO: Note: executing single command in postgres
EOF
    # following is required for Ubuntu 14.04 (trusty)
    sudo su - postgres <<EOF
      psql -c "update pg_database set datistemplate=false where datname='template1';" -a
      psql -c "drop database Template1;" -a
      psql -c "create database template1 with owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;" -a
      psql -c "update pg_database set datistemplate=true where datname='template1';" -a
EOF
    # TODO: This is also requred in case of Ubuntu 14.04
    # sudo -u postgres createuser mgoyal -s
    # now restarting the postgres
    sudo /etc/init.d/postgresql restart
fi
# checking installation details
which psql
psql -V


###### Installing Watchman ######
echo "<--- Installing Watchman --->"
echo User: $USER
if which watchman > /dev/null ; then
    echo 'Watchman is already installed'
else
    # installing Watchman
    echo 'Refer: https://facebook.github.io/watchman/docs/install.html'
    sudo apt-get -y install build-essential
    sudo apt-get -y install python-dev
    git clone https://github.com/facebook/watchman.git
    cd watchman
    git checkout v4.5.0
    ./autogen.sh
    ./configure
    make
    sudo make install
fi
# check installation details
which watchman
watchman --version


###### Installing Node and NPM ######
echo "<--- Installing Node and NPM --->"
echo User: $USER
if which node > /dev/null ; then
    echo 'Node is already installed'
else
    # installing Node
    echo 'Refer: https://github.com/nodesource/distributions/tree/master/deb'
    sudo apt-get remove --purge nodejs npm
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
# check installation details
which node
which npm
node --version
npm -version


###### Installing EmberJS ######
echo "<--- Installing EmberJS --->"
echo User: $USER
if which ember > /dev/null ; then
    echo 'Ember is already installed'
else
    # installing EmberJS
    sudo npm install -g ember-cli
fi
# check installation details
which ember
ember --version


###### Installing Bower ######
echo "<--- Installing Bower --->"
echo User: $USER
if which bower > /dev/null ; then
    echo 'Bower is already installed'
else
    # installing Bower
    sudo npm install -g bower
fi
# check installation details
which bower
bower --version


###### Installing PhantomJS ######
echo "<--- Installing PhantomJS --->"
echo User: $USER
if which phantomjs > /dev/null ; then
    echo 'PhantomJS is already installed'
else
    # installing PhantomJS
    sudo npm install -g phantomjs
fi
# check installation details
which phantomjs
phantomjs --version


###### Installing Frontend Dependencies ######
echo "<--- Installing Frontend Dependencies --->"
echo User: $USER
npm install
cd /vagrant/frontend
npm install
bower install


###### Some Settings ######
echo "Creating 'vagrant' role for postgres, giving it superuser permissions, and trusting vagrant"
echo User: $USER
sudo -u postgres createuser vagrant --no-superuser --no-createdb --no-createrole
sudo su - postgres <<EOF
  psql -d template1 -c "ALTER USER vagrant with SUPERUSER;" -a
EOF
# Note that following operation is not idempotent 
# echo "local   all   vagrant   trust" | sudo tee --append /etc/postgresql/*/main/postgresql.conf    # permissions for vagrant user 


###### THE END ######
echo "<--- End of 'root_java_mysql_postgres_git_memcached_R' Script --->"

