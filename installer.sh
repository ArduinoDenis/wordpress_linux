#!/bin/bash

echo "Aggiorno la lista dei pacchetti"
sudo apt-get update && sudo apt-get full-upgrade -y

echo "Installo Apache2"
sudo apt-get install apache2 -y

echo "Installo PHP e i moduli necessari"
sudo apt-get install php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

echo "Installo MariaDB per il database"
sudo apt-get install mariadb-server -y

echo "Riavvio Apache2"
sudo systemctl restart apache2

echo "Mi sposto nella cartella /var/www/html"
cd /var/www/html/

echo "Scarico WordPress"
sudo rm -rf * && sudo wget http://wordpress.org/latest.tar.gz

echo "Estraggo i file di WordPress"
sudo tar xzf latest.tar.gz

echo "Sposto i file da WordPress a html"
sudo mv wordpress/* .

echo "Elimino la cartella WordPress che è vuota"
sudo rm -rf wordpress latest.tar.gz

echo "Cambio il proprietario dei file dal tuo nome utente a www-data"
sudo chown -R www-data: .

echo "Configuro i permessi dei file di WordPress"
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;

echo "WordPress è stato installato con successo!"
