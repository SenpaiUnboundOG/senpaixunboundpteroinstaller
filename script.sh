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
        
        # Installer ko download karke temporary file mein save karna
        curl -s -L -o /tmp/pterodactyl-installer.sh https://pterodactyl-installer.se
        
        # Script ko run karna aur '0' input automatically pass karna
        # 'bash /tmp/pterodactyl-installer.sh' ko '0' input provide karna
        echo "0" | bash /tmp/pterodactyl-installer.sh
        
        # Cleanup
        rm /tmp/pterodactyl-installer.sh
        
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
