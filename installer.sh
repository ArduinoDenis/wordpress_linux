echo aggiorno la lista dei pacchetti
sudo apt-get update;
sudo apt-get full-upgrade -y;
echo installo apache2
sudo apt-get install apache2 -y;
echo installo php
sudo apt-get install php -y;
echo installo mariadb per il database
sudo apt-get install mariadb-server php-mysql -y;
echo riavvio apache2
sudo service apache2 restart;
echo mi sposto nella certella /var/www/html
cd /var/www/html/
echo scarico wordpress
sudo rm * && sudo wget http://wordpress.org/latest.tar.gz ;
echo estraggo i files di wordpress
sudo tar xzf latest.tar.gz;
echo sposto i file da wordpress a html
sudo mv wordpress/* . ;
echo elimino la cartella wordpress che è vuota
sudo rm -rf wordpress latest.tar.gz ;
echo cambio il proprietario dei files dal tuo nome utente a www-data
sudo chown -R www-data: . ;