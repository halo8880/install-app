#!/bin/bash
####################################
#
# Shell scrip Install Applications for Ubuntu14
#
####################################

# Color for echo
ECHO_START='\033[37;44m'
ECHO_STOP='\033[37;42m'
RESET="\033[0m"
ECHO_INFO='\033[0;32m'

FOLDER_CONTAIN_TOMCAT=$HOME"/tomcat"

main(){
	# Check if user is root
	who_am_i
	if [ $(id -u) != "0" ]
	    then
	        echo "ERROR: You must be root to run this script, use sudo sh $0";
	        exit 1;        
	    fi
	
	 export_LC
	 add_LC_enviroment_variable

	# install_axel
    # install_mysql
    # install_java8
    # install_java7
    # install_git
    # install_maven
    # install_tomcat7
    # install_tomcat8
    # install_vagrant
	# install_mongodb_org
	# install_elasticsearch
   	# install_sonarQube
   	# install_angular4
	# install_postgreSQL
	# install_docker
	 install_docker_compose
}


is_installed() {
    command -v "$1" >/dev/null 2>&1
    # How to use this function? -> Below
    #   if is_installed git; then
	# 		echo "git is installed"
	# 	else 
	# 		echo "git is not installed"
	# 	fi
}

who_am_i(){
	echo "#############Who Am I#############"
	echo " ========>$USER<========"
}

export_LC(){
	export LC_ALL=en_US.UTF-8
	export LANGUAGE=en_US.UTF-8
}

clear_dpkg(){
	echo "#############Clear DPKG##################"
	sudo rm /var/cache/apt/archives/lock
	sudo rm /var/lib/dpkg/lock
	echo "=======> Done"
}

# Application for get file faster, instead of wget -> axel
install_axel(){
	echo "$ECHO_START---------------------------------------------Starting Install Axel---------------------------------------------$RESET"
	apt-get install axel
}

install_mysql(){
    echo "$ECHO_START---------------------------------------------Starting Install MySQL---------------------------------------------$RESET"
    DEFAULT_PASSWORD="root"

    clear_dpkg
    sudo echo "mysql-server mysql-server/root_password password $DEFAULT_PASSWORD" | sudo debconf-set-selections
    sudo echo "mysql-server mysql-server/root_password_again password $DEFAULT_PASSWORD" | sudo debconf-set-selections
    sudo apt-get -y install mysql-server-5.6
    echo "$ECHO_STOP---------------------------------------------Installing MySQL Done---------------------------------------------$RESET"
}

install_java8(){
	echo "$ECHO_START---------------------------------------------Starting Install Java8---------------------------------------------$RESET"
	clear_dpkg
	sudo apt-get install -y python-software-properties debconf-utils
	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt-get update
	sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	sudo apt-get install -y oracle-java8-installer
	echo "------------------Set JDK8 Is Default-------------------"
	sudo apt-get install oracle-java8-set-default
	echo "$ECHO_STOP---------------------------------------------Installing Java8 Done---------------------------------------------$RESET"
}

# Install OpenJDK-7
install_java7(){
	echo "$ECHO_START---------------------------------------------Starting Install Java7---------------------------------------------$RESET"
	clear_dpkg
	apt-get update
	echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	apt-get install -y openjdk-7-jdk
	echo "-------------------Set JAVA_HOME-----------------"
	JAVA_HOME="JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/"
	ENVIROMENT_FILE=/etc/environment
	#tee -a FILE write new line in last file. 
	#Or can use command sudo sed -i '$ a text to be inserted' FILE ($ select end of file, a tells it append)
	#echo $JAVA_HOME | sudo tee -a $ENVIROMENT_FILE
	sudo sed -i "$ a $JAVA_HOME" $ENVIROMENT_FILE
	echo "$ECHO_STOP---------------------------------------------Installing Java7 Done---------------------------------------------$RESET"
}

