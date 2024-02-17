# Guida all'installazione di WordPress su Linux

## Istruzioni

### 1. Scarica i file

```bash
git clone https://github.com/ArduinoDenis/wordpress_linux.git
```

### 2. Esegui il file di installazione

```bash
cd wordpress_linux/ && sudo chmod 700 installer.sh && ./installer.sh
```

### 3. Attendi il completamento dell'installazione dei vari programmi.

### 4. Procedura manuale post-installazione

5. Effettua l'installazione sicura di MySQL

```bash
sudo mysql_secure_installation
```

6. Premi invio e inserisci la password corrente per l'utente root.

7. Se richiesto di Impostare la password di root, digita Y e premi invio.

8. Inserisci una nuova password quando richiesto e premi invio. **Importante**: ricorda questa password in quanto necessaria per configurare WordPress in seguito.

9. Digita Y in "Remove anonymous users" per rimuovere gli utenti anonimi.

10. Digita Y in "Disallow root login remotely" per impedire l'accesso root da remoto.

11. Digita Y in "Remove test database and access to it" per rimuovere il database di test.

12. Digita Y in "Reload privilege tables now" per ricaricare le tabelle dei privilegi.

13. Al termine, vedrai il messaggio "All done!" e "Thanks for using MariaDB!".

14. Accedi a MySQL con l'utente root e la password scelta in precedenza

```bash
sudo mysql -uroot -p
```

15. Crea il database chiamato wordpress

```bash
create database wordpress;
```

16. Dovresti ricevere la risposta: "Query OK, 1 row affected (0.00 sec)" se non ci sono problemi.

17. Concedi tutti i privilegi al database di WordPress

```bash
GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' IDENTIFIED BY 'inserisci la tua password';
```

18. Ricarica i privilegi

```bash
FLUSH PRIVILEGES;
```

19. Esci da MariaDB con Ctrl + D

20. Abilita il modulo rewrite di Apache

```bash
sudo a2enmod rewrite
```

21. Configura Apache aggiungendo le seguenti righe all'inizio del file `000-default.conf`

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

```apache
<Directory "/var/www/html">
    AllowOverride All
</Directory>
```

Salva ed esci con Ctrl+O e Ctrl+X.

23. Riavvia Apache

```bash
sudo service apache2 restart
```

24. Apri un browser (es. Google Chrome, Edge, Firefox) e visita il seguente link: `http://ip_del_server/wp-admin/setup-config.php` per continuare con la procedura guidata di WordPress.

## Compila le informazioni di base del sito seguendo lo screenshot

![Schermata di configurazione](https://github.com/ArduinoDenis/wordpress_linux/blob/main/img/screen.png)

---

Questo file README fornisce istruzioni dettagliate per installare WordPress su un server Linux e completare la configurazione in modo corretto. Segui attentamente i passaggi indicati per assicurarti che l'installazione sia eseguita correttamente.
