#Descargamos CMS de Wordpress y extraemos en el directorio Web
cd /var/www/html
wget https://es.wordpress.org/latest-es_ES.tar.gz
tar -xvf latest-es_ES.tar.gz
rm -r latest-es_ES.tar.gz
cd /wordpress
mv * ..
cd ..
rm -r wordpress/


#Configuramos el fichero wp-config.php
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
echo "define ( 'WP_SITEURL', 'http://$IP_BALANCER' );" >> /var/www/html/wp-config.php
echo "define ( 'WP_HOME', 'http://$IP_BALANCER' );" >> /var/www/html/wp-config.php
sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sed -i 's/username_here/wpuser/' /var/www/html/wp-config.php
sed -i 's/password_here/wpuser/' /var/www/html/wp-config.php
sed -i 's/localhost/18.207.209.185/' /var/www/html/wp-config.php

#Movemos el .htaccess de Wordpress a la carpeta Web
cd $HOME/public_practica08
mv .htaccess /var/www/html/.htaccess


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

#Otorgamos permisos a www-data del contenido del dir. Web
#chown www-data:www-data /var/www/html -R

# Instalamos el paquete Servidor de NFS
apt-get install nfs-kernel-server -y
systemctl start nfs-kernel-server

# Quitamos pertenencias a la carpeta a compartir
chown nobody:nogroup /var/www/html

# Editamos el fichero de archivos compartidos
echo "/var/www/html     $IP_SLAVE(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports

# Reiniciamos el servicio.
systemctl restart nfs-kernel-server