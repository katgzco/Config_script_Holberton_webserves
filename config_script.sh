#!/usr/bin/env bash

# web server -> install nginx, redirection, custom error page
# load balancer -> custom header in response.
# airbnb clone_2 -> create folders for resources, 

#CLEAN SERVER
#unistall nginx
sudo apt-get -y remove nginx nginx-common
sudo apt-get -y purge nginx nginx-common
sudo apt-get -y autoremove
sudo rm -rf /data

#NGINX INSTALL
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx

#BACKUP DEFAULTCONFIG
sudo mkdir -p backup_default
sudo cp /etc/nginx/sites-available/default ~/backup_default/available_default
sudo cp /etc/nginx/sites-enabled/default ~/backup_default/enabled_default
sudo cp /etc/nginx/nginx.conf ~/backup_default/nginx_default

#permissions
sudo chmod 765 /var/www/html
sudo chmod 765 /etc/nginx/sites-available/default

#web server -> redirect
echo "Holberton School" > /var/www/html/index.nginx-debian.html
sudo sed -i '/server_name _;/a \\trewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;' /etc/nginx/sites-available/default

#load balancer add header
sudo sed -i '/index index.html index.htm index.nginx-debian.html;/ a \\n\tadd_header '"'"'X-Served-By'"'"' $hostname;' /etc/nginx/sites-available/default

#web server -> custom error page
sudo touch /usr/share/nginx/html/error_404.html
sudo chmod 766 /usr/share/nginx/html/error_404.html
echo "Ceci n'est pas une page" > /usr/share/nginx/html/error_404.html
sudo sed -i '/server_name _;/a \\terror_page 404 /error_404.html;\n\t\tlocation = /error_404.html {\n\t\troot /usr/share/nginx/html;\n\t\tinternal;\n\t\t}' /etc/nginx/sites-available/default

#Airbnb clone 2
sudo mkdir -p /data/web_static/shared/
sudo mkdir -p /data/web_static/releases/test/
sudo tee -a /data/web_static/releases/test/index.html > /dev/null << END
<html >
<head >
</head >
<body >
Holberton School
</body >
</html >
END
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -R ubuntu:ubuntu /data
sudo sed -i '/server_name _;/a \\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}' /etc/nginx/sites-available/default
#restart nginx
sudo service nginx restart

#PPRUEBAS

#redireccion
# ip/redirect_me

error
# ip/error

#Airbnb2 -> creacion data
#curl localhost/hbnb_static/index.html
