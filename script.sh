#!/bin/bash

clear

# Color codes for that "Dark Green" aesthetic
GREEN='\033[0;32m'
DARK_GREEN='\033[1;32m'
NC='\033[0m' # No Color

# =============================
# ASCII HEADER
# =============================
echo -e "${DARK_GREEN}=================================================="
echo "   ███████╗███████╗███╗   ██╗██████╗  █████╗ ██╗"
echo "   ██╔════╝██╔════╝████╗  ██║██╔══██╗██╔══██╗██║"
echo "   ███████╗█████╗  ██╔██╗ ██║██████╔╝███████║██║"
echo "   ╚════██║██╔══╝  ██║╚██╗██║██╔═══╝ ██╔══██║██║"
echo "   ███████║███████╗██║ ╚████║██║     ██║  ██║██║"
echo "   ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝"
echo ""
echo "             POWERED BY SENPAIXUNBOUND"
echo -e "==================================================${NC}"
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
    echo -e "${GREEN}==== PANEL MENU ====${NC}"
    echo "1) FRESH INSTALL"
    echo "2) UPDATE PANEL"
    echo "3) CREATE ADMINISTRATIVE USER"
    echo ""

    read -p "Enter choice [1-3]: " panel_choice

    if [ "$panel_choice" == "1" ]; then
        echo ""
        echo -e "${DARK_GREEN}Starting Pterodactyl Panel Installation...${NC}"
        
        # FQDN Setup (Optional prompt for visibility)
        read -p "Enter your FQDN (e.g. panel.example.com): " fqdn
        
        # Pterodactyl installer call
        # Database setup skip karne ke liye hum script ko manual mode ya preset options bhej sakte hain
        bash <(curl -s https://pterodactyl-installer.se)
        
        echo ""
        echo -e "${GREEN}✅ Installation Process Completed!${NC}"
        
    elif [ "$panel_choice" == "2" ]; then
        echo ""
        echo -e "${DARK_GREEN}Updating Pterodactyl Panel...${NC}"
        cd /var/www/pterodactyl || { echo "Panel not found!"; exit 1; }
        php artisan down
        git pull
        composer install --no-dev --optimize-autoloader
        php artisan migrate --seed --force
        php artisan view:clear
        php artisan config:clear
        php artisan up
        echo ""
        echo -e "${GREEN}✅ Panel Updated Successfully!${NC}"

    elif [ "$panel_choice" == "3" ]; then
        echo ""
        echo -e "${DARK_GREEN}Running Official User Creation...${NC}"
        cd /var/www/pterodactyl || { echo "Panel directory not found!"; exit 1; }
        # Official Pterodactyl user creation command
        php artisan p:user:make
        
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
