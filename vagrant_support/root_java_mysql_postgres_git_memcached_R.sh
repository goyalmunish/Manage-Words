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


###### Installing Oracle Java 6 ######
echo "<--- Installing Oracle Java 6 --->"
echo User: $USER
if which java > /dev/null ; then
    echo 'Java is already installed'
else
    # installing java
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
# sudo apt-get install r-base


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
    echo "# local   all   vagrant   trust" | sudo tee --append /etc/postgresql/*/main/postgresql.conf    # permissions for vagrant user 
    sudo su - postgres <<EOF
      postgres_postgres_passwd_quoted="'$postgres_postgres_passwd'"
      psql -d template1 -c "ALTER USER postgres with encrypted password $postgres_postgres_passwd_quoted;" -a # TODO: Note: executing single command in postgres
EOF
    # exit
    sudo /etc/init.d/postgresql restart
fi
# checking installation details
which psql
psql -V


###### Some Settings ######
echo "Creating 'vagrant' role for postgres, giving it superuser permissions, and trusting vagrant"
echo User: $USER
sudo -u postgres createuser vagrant --no-superuser --no-createdb --no-createrole
sudo su - postgres <<EOF
  psql -d template1 -c "ALTER USER vagrant with SUPERUSER;" -a
EOF
# exit
# Note that following operation is not idempotent 
# echo "local   all   vagrant   trust" | sudo tee --append /etc/postgresql/*/main/postgresql.conf    # permissions for vagrant user 


###### THE END ######
echo "<--- End of 'root_java_mysql_postgres_git_memcached_R' Script --->"

