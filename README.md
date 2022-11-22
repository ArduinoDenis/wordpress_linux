# installare wordpress su linux

## istruzioni 
1. scaricare i files

```bash
git clone git@github.com:ArduinoDenis/wordpress_linux.git
```

2. eseguire il file di installazione

```bash
cd wordpress_linux/ && sudo chmod 700 installer.sh && ./installer.sh
```

3. aspettare che finisca l'installazione dei vari programmi

4. una volta terminato seguire la procedura manuale seguente:

5. fare installazione sicura di mysql

```bash
sudo mysql_secure_installation
```

6. e premere invio e ti verrà chiesto Inserisci la password corrente per root premi invio

7. ti verrà chiesto se vuoi Impostare la password di root? digita Y e poi invio

8. Digita una password quando New password: richiesto e premi Invio . Importante: ricorda questa password di root, poiché ti servirà in seguito per configurare WordPress.

9. Digita Y in Remove anonymous users cioè se vuoi rimuovere gli utenti anonimi

10. Digita Y in Disallow root login remotely cioè Non consentire l'accesso root da remoto

11. Digita Y in Remove test database and access to it cioè se vuoi rimuovere il database dei test

12. Digita Y in Reload privilege tables now. cioè Ricarica ora le tabelle con i nuovi privilegi.

13. Al termine, vedrai il messaggio All done! e Thanks for using MariaDB!

14. esegui mysql con utente root e poi metti la passwiord che hai scelto prima e poi premi invio

```bash
sudo mysql -uroot -p
```

15. crea il database chiamato wordpress 

```bash
create database wordpress;
```

16. se non ci sono problemi darvi questa risposta:  Query OK, 1 row affected (0.00 sec)

17. ora concediamo i privilegi al database di wordpress 

```bash
GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'inserisci la tua password';
```

18. ricarichiamo i privilegi 

```bash
FLUSH PRIVILEGES;
```

19. Ora bisogna uscire dal mariadb con Ctrl + D

20. abilitiamo un modulo di apache

```bash
sudo a2enmod rewrite
```

21. bisogna configurare apache e aggiungere le seguenti righe al inizio della 1 riga

```bash
sudo nano /etc/apache2/sites-available/000-default.conf 
```

```script
<Directory "/var/www/html">
    AllowOverride All
</Directory> 
```

22. salva ed esci con ctrl+o poi ctrl+x

23. Riavvia Apache

```bash
sudo service apache2 restart
```

24. ora apri un brower es google chrome, edge, firefox ecc e metti il seguente link http:// ip del server/wp-admin/setup-config.php e continua con la procedura guidata di wordpress

## Ora compila le informazioni di base del sito seguendo lo screen
![screen]()