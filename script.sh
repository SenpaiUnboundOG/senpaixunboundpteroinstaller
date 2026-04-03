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
        
        read -p "Enter your Email: " user_email
        read -p "Enter your Domain (FQDN): " user_domain
        echo ""
        echo "Installing Pterodactyl... Sab kuch auto-skip ho raha hai."

        # Step 1: Installer download karo
        curl -sL https://pterodactyl-installer.se -o /tmp/pteroinstaller.sh
        
        # Step 2: HACK - Installer ke loop ko bypass karne ke liye
        # Hum installer ko batayenge ki 'action' pehle se 0 hai
        # Isse wo 0-6 wala menu skip kar dega
        export DEBIAN_FRONTEND=noninteractive
        
        bash /tmp/pteroinstaller.sh --panel \
            --unattended \
            --email "$user_email" \
            --fqdn "$user_domain" \
            --timezone "Asia/Kolkata" \
            --panel-db-name "pterodactyl" \
            --panel-db-user "pterodactyl" \
            --panel-db-pass "Pterodactyl@123" <<EOF
0
EOF

        echo ""
        echo "======================================"
        echo "      CREATE YOUR ADMIN USER NOW"
        echo "======================================"
        # Step 3: Dark Green setup trigger
        cd /var/www/pterodactyl && php artisan p:user:make

        # Cleanup
        rm /tmp/pteroinstaller.sh

        echo ""
        echo "✅ Done! Panel URL: http://$user_domain"
        
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
