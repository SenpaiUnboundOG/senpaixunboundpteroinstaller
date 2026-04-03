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
        read -p "Enter your Email: " user_email
        read -p "Enter your Domain (FQDN): " user_domain
        
        echo ""
        echo "Starting Pterodactyl Installation..."
        echo "Bypassing Menu & Database prompts..."

        # Step 1: Installer ko run karna (Flags ke saath taaki database na puche)
        # Humne '0' pipe kiya hai taaki pehla menu (0-6) auto-select ho jaye
        (
          echo "0" | bash <(curl -s https://pterodactyl-installer.se) --panel \
            --unattended \
            --email "$user_email" \
            --fqdn "$user_domain" \
            --timezone "Asia/Kolkata" \
            --panel-db-name "pterodactyl" \
            --panel-db-user "pterodactyl" \
            --panel-db-pass "$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)"
        )

        echo ""
        echo "======================================"
        echo "      CREATE YOUR ADMIN USER NOW"
        echo "======================================"
        
        # Step 2: Dark Green Screen Trigger
        # Humne yahan wait aur check lagaya hai taaki error na aaye
        sleep 2
        if [ -d "/var/www/pterodactyl" ]; then
            cd /var/www/pterodactyl
            php artisan p:user:make
        else
            echo "❌ ERROR: Installation folder not found!"
            exit 1
        fi

        echo ""
        echo "✅ Installation Complete! Access: http://$user_domain"
        
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