install_git(){
	echo "$ECHO_START---------------------------------------------Starting Install GIT---------------------------------------------$RESET"
	clear_dpkg
	sudo apt-add-repository ppa:git-core/ppa -y
	sudo apt-get update
	sudo apt-get install -y git
	echo "$ECHO_STOP---------------------------------------------Installing GIT Done---------------------------------------------$RESET"
}

# Reference to https://www.mkyong.com/maven/how-to-install-maven-in-ubuntu/
# Install the Maven in /usr/share/maven
# The Maven configuration files are stored in /etc/maven
install_maven(){
	echo "$ECHO_START---------------------------------------------Starting Install Maven---------------------------------------------$RESET"
	clear_dpkg
	sudo apt-cache search maven
	sudo apt-get install -y maven
	echo "$ECHO_STOP---------------------------------------------Installing Maven Done---------------------------------------------$RESET"
}

# This version of Tomcat is 7.0.81 by download .tar.gz file from https://tomcat.apache.org/download-70.cgi
# Please check this link before run this script. If this one not exist, please replace the link form https://tomcat.apache.org/download-70.cgi
install_tomcat7(){
	echo "$ECHO_START---------------------------------------------Starting Install Tomcat 7---------------------------------------------$RESET"
	URL="http://www-eu.apache.org/dist/tomcat/tomcat-7/v7.0.81/bin/apache-tomcat-7.0.81.tar.gz"
	FILE_NAME=$(basename "$URL")

	mkdir -p $FOLDER_CONTAIN_TOMCAT
	chmod 777 -R $FOLDER_CONTAIN_TOMCAT
	cd $FOLDER_CONTAIN_TOMCAT
	echo "==>File name Tomcat7 download: $FILE_NAME"

	if is_installed axel; then
		echo "axel is installed"
		axel $URL
	else 
		echo "axel is not installed"
		wget $URL
	fi

	tar -xvzf $FILE_NAME
	cd $HOME
	pwd
	echo "$ECHO_STOP---------------------------------------------Installing Tomcat 7 Done---------------------------------------------$RESET"
}

# This version of Tomcat is 8.5.20 by download .tar.gz file from https://tomcat.apache.org/download-80.cgi
# Please check this link before run this script. If this one not exist, please replace the link form https://tomcat.apache.org/download-80.cgi
install_tomcat8(){
	echo "$ECHO_START---------------------------------------------Starting Install Tomcat 8---------------------------------------------$RESET"
	URL="http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz"
	FILE_NAME=$(basename "$URL")

	mkdir -p $FOLDER_CONTAIN_TOMCAT
	chmod 777 -R $FOLDER_CONTAIN_TOMCAT
	cd $FOLDER_CONTAIN_TOMCAT
	echo "==>File name Tomcat8 download: $FILE_NAME"
	
	if is_installed axel; then
		echo "axel is installed"
		axel $URL
	else 
		echo "axel is not installed"
		wget $URL
	fi

	tar -xvzf $FILE_NAME
	cd $HOME
	pwd
	echo "$ECHO_STOP---------------------------------------------Installing Tomcat 8 Done---------------------------------------------$RESET"
}

# This version of Vagrant is 1.9.8 (x64) by download .deb file from https://www.vagrantup.com/downloads.html
# Please check this link (URL) before run this script. If this one not exist, please replace the link from https://www.vagrantup.com/downloads.html or http://vagrant-deb.linestarve.com/pool/main/v/vagrant/
install_vagrant(){
	#If OS doesn't install vitualbox yet. Must to install vitualbox first.
	install_vitualbox

	echo "$ECHO_START---------------------------------------------Starting Install Vagrant---------------------------------------------$RESET"
	FOLDER_CONTAIN_VAGRANT="$HOME/vagrant"
	URL="http://vagrant-deb.linestarve.com/pool/main/v/vagrant/vagrant_1.9.8_x86_64.deb"
	FILE_NAME=$(basename "$URL")

	echo "==>File name Vagrant download: $FILE_NAME"
	mkdir -p $FOLDER_CONTAIN_VAGRANT
	chmod 777 -R $FOLDER_CONTAIN_VAGRANT
	cd $FOLDER_CONTAIN_VAGRANT

	if is_installed axel; then
		echo "axel is installed"
		axel $URL
	else 
		echo "axel is not installed"
		wget $URL
	fi

	dpkg -i $FILE_NAME
	cd $HOME
	echo "$ECHO_STOP---------------------------------------------Installing Vagrant Done---------------------------------------------$RESET"
}

