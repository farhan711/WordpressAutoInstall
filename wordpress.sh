
TEMP="`mktemp`"
#Defining echo function
#defining white color for Success.
        function ee_info()
        {
                        echo $(tput setaf 7)$@$(tput sgr0)
        }

        #defining blue color for Running.
                function ee_echo()
                {
                                echo $(tput setaf 4)$@$(tput sgr0)
                }
                #Defining red color for Error
                        function ee_fail()
                        {
                                        echo $(tput setaf 1)$@$(tput sgr0)
                        }
clear
                        ee_echo "Here We Go..."
#Checking User Authentication
        if [[ $EUID -eq 0 ]]; then
                ee_info "Thank you for giving me a SUDO user privilege"
        else
                ee_fail "I need a SUDO privilage !! :( "
                ee_fail "Use: sudo bash wordpress.sh"
        exit 1
        fi

ee_info "You have passed the Authentication part."

#UPDATING UBUNTU
ee_echo "Let me Update your System. Please wait..."
        apt-get update &>> /dev/null
ee_info "Finally this system is ready for installing PHP,MYSQL,NGINX $ WORDPRESS"
#CHECKING DPKG PACKAGE IS INSTALLED OR NOT
                ee_echo "Checking whether you have dpkg installed or not"
        if [[ ! -x /usr/bin/dpkg ]]; then
                ee_echo "You don't have dpkg package. Let me install it for you, please wait.."
        apt-get -y install dpkg &>> /dev/null
        else
                ee_info "You already have dpkg installed"
fi
#CHEKING WGET PACKAGE IS INSTALLED OR NOT
                ee_echo "Checking whether you have wget package is installed or not"
        if [[ ! -x /usr/bin/wget ]]; then
                ee_fail "You don't have wget package installed."
                ee_echo "Let me install the wget packages on your system."
        apt-get -y install wget &>> /dev/null
        else
                ee_info "You already have wget installed."
        fi
#CHEKING TAR PACKAGE IS INSTALLED OR NOT
                ee_echo "Checking whether you have tar packages is installed or not."
        dpkg -s tar &>> /dev/null
        if [ $? -ne 0 ]; then
                ee_fail "You don't have tar package installed."
                ee_echo "Let me install the tar packages on your system."
        apt-get -y install tar &>> /dev/null
        else
                ee_info "You already have tar installed."
        fi
#CHECKING PHP7 PACKAGES/DEPENDENCIES/INSTALLING
                ee_echo "Checking whether you have PHP and it's dependencies installed or not"
        dpkg -s php7.0 &>> /dev/null && dpkg -s php7.0-fpm &>> /dev/null dpkg -s php7.0-mysql &>> /dev/null
        if [ $? -ne 0 ]; then
                ee_fail "I need to install php7.0 with it's dependencies, please wait.."
        apt-get -y install php7.0 &>> /dev/null && apt-get -y install php7.0-fpm &>> /dev/null && apt-get -y install php7.0-mysql &>> /dev/null
                if [ $? -ne 0 ]; then
                ee_fail "Something is wrong in PHP configuration please check the dependencies...."
                fi
        else
                ee_info "You have PHP and it's dependencies already installed"
        fi
#CHECKING MYSQL-SERVER PACKAGES/DEPENDENCIES/INSTALLING
                ee_echo "Checking whether you have MYSQL installed or not"
        dpkg -s mysql-server &>> /dev/null
        if [ $? -ne 0 ]; then
                ee_fail "I need to install mysql-server, please wait..."
        #GENERATING MY-SQL-ROOT PASSWORD
        password=$(date | md5sum | head -c 9)
        echo mysql-server mysql-server/root_password password $password | sudo debconf-set-selections
        echo mysql-server mysql-server/root_password_again password $password | sudo debconf-set-selections
        apt-get install -y mysql-server &>> /dev/null
                ee_fail " Your MySQL PASSWORD is = $password "
        else
                ee_info "MYSQL is already installed"
        fi
#CHECKING NGINX PACKAGES/DEPENDENCIES/INSTALLATION
                ee_echo "Checking whether you have NGINX installed or not"
        dpkg -s nginx &>> /dev/null
        if [ $? -ne 0 ]; then
                ee_fail "I need to install nginx ,please wait.."
                apt-get install -y nginx &>> /dev/null
        else
                ee_info "Nginx is already installed"
        fi
