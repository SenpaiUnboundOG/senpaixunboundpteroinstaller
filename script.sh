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
echo "3) CLOUDFLARE (COMING SOON..)"
echo "4) TOOLS (COMING SOON..)"
echo ""

read -p "Enter choice [1-4]: " choice

if [ "$choice" == "1" ]; then
    clear
    echo "==== PANEL MENU ===="
    echo "1) FRESH INSTALL"
    echo "2) UPDATE PANEL"
    echo ""

    read -p "Enter choice [1-2]: " panel_choice

    if [ "$panel_choice" == "1" ]; then
        
        # In do sawalo ke baad installer bilkul shaant rahega
        read -p "Enter your Email: " user_email
        read -p "Enter your Domain (FQDN): " user_domain
        echo ""
        echo "Installing Pterodactyl... Isme thoda time lagega, tab tak chai pilo! ☕"

        # Yahan hum saare flags ek saath bhej rahe hain
        # --unattended: Sawal mat pucho
        # --panel: Sirf panel install karo
        bash <(curl -s https://pterodactyl-installer.se) --panel \
            --unattended \
            --email "$user_email" \
            --fqdn "$user_domain" \
            --timezone "Asia/Kolkata" \
            --panel-db-name "pterodactyl" \
            --panel-db-user "pterodactyl" \
            --panel-db-pass "PterodactylPassword123"

        echo ""
        echo "======================================"
        echo "      CREATE YOUR ADMIN USER NOW"
        echo "======================================"
        # Dark Green Setup Trigger
        cd /var/www/pterodactyl && php artisan p:user:make

        echo ""
        echo "✅ Installation Complete! URL: http://$user_domain"
        
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
    else
        echo "Invalid option!"
    fi

# Baki options...
elif [ "$choice" == "2" ]; then
    echo "WINGS - COMING SOON.."
elif [ "$choice" == "3" ]; then
    echo "CLOUDFLARE - COMING SOON.."
elif [ "$choice" == "4" ]; then
    echo "TOOLS - COMING SOON.."
else
    echo "Invalid option!"
fi
