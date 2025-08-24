#!/bin/bash

# Configurazione
WP_DIR="/var/www/html"
WP_URL="https://wordpress.org/latest.tar.gz"

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funzioni di utilità
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "Non eseguire questo script come root. Usa sudo quando necessario."
        exit 1
    fi
}

check_command() {
    if ! command -v $1 &> /dev/null; then
        log_error "$1 non è installato"
        return 1
    fi
    return 0
}

# Controlli preliminari
check_root

log_info "Avvio installazione WordPress..."

# Aggiornamento sistema
log_info "Aggiornamento sistema in corso..."
if ! sudo apt-get update && sudo apt-get full-upgrade -y; then
    log_error "Errore durante l'aggiornamento del sistema"
    exit 1
fi

# Installazione Apache2
log_info "Installazione Apache2..."
if ! sudo apt-get install apache2 -y; then
    log_error "Errore durante l'installazione di Apache2"
    exit 1
fi

# Installazione PHP e moduli
log_info "Installazione PHP e moduli..."
PHP_PACKAGES="php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip"
if ! sudo apt-get install $PHP_PACKAGES -y; then
    log_error "Errore durante l'installazione di PHP"
    exit 1
fi

# Installazione MariaDB
log_info "Installazione MariaDB..."
if ! sudo apt-get install mariadb-server -y; then
    log_error "Errore durante l'installazione di MariaDB"
    exit 1
fi

# Avvio e abilitazione servizi
log_info "Configurazione servizi..."
sudo systemctl enable apache2
sudo systemctl enable mariadb
sudo systemctl restart apache2
sudo systemctl restart mariadb

# Verifica servizi
if ! sudo systemctl is-active --quiet apache2; then
    log_error "Apache2 non è in esecuzione"
    exit 1
fi

if ! sudo systemctl is-active --quiet mariadb; then
    log_error "MariaDB non è in esecuzione"
    exit 1
fi

# Backup directory esistente
if [ -d "$WP_DIR" ] && [ "$(ls -A $WP_DIR 2>/dev/null)" ]; then
    log_warn "Directory $WP_DIR non vuota. Creazione backup..."
    sudo mv "$WP_DIR" "${WP_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    sudo mkdir -p "$WP_DIR"
fi

# Spostamento nella directory web
cd "$WP_DIR" || {
    log_error "Impossibile accedere a $WP_DIR"
    exit 1
}

# Download WordPress
log_info "Download WordPress..."
if ! sudo wget "$WP_URL" -O latest.tar.gz; then
    log_error "Errore durante il download di WordPress"
    exit 1
fi

# Verifica integrità file
if [ ! -s latest.tar.gz ]; then
    log_error "File WordPress scaricato è vuoto o corrotto"
    sudo rm -f latest.tar.gz
    exit 1
fi

# Estrazione WordPress
log_info "Estrazione WordPress..."
if ! sudo tar xzf latest.tar.gz; then
    log_error "Errore durante l'estrazione di WordPress"
    exit 1
fi

# Verifica estrazione
if [ ! -d "wordpress" ]; then
    log_error "Cartella wordpress non trovata dopo l'estrazione"
    exit 1
fi

# Spostamento file
log_info "Configurazione file WordPress..."
sudo mv wordpress/* . 2>/dev/null || true
sudo mv wordpress/.[^.]* . 2>/dev/null || true

# Pulizia
sudo rm -rf wordpress latest.tar.gz

# Configurazione permessi
log_info "Configurazione permessi..."
sudo chown -R www-data:www-data .
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;

# Configurazione wp-config.php
if [ -f "wp-config-sample.php" ]; then
    log_info "Creazione wp-config.php..."
    sudo cp wp-config-sample.php wp-config.php
    sudo chown www-data:www-data wp-config.php
fi

# Test finale
log_info "Test configurazione Apache..."
if sudo apache2ctl configtest; then
    sudo systemctl reload apache2
    log_info "WordPress installato con successo!"
    log_info "Visita http://$(hostname -I | awk '{print $1}') per completare la configurazione"
    log_warn "Ricorda di:"
    log_warn "1. Configurare MariaDB: sudo mysql_secure_installation"
    log_warn "2. Creare database per WordPress"
    log_warn "3. Configurare il firewall se necessario"
else
    log_error "Errore nella configurazione di Apache"
    exit 1
fi
