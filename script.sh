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
    echo "⚙️ Installing Pterodactyl... (Bypassing Menus)"

    # Variables Export taaki installer inhe use kare
    export FQDN="$input_fqdn"
    export email="$input_email"
    export user_email="$input_email"
    export MYSQL_DB="panel"
    export MYSQL_USER="pterodactyl"
    export MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    export timezone="Asia/Kolkata"
    export CONFIGURE_FIREWALL=false
    export CONFIGURE_LETSENCRYPT=false

    # 1. Installer download karo
    curl -sL https://pterodactyl-installer.se -o /tmp/pteroinstaller.sh

    # 2. MAGIC: Script ke menu loop aur welcome screen ko delete karna taaki wo seedha install shuru kare
    # Hum seedha 'perform_install' function trigger kar rahe hain
    sed -i 's/welcome ""//g' /tmp/pteroinstaller.sh
    echo "perform_install" >> /tmp/pteroinstaller.sh

    # 3. Installer ko run karna (Ab ye menu nahi dikhayega)
    bash /tmp/pteroinstaller.sh

    echo ""
    echo "======================================"
    echo "      CREATE YOUR ADMIN USER NOW"
    echo "======================================"
    
    # Check agar folder bana hai, tabhi aage badho
    if [ -d "/var/www/pterodactyl" ]; then
        cd /var/www/pterodactyl && php artisan p:user:make
    else
        echo "❌ ERROR: Installation failed or directory not found!"
        exit 1
    fi

    rm /tmp/pteroinstaller.sh
    echo ""
    echo "✅ All Done! URL: http://$input_fqdn"
fi
