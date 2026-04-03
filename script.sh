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
        echo ""
        echo "Starting Pterodactyl Panel Installation..."
        
        # Yahan hum installer ko --unattended flag ke saath run kar rahe hain
        # Isse wo Database setup khud kar lega aur seedha FQDN aur User setup par rukega
        bash <(curl -s https://pterodactyl-installer.se) --panel --unattended
        
        echo ""
        echo "✅ Installation Process Completed!"
        
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

elif [ "$choice" == "2" ]; then
    echo "WINGS - COMING SOON.."
elif [ "$choice" == "3" ]; then
    echo "CLOUDFLARE - COMING SOON.."
elif [ "$choice" == "4" ]; then
    echo "TOOLS - COMING SOON.."
else
    echo "Invalid option!"
fi