#ASKING USER FOR DOMAIN NAME
        for (( ;; )); do
        read -p "Enter the domain name (eg.wordpress.com): " example_com
        grep $example_com /etc/hosts &>> /dev/null
        if [ $? -eq 0 ]; then
        ee_fail "SORRY This Domain name is already been taken"
        else
        break
        fi
        done
        ee_info "Final domain name is $example_com"
        echo "127.0.0.1 $example_com" | tee -a /etc/hosts &>> /dev/null
#CREATING NGINX CONFIG FILES FOR EXAMPLE.COM
        tee /etc/nginx/sites-available/$example_com << EOF
server {
        listen   80;


        root /var/www/$example_com;
        index index.php index.html index.htm;

        server_name $example_com;

        location / {
                try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
        }

        error_page 404 /404.html;

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
              root /usr/share/nginx/www;
        }

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        location ~ \.php\$ {
                try_files \$uri =404;
                #fastcgi_pass 127.0.0.1:9000;
                # With php7.0-fpm:
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
                fastcgi_index index.php;
                include fastcgi.conf;
                include fastcgi_params;
                 }
   }
EOF
        ln -sF /etc/nginx/sites-available/$example_com /etc/nginx/sites-enabled/$example_com
        rm -rf /etc/nginx/sites-available/default &>> /dev/null
        apt-get remove -y apache2 &>> /dev/null
        service nginx restart >> $TEMP 2>&1
        if [ $? -eq 0 ]; then
                ee_info "Nginx is successfull installed"
        else
                ee_fail "ERROR! Use:>>>sudo nginx -t<<<< in Terminal"
        fi
        service php7.0-fpm restart >> $TEMP 2>&1
        ee_fail "CHILL !! The above is your config file."
#DOWNLOADING LATEST VERSION FROM WORDPRESS.ORG THEN UNZIP IT LOCALLY IN EXAMPLE COM/ DOCUMENT ROOM.
                ee_echo " I am going to download wordpress from http://wordpress.org/latest.tar.gip please wait.."
         cd ~ && wget http://wordpress.org/latest.tar.gz >> $TEMP 2>&1
        if [ $? -eq 0 ]; then
                ee_info "Latest wordpress has been downloaded Successfully"
        else
                ee_fail "ERROR:Failed to get latest tar file, Please check log files $TEMP" 1>&2
        fi
#EXTRACTING THE LATEST TAR FILES
                ee_echo "Let me extract the tar file"
        cd ~ && tar xzvf latest.tar.gz &>> /dev/null && mv wordpress $example_com &>> /dev/null
        if [ $? -eq 0 ]; then
                ee_info "Your file has been rename and extracted Successfully"
        cp -rf $example_com /var/www/
        fi
        rm -rf latest.tar.gz &>> /dev/null
