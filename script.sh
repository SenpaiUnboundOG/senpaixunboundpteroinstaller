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
echo "1) PANEL"
echo "2) WINGS (COMING SOON..)"
echo ""

read -p "Enter choice [1-2]: " choice

if [ "$choice" == "1" ]; then
    clear
    echo "==== PANEL MENU ===="
    echo "1) FRESH INSTALL"
    echo "2) UPDATE PANEL"
    echo ""

    read -p "Enter choice [1-2]: " panel_choice

    if [ "$panel_choice" == "1" ]; then
        echo ""
        echo "Installing Pterodactyl... Please wait."
        
        # --- THE FIX ---
        # Hum installer ko unattended mode mein chala rahe hain.
        # Ye '0' pehla menu select karega, aur baaki prompts auto-fill honge.
        
        export DEBIAN_FRONTEND=noninteractive
        
        # Pehla '0' menu ke liye, baaki empty lines default values (database etc.) ke liye
        printf "0\n\n\n\n\n\n\n\n\n" | bash <(curl -s https://pterodactyl-installer.se)
        
        echo ""
        echo "======================================"
        echo "      CREATE YOUR ADMIN USER NOW        "
        echo "======================================"
        
        # Directory check aur user creation trigger
        sleep 2
        if [ -d "/var/www/pterodactyl" ]; then
            cd /var/www/pterodactyl
            # Yeh wahi dark green screen trigger karega
            php artisan p:user:make
        else
            echo "❌ Error: Directory /var/www/pterodactyl not found!"
            exit 1
        fi
        
    elif [ "$panel_choice" == "2" ]; then
        echo ""
        echo "Updating Pterodactyl Panel..."
        cd /var/www/pterodactyl || { echo "Panel not found!"; exit 1; }
        php artisan down
        git pull
        composer install --no-dev --optimize-autoloader
        php artisan migrate --seed --force
        php artisan view:clear
        php artisan config:clear
        php artisan up
        echo ""
        echo "✅ Panel Updated Successfully!"
    fi
fi
