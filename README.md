# Wordpress Auto Install

1) Your script will check if PHP, Mysql & Nginx are installed. If not present, missing packages will be installed.

2) The script will then ask user for domain name. (Suppose user enters example.com)

3) Create a /etc/hosts entry for example.com pointing to localhost IP.

4) Create nginx config file for example.com

5) Download WordPress latest version from http://wordpress.org/latest.zip and unzip it locally in example.com document root.

6) Create a new mysql database for new WordPress. (database name “example.com_db” )

7) Create wp-config.php with proper DB configuration. (You can use wp-config-sample.php as your template)

8) You may need to fix file permissions, cleanup temporary files, restart or reload nginx config.

9) Tell user to open example.com in browser (if all goes well)


# Prerequisite

NginX is Required 
```
sudo apt-get remove --purge <!Nginx||WebServerPackageName>
sudo apt-get autoremove
sudo apt-get autoclean
```
# Mysql-server must not installed 

Used MARIADB
```
sudo apt-get remove --purge mysql-server 
sudo apt-get autoremove
sudo apt-get autoclean
```

# Installation 
```
git clone https://github.com/farhan711/WordpressAutoInstall.git
apt-add-repository ppa:ondrej/php
apt-get update
cd WordpressAutoInstall
chmod +x wordpress.sh
sudo ./wordpress.sh
```

# Compatibility
Tested and Deployed on AWS using [VM] Ubuntu 18.*



Check It's Running on NginX Server 

```netstat -tlnp```
```
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      13338/mysqld
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      14623/nginx -g daem
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1291/sshd
tcp6       0      0 :::22                   :::*                    LISTEN      1291/sshd

```