#CREATING A NEW MYSQL-DATABASE FOR WORDPRESS,ADDRESS NAME MUST BE EXAMPLE_COM_DB
        db_name="_db"
        db_root_passwd="$password"
        mysql -u root -p$db_root_passwd << EOF
        CREATE DATABASE ${example_com//./_}$db_name;
        CREATE USER ${example_com//./_}@localhost;
        SET PASSWORD FOR ${example_com//./_}@localhost=PASSWORD("$password");
        GRANT ALL PRIVILEGES ON ${example_com//./_}$db_name.* TO ${example_com//./_}@localhost IDENTIFIED BY '$password';
        FLUSH PRIVILEGES;
        #exit;
EOF
        if [ $? -eq 0 ]; then
                ee_info "FINALLY YOUR DATABASE SETTING HAS BEEN SETUP"
                ee_info "Your database name assumed to be = ${example_com//./_}$db_name "
                ee_info "And Database password = $password"
                ee_fail "Kindly please note it down your MYSQL-ROOT password = $db_root_passwd "
        else
                ee_fail "Ops!! something goes wrong"
        fi
#CREATING WP-CONFIG.PHP WITH PROPER DB CONFIGURATION.
        cp /var/www/$example_com/wp-config-sample.php /var/www/$example_com/wp-config.php
        sed -i "s/\(.*'DB_NAME',\)\(.*\)/\1'${example_com//./_}$db_name');/" /var/www/$example_com/wp-config.php
        sed -i "s/\(.*'DB_USER',\)\(.*\)/\1'${example_com//./_}');/" /var/www/$example_com/wp-config.php
        sed -i "s/\(.*'DB_PASSWORD',\)\(.*\)/\1'$password');/" /var/www/$example_com/wp-config.php

#CREATING SECURITY WP-CONFIG
#define('AUTH_KEY',         'Ap2g08@ON7e-j]?+E.csw>-{2hkE!()#rb7gD]q|&;C4@3455AL_=1LQZ92u|IH}');
#define('SECURE_AUTH_KEY',  'OKuteSM`D=6LVHR+cDbG_cBQ}w@-;>!{T*fy?g{.O(^{V }ygFO:Gc$m9.Iwz~I{');
#define('LOGGED_IN_KEY',    'eKR=za5g(>GZr(`{-n8j86aM]L>Imhg@hO/kyv954MVeslHtT+sCq}^|OVQrrq^B');
#define('NONCE_KEY',        'e_Cc;YTW,y3Cplk{4^AFcnQOvtL%+G6CYAK$=yiq;#d?%11SlkYR8CQD$C/S|8Mq');
#define('AUTH_SALT',        'sDj8&?Blr|r_x%;wqA069^O8?5+G8@7hZD`{0|RN=kp>H)Us(]wv.6Mu,M)%cF.a');
#define('SECURE_AUTH_SALT', 'do}{{It04FMH+Su+#[(0lC-Khvc2[DO`Xy;}348?_Ah|INH[t~5:|m.JlegN%t&g');
#define('LOGGED_IN_SALT',   'O7|C5K-u+jkc~kf^hlf6t:|-;,5HI]d4G 2mK_h|~FZ!uifbcE:UAHExyB)$0a.+');
#define('NONCE_SALT',       'k:d6U3,|YiE^36Un-8xl99?Uz|M[x#{yI-K?0{-- &2T-J-mfr#;|XxrQFop&^Z+');
sed -i 's/\(.*'\''AUTH_KEY'\'',\)\(.*\)/\1'\''Ap2g08@ON7e-j]?+E.csw>-{2hkE!()#rb7gD]q|\&;C4@3455AL_=1LQZ92u|IH}'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''SECURE_AUTH_KEY'\'',\)\(.*\)/\1'\''OKuteSM`D=6LVHR+cDbG_cBQ}w@-;>!{T*fy?g{.O(^{V }ygFO:Gc$m9.Iwz~I{'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''LOGGED_IN_KEY'\'',\)\(.*\)/\1'\''eKR=za5g(>GZr(`{-n8j86aM]L>Imhg@hO\/kyv954MVeslHtT+sCq}^|OVQrrq^B'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''NONCE_KEY'\'',\)\(.*\)/\1'\''e_Cc;YTW,y3Cplk{4^AFcnQOvtL%+G6CYAK$=yiq;#d?%11SlkYR8CQD$C\/S|8Mq'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''AUTH_SALT'\'',\)\(.*\)/\1'\''sDj8\&?Blr|r_x%;wqA069^O8?5+G8@7hZD`{0|RN=kp>H)Us(]wv.6Mu,M)%cF.a'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''SECURE_AUTH_SALT'\'',\)\(.*\)/\1'\''do}{{It04FMH+Su+#[(0lC-Khvc2[DO`Xy;}348?_Ah|INH[t~5:|m.JlegN%t\&g'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''LOGGED_IN_SALT'\'',\)\(.*\)/\1'\''O7|C5K-u+jkc~kf^hlf6t:|-;,5HI]d4G 2mK_h|~FZ!uifbcE:UAHExyB)$0a.+'\'');/' /var/www/$example_com/wp-config.php
sed -i 's/\(.*'\''NONCE_SALT'\'',\)\(.*\)/\1'\''k:d6U3,|YiE^36Un-8xl99?Uz|M[x#{yI-K?0{-- \&2T-J-mfr#;|XxrQFop\&^Z+'\'');/' /var/www/$example_com/wp-config.php
#ASSIGNING PERMISSION TO DIRECTORY
        chown www-data:www-data * -R /var/www/
        chmod -R 755 /var/www
        service nginx restart >> $TEMP 2>&1
        if [ $? -eq 0 ]; then
                ee_info "Nginx is successfull installed"
        else
                ee_fail "ERROR! Use:>>>sudo nginx -t<<<< in Terminal"
        fi
        service php7.0-fpm restart >> $TEMP 2>&1

ee_info "Kindly open your browser with this link >>> http://$example_com And perform rest of the operation. "
