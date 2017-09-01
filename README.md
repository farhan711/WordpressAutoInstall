# Wordpresstask

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
# Mysql-server must not installed for old Run.sh
```
sudo apt-get remove --purge mysql-server 
sudo apt-get autoremove
sudo apt-get autoclean
```

# Installation 
```
git clone https://github.com/farhan711/wordpresstask.git
apt-add-repository ppa:ondrej/php
apt-get update
chmod +x wordpress.sh
./wordpress.sh
```

# Compatibility
Tested and Deployed on AWS using Ubuntu 16.04.2 

Check live link here [here:http://13.126.108.99/](http://13.126.108.99/) 
