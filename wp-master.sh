# Instalamos el paquete Servidor de NFS
apt-get install nfs-kernel-server -y
systemctl start nfs-kernel-server

# Quitamos pertenencias a la carpeta a compartir
chown nobody:nogroup /var/www/html/wordpress/wp-content

# Editamos el fichero de archivos compartidos
echo "/var/www/html/wordpress/wp-content      $IP_SLAVE(rw,sync,no_root_squash,no_subtree_check)" > /etc/exports

# Reiniciamos el servicio.
systemctl restart nfs-kernel-server