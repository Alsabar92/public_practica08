#Descargamos CMS de Wordpress y extraemos en el directorio Web
cd /var/www/html
wget https://es.wordpress.org/latest-es_ES.tar.gz
tar -xvf latest-es_ES.tar.gz
rm -r latest-es_ES.tar.gz
mv /var/www/html/wordpress/* /var/www/html
rm -r wordpress



#Configuramos el fichero wp-config.php
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
echo "define ( 'WP_SITEURL', 'http://$IP_BALANCER' );" >> /var/www/html/wp-config.php
echo "define ( 'WP_HOME', 'http://$IP_BALANCER' );" >> /var/www/html/wp-config.php
sed -i 's/nombredetubasededatos/wordpress/' /var/www/html/wp-config.php
sed -i 's/nombredeusuario/wpuser/' /var/www/html/wp-config.php
sed -i 's/contraseña/wpuser/' /var/www/html/wp-config.php
sed -i 's/localhost/3.95.9.19/' /var/www/html/wp-config.php


#Instauramos las security keys
sed -i '/AUTH_KEY/d' /var/www/html/wp-config.php
sed -i '/NONCE_KEY/d' /var/www/html/wp-config.php
sed -i '/LOGGED_KEY/d' /var/www/html/wp-config.php
sed -i '/AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/SECURE_AUTH_SALT/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_SALT/d' /var/www/html/wp-config.php
sed -i '/NONCE_SALT/d' /var/www/html/wp-config.php
sed -i '/LOGGED_IN_KEY/d' /var/www/html/wp-config.php

KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
KEYS=$(echo $KEYS | tr / _)
sed -i "/#@-/a $KEYS" /var/www/html/wp-config.php

#Borramos index.html
rm index.html

#Movemos el htaccess a la carpeta raíz
cd $HOME/public_practica08
mv htaccess /var/www/html/.htaccess


# Instalamos el paquete Servidor de NFS
apt-get install nfs-kernel-server -y
systemctl start nfs-kernel-server

# Quitamos pertenencias a la carpeta a compartir
chown nobody:nogroup /var/www/html

# Editamos el fichero de archivos compartidos
echo "/var/www/html     $IP_SLAVE(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports

#Volvemos a darle derecho a las carpetas de Wordpress
chown www-data:www-data /var/www/html/wp-admin/ /var/www/html/wp-content/ /var/www/html/wp-includes/ -R

# Reiniciamos el servicio.
systemctl restart nfs-kernel-server