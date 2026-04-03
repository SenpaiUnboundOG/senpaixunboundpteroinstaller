#!/bin/bash

clear

# =============================
# ASCII HEADER
# =============================
echo "=================================================="
echo "   ███████╗███████╗███╗   ██╗██████╗  █████╗ ██╗"
echo "   ██╔════╝██╔════╝████╗  ██║██╔══██╗██╔══██╗██║"
echo "   ███████╗█████╗  ██╔██╗ ██║██████╔╝███████║██║"
echo "   ╚════██║██╔══╝  ██║╚██╗██║██╔═══╝ ██╔══██║██║"
echo "   ███████║███████╗██║ ╚████║██║     ██║  ██║██║"
echo "   ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝"
echo ""
echo "             POWERED BY SENPAIXUNBOUND"
echo "=================================================="
echo ""

# =============================
# MAIN MENU
# =============================
echo "1) PANEL (Fully Automatic)"
echo "2) WINGS (COMING SOON..)"
echo ""

read -p "Enter choice [1-2]: " choice

if [ "$choice" == "1" ]; then
    clear
    read -p "Enter your Email: " input_email
    read -p "Enter your Domain/FQDN: " input_fqdn
    
    echo ""
    echo "Starting Installation... Ab seedha User Setup aayega!"

    # --- THE BYPASS HACK ---
    # 1. Installer download karo
    curl -sL https://pterodactyl-installer.se -o /tmp/pteroinstaller.sh

    # 2. Installer ke andar se wo functions 'skip' karwao jo prompt dikhate hain
    # Hum 'perform_install' ko directly call karenge variables ke sath
    export FQDN="$input_fqdn"
    export email="$input_email"
    export user_email="$input_email"
    export user_username="admin"
    export user_firstname="Admin"
    export user_lastname="User"
    export user_password="ChangeMe123!"
    export MYSQL_DB="panel"
    export MYSQL_USER="pterodactyl"
    export MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    export timezone="Asia/Kolkata"
    export CONFIGURE_FIREWALL=true
    export CONFIGURE_LETSENCRYPT=false

    # Sabse bada move: Installer ko bina menu ke seedha 'perform_install' par bhej rahe hain
    # Hum script ke end mein function call force kar rahe hain
    bash -c "source /tmp/pteroinstaller.sh; perform_install"

    echo ""
    echo "======================================"
    echo "      CREATE YOUR ADMIN USER NOW"
    echo "======================================"
    # Ab directory pakka hogi!
    cd /var/www/pterodactyl && php artisan p:user:make

    rm /tmp/pteroinstaller.sh
    echo ""
    echo "✅ Sab kuch khatam! URL: http://$input_fqdn"
fi
