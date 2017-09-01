# wordpresstask

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

# Compatibiltiy
Tested and Deployed on AWS using Ubantu 16.04.2 
Check live link here[here:http://13.126.108.99/](http://13.126.108.99/) 
