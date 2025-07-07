#!/bin/bash

Verificación de palabra clave
if [[ "$1" != "usuario" || "$2" != "nuevo" ]]; then echo "Uso correcto:" echo " sudo ./crear_usuario_enjaulado.sh usuario nuevo" exit 1 fi

Obtener número consecutivo
BASE_NAME="user" LAST_ID=$(ls /home | grep "^${BASE_NAME}[0-9]*$" | sed "s/${BASE_NAME}//" | sort -n | tail -1) NEXT_ID=$((LAST_ID + 1)) NEW_USER="${BASE_NAME}${NEXT_ID}" USER_PASS="${NEW_USER}"

Crear usuario de sistema con shell válida
useradd -m -d /home/$NEW_USER -s /bin/bash "$NEW_USER" echo "$NEW_USER:$USER_PASS" | chpasswd

Agregar usuario al grupo www-data
usermod -aG www-data "$NEW_USER"

Crear public_html con archivo index.html
mkdir -p /home/$NEW_USER/public_html cat < /home/$NEW_USER/public_html/index.html

<title>Bienvenido a la empresa UPS</title> <style> body { font-family: Arial, sans-serif; background-color: #f8f8f8; color: #333; text-align: center; padding-top: 50px; } h1 { font-size: 3em; color: #005b96; } </style>
Bienvenido a la empresa UPS
EOF
Asignar permisos para permitir acceso desde navegador y FileZilla
sudo chmod o+x /home # Permitir acceso al directorio /home sudo chmod o+x /home/$NEW_USER # Permitir acceso al home del usuario sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/public_html #sudo chmod -R 755 /home/$NEW_USER/public_html sudo find /home/$NEW_USER/public_html -type f -exec chmod 644 {} ; sudo find /home/$NEW_USER/public_html -type d -exec chmod 755 {} ;

Verificar configuración de vsftpd
VSFTPD_CONF="/etc/vsftpd.conf" if ! grep -q "chroot_local_user=YES" "$VSFTPD_CONF"; then echo "Actualizando configuración de vsftpd para enjaular usuarios..." echo ' chroot_local_user=YES allow_writeable_chroot=YES ' >> "$VSFTPD_CONF" systemctl restart vsftpd fi

Crear usuario MySQL con su base de datos
mysql -u root -p <<EOF CREATE DATABASE IF NOT EXISTS $NEW_USER; CREATE USER '$NEW_USER'@'localhost' IDENTIFIED BY '$USER_PASS'; GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP, INDEX, LOCK TABLES ON $NEW_USER.* TO '$NEW_USER'@'localhost'; FLUSH PRIVILEGES; EOF

Recargar Nginx
=========================
NUEVO BLOQUE NGINX POR USUARIO
=========================
NGINX_CONF="/etc/nginx/sites-available/$NEW_USER"

cat < "$NGINX_CONF" server { listen 80; server_name ${NEW_USER}.com;

root /home/$NEW_USER/public_html;

location / {
    try_files \$uri \$uri/ =404;
}
} EOF

Enlace simbólico a sites-enabled
ln -s "$NGINX_CONF" /etc/nginx/sites-enabled/ systemctl reload nginx

Agregar entrada en /etc/hosts para resolución local
HOSTS_LINE="192.168.122.26 $NEW_USER.com"

Verificar si ya existe la entrada
if ! grep -q "$HOSTS_LINE" /etc/hosts; then echo "$HOSTS_LINE" >> /etc/hosts echo "[+] Entrada agregada a /etc/hosts: $HOSTS_LINE" else echo "[=] La entrada ya existe en /etc/hosts: $HOSTS_LINE" fi

Guardar credenciales
CRED_FILE="/root/credenciales_$NEW_USER.txt" echo "Usuario Linux/FTP: $NEW_USER" > "$CRED_FILE" echo "Contraseña: $USER_PASS" >> "$CRED_FILE" echo "FTP en: /home/$NEW_USER/public_html" >> "$CRED_FILE" echo "Usuario MySQL: $NEW_USER" >> "$CRED_FILE" echo "Contraseña MySQL: $USER_PASS" >> "$CRED_FILE" echo "Web: /home/$NEW_USER/public_html/index.html" >> "$CRED_FILE"

Mostrar resumen
echo "======================================" echo " USUARIO CREADO CORRECTAMENTE" echo "======================================" echo "Linux/FTP: $NEW_USER" echo "MySQL: $NEW_USER" echo "Contraseña: $USER_PASS" echo "Sitio web en: /home/$NEW_USER/public_html" echo "Credenciales guardadas en: $CRED_FILE" echo "======================================"