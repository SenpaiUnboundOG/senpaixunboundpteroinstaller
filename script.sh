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
echo "Select an option:"
echo "1) PANEL (Fully Automatic)"
echo "2) WINGS (COMING SOON..)"
echo "3) CLOUDFLARE (COMING SOON..)"
echo "4) TOOLS (COMING SOON..)"
echo ""

read -p "Enter choice [1-4]: " choice

if [ "$choice" == "1" ]; then
    clear
    echo "==== PANEL AUTO-INSTALLER ===="
    
    # User se sirf wo info maangna jo zaroori hai
    read -p "Enter your Email: " input_email
    read -p "Enter your Domain/FQDN: " input_fqdn
    
    echo ""
    echo "Starting Installation... Ab araam se baitho, sab auto-skip hoga!"

    # --- THE MAGIC BYPASS ---
    # Hum saari variables export kar rahe hain taaki lib.sh inhe utha le
    export email="$input_email"
    export user_email="$input_email"
    export FQDN="$input_fqdn"
    export MYSQL_DB="panel"
    export MYSQL_USER="pterodactyl"
    export MYSQL_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
    export timezone="Asia/Kolkata"
    
    # Ye dummy values user creation bypass ke liye (aap last mein manually banaoge)
    export user_username="admin"
    export user_firstname="Admin"
    export user_lastname="User"
    export user_password="ChangeMe123!"

    # Installer download aur run
    # Hum seedha flag bhej rahe hain aur '0' pipe kar rahe hain menu bypass ke liye
    echo "0" | bash <(curl -s https://pterodactyl-installer.se) --panel --unattended

    echo ""
    echo "======================================"
    echo "      CREATE YOUR ADMIN USER NOW"
    echo "======================================"
    # Ye raha aapka favorite dark green screen wala part
    cd /var/www/pterodactyl && php artisan p:user:make

    echo ""
    echo "✅ Sab kuch khatam! URL: http://$input_fqdn"
    
elif [ "$choice" == "2" ]; then
    echo "WINGS - COMING SOON.."
# ... baaki options waise hi rahenge
fi
