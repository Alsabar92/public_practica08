#Instalo el cliente de NFS
apt-get install nfs-common -y

#Montamos la carpeta del servidor en el cliente.
mount $IP_MASTER:/var/www/html/wordpress /var/www/html/wordpress

#Registramos la orden en el fstab
echo "$IP_MASTER:/var/www/html/wordpress /var/www/html/wordpress  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