install_vitualbox(){
	echo "$ECHO_START---------------------------------------------Starting Install Virtualbox---------------------------------------------$RESET"
	clear_dpkg
	apt-get update
	apt-get install -y virtualbox 
	echo "$ECHO_STOP---------------------------------------------Installing Virtualbox Done---------------------------------------------$RESET"
}

install_mongodb_org(){
	echo "$ECHO_START---------------------------------------------Starting Install MongoDB ORG---------------------------------------------$RESET"
	clear_dpkg
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
	sudo apt-get update
	sudo apt-get install -y mongodb-org
	echo " ==> Mongo Status: `service mongod status`"
	# service mongod stop, service mongod start

	# Set up $USER_NAME user to Database Admin for auth any database
	USER_NAME="root"
	PASSWORD="root"
	COMMAND_CREAT_USER="{user: '$USER_NAME', pwd: '$PASSWORD', roles:[{role: 'userAdminAnyDatabase', db: 'admin'}]}"
	mongo admin <<EOF
	db.createUser($COMMAND_CREAT_USER)
	quit()
EOF

	service mongod stop
	service mongod start
	echo " ==> Mongo Status: `service mongod status`"
	echo "$ECHO_STOP---------------------------------------------Installing MongoDB ORG Done---------------------------------------------$RESET"
}

# This version of EclasticSearch is 2.4.6 (x64) by download .deb file from https://www.elastic.co/downloads/elasticsearch or https://www.elastic.co/downloads/past-releases
# Please check this link (URL) before run this script. 
# If this one not exist, please replace the link from https://www.elastic.co/downloads/elasticsearch or https://www.elastic.co/downloads/past-releases and chose the .DEP file
# Folder Installed = /usr/share/elasticsearch
# Config = /etc/elasticsearch/elasticsearch.yml - To remote edit network.host=0.0.0.0
install_elasticsearch(){
	echo "$ECHO_START---------------------------------------------Starting Install Elasticsearch---------------------------------------------$RESET"
	clear_dpkg
	FOLDER_CONTAIN_ELASTIC="$HOME/elastic"
	URL="https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.4.6/elasticsearch-2.4.6.deb"
	FILE_NAME=$(basename "$URL")

	echo "==>File name Elastic download: $FILE_NAME"
	mkdir -p $FOLDER_CONTAIN_ELASTIC
	chmod 777 -R $FOLDER_CONTAIN_ELASTIC
	cd $FOLDER_CONTAIN_ELASTIC

	wget $URL

	dpkg -i $FILE_NAME
	cd $HOME

	service elasticsearch start

	echo "$ECHO_STOP---------------------------------------------Installing Elasticsearch Done---------------------------------------------$RESET"
}

