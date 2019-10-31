#Instalo el cliente de NFS
apt-get install nfs-common -y

#Montamos la carpeta del servidor en el cliente.
mount $IP_SERVER:/var/www/html/wordpress/wp-content /var/www/html/wordpress/wp-content

#Registramos la orden en el fstab
echo "$IP_SERVER:/var/www/html/wp-content /var/www/html/wp-content  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