install_sonarQube(){
	echo "$ECHO_START---------------------------------------------Starting Install sonarQube---------------------------------------------$RESET"
	clear_dpkg

	if is_installed java; then
		echo "java is installed"
	else 
		echo "java is not installed. Will be install java 8 now.."
		install_java8
	fi

	if is_installed mysql; then
		echo "Mysql is installed"
	else 
		echo "Mysql is not installed. Will be install mysql now.."
		install_mysql
	fi

	apt-get install rpl -y

	# Create database and user sonarqube
	DATABASE_NAME="sonarqube"
	USERNAME_ROOT="root"
	PASSWORD_ROOT="root"
	USERNAME_SONAR="sonarqube"
	PASSWORD_SONAR="sonarqube"
	echo "CREATE DATABASE sonarqube;" | mysql -u $USERNAME_ROOT -p$PASSWORD_ROOT
	echo "GRANT ALL PRIVILEGES on $DATABASE_NAME.* to $USERNAME_SONAR@'localhost' IDENTIFIED BY '$PASSWORD_SONAR';" | mysql -u $USERNAME_ROOT -p$PASSWORD_ROOT
	echo "FLUSH PRIVILEGES;" | mysql -u $USERNAME_ROOT -p$PASSWORD_ROOT
	echo " ====>Create database and user sonarqube DONE."

	# Install Nginx as a Reverse Proxy
	wget -c -O- http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
	echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" | sudo tee -a /etc/apt/sources.list.d/nginx.list > /dev/null
	sudo apt-get update
	sudo apt-get -y install nginx
	sudo mkdir /etc/nginx/sites-available
    sudo mkdir /etc/nginx/sites-enabled
    # OLD_1="include /etc/nginx/conf.d/"
    # NEW_1="include /etc/nginx/sites-enabled/"
    # sed -i 's?$OLD_1?$NEW_1?g' /etc/nginx/nginx.conf
    # Another way use rpl (apt-get install rpl) -> rpl "old_string" "new_string" file.txt
    OLD_1="include /etc/nginx/conf.d/*.conf;"
    NEW_1="include /etc/nginx/sites-enabled/*.conf;"
    rpl -i -w "$OLD_1" "$NEW_1" /etc/nginx/nginx.conf
    sudo rm -f /etc/nginx/conf.d/*
    echo " ====>Install Nginx as a Reverse Proxy DONE."

    # Http only configuration
    CONTENT="server { listen 80 default_server; listen [::]:80 default_server;server_name acton.sonarqube.com; root /usr/share/nginx/sonarqube;proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; proxy_set_header Host $host; proxy_set_header X-Forwarded-Proto $scheme;location / { proxy_pass http://localhost:9000; } }"
    SONA_CONF="/etc/nginx/sites-available/sonarqube.conf"
    touch $SONA_CONF
    echo $CONTENT | sudo tee -a $SONA_CONF
    sudo ln -sf /etc/nginx/sites-available/sonarqube.conf /etc/nginx/sites-enabled/sonarqube.conf
    sudo service nginx restart
	echo " ====>Http only configuration DONE"

	# Install Sonarqube From Repository
	echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" | sudo tee -a /etc/apt/sources.list.d/sonarqube.list > /dev/null
	sudo apt-get update
	sudo apt-get -y --force-yes install sonar
	SONAQUBE_PROPERTIES="/opt/sonar/conf/sonar.properties"

	# rpl -i -w "#sonar.jdbc.username=" "sonar.jdbc.username=$USERNAME_SONAR" $SONAQUBE_PROPERTIES
	# rpl -i -w "#sonar.jdbc.password=" "sonar.jdbc.password=$PASSWORD_SONAR" $SONAQUBE_PROPERTIES
	# rpl -i -w "#sonar.jdbc.url=jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" "sonar.jdbc.url=jdbc:mysql://localhost:3306/$DATABASE_NAME?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" $SONAQUBE_PROPERTIES
	# rpl -i -w "#sonar.web.host=0.0.0.0"  "sonar.web.host=0.0.0.0" $SONAQUBE_PROPERTIES

	echo "sonar.jdbc.username=$USERNAME_SONAR" | sudo tee -a $SONAQUBE_PROPERTIES
	echo "sonar.jdbc.password=$PASSWORD_SONAR" | sudo tee -a $SONAQUBE_PROPERTIES
	echo "sonar.jdbc.url=jdbc:mysql://localhost:3306/$DATABASE_NAME?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance" | sudo tee -a $SONAQUBE_PROPERTIES
	echo "sonar.web.host=0.0.0.0" | sudo tee -a $SONAQUBE_PROPERTIES

	sudo service sonar start

	echo "$ECHO_STOP---------------------------------------------Installing sonarQube Done---------------------------------------------$RESET"
}

install_angular4(){
	echo "$ECHO_START---------------------------------------------Starting Install Angular 4---------------------------------------------$RESET"
	# Check nodejs installed
	if is_installed node; then
		echo "$ECHO_INFO nodejs is installed"
	else 
		echo "$ECHO_INFO nodejs is not installed. Will be install nodejs now.."
		install_nodejs
	fi

	# Install Angular
	echo "$ECHO_INFO ====> Continue install Angular ."
	sudo npm install -g @angular/cli
	ng -v
	echo "$ECHO_INFO ====> Install Angular done."

	# Check Typescript installed
	if is_installed tsc; then
		echo "$ECHO_INFO Typescript is installed"
	else 
		echo "$ECHO_INFO Typescript is not installed. Will be install Typescript now.."
		install_typescript
	fi
	
	echo "$ECHO_STOP---------------------------------------------Installing Angular 4---------------------------------------------$RESET"
}

install_nodejs(){
	echo "$ECHO_START---------------------------------------------Starting Install Nodejs ---------------------------------------------$RESET"
	# Install nodejs
	sudo apt-get install python-software-properties
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt-get install nodejs
	node -v
	npm -v
	echo "$ECHO_STOP---------------------------------------------Installing Nodejs Done---------------------------------------------$RESET"
}

install_typescript(){
	echo "$ECHO_START---------------------------------------------Starting Install Typescript---------------------------------------------$RESET"
	# Install Typescript
	sudo npm install -g typescript
	tsc -v
	sudo npm install -g gulp
	gulp -v
	echo "$ECHO_INFO ====> Install Typescript done."
	echo "$ECHO_STOP---------------------------------------------Installing Typescript Done---------------------------------------------$RESET"
}


install_postgreSQL(){
	echo "$ECHO_START---------------------------------------------Starting Install PostgreSQL---------------------------------------------$RESET"
	sudo apt-get update
	sudo apt-get install -y postgresql postgresql-contrib
	echo "$ECHO_STOP---------------------------------------------Installing PostgreSQL Done---------------------------------------------$RESET"
}


add_LC_enviroment_variable(){
	echo "##############Update LC Varivable in bashrc#############"
	FILE_BASHRC="$HOME/.bashrc"
	echo "export LC_ALL=en_US.UTF-8" | sudo tee -a $FILE_BASHRC
	echo "export LANGUAGE=en_US.UTF-8" | sudo tee -a $FILE_BASHRC
	echo "############Done. Please run command source $FILE_BASHRC or Reload machine to apply Enviroment Variable################"
	#locale
}

install_docker(){
	echo "$ECHO_START---------------------------------------------Starting installing docker---------------------------------------------$RESET"
	sudo apt-get install -y \
		linux-image-extra-$(uname -r) \
		linux-image-extra-virtual
		
	sudo apt-get install \
		apt-transport-https \
		ca-certificates \
		curl \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	# To check the fingerprint
	# pub   4096R/0EBFCD88 2017-02-22
    # Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
	# uid                  Docker Release (CE deb) <docker@docker.com>
	# sub   4096R/F273FCD8 2017-02-22
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	echo "$ECHO_STOP---------------------------------------------Installing Docker Done---------------------------------------------$RESET"
}

install_node(){
	echo "$ECHO_START---------------------------------------------Starting Installing Node---------------------------------------------$RESET"
	sudo apt-get install -y node
	echo "$ECHO_STOP---------------------------------------------Installing Node---------------------------------------------$RESET"
}
install_yarn(){
	echo "$ECHO_START---------------------------------------------Starting Installing Yarn---------------------------------------------$RESET"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt-get update && sudo apt-get install -y yarn
	echo "$ECHO_STOP---------------------------------------------Installing Yarn finished---------------------------------------------$RESET"
}
install_docker_compose(){
	echo "$ECHO_START---------------------------------------------Starting Installing docker-compose---------------------------------------------$RESET"
	sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	echo "$ECHO_STOP---------------------------------------------Installing docker-compose finished---------------------------------------------$RESET"
}
main

exit 0