#!/bin/bash

clear

# Colors for the Dark Green Aesthetic
GREEN='\033[0;32m'
DARK_GREEN='\033[1;32m'
NC='\033[0m' 

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
echo "1) INSTALL PANEL (Database + FQDN + User)"
echo "2) UPDATE PANEL"
echo "3) CREATE EXTRA ADMIN USER (Official)"
echo ""

read -p "Enter choice [1-3]: " choice

if [ "$choice" == "1" ]; then
    clear
    echo -e "${DARK_GREEN}--- Starting Pterodactyl Installation Flow ---${NC}"
    
    # Step 1: Base Installation
    # Pipe hata diya hai taaki aap interactive mode mein Database aur FQDN fill kar sakein
    bash <(curl -s https://pterodactyl-installer.se)

    echo ""
    echo -e "${DARK_GREEN}--- Database & Environment Setup ---${NC}"
    if [ -d "/var/www/pterodactyl" ]; then
        cd /var/www/pterodactyl
        
        # Database setup command (Official)
        echo "Configuring Database environment..."
        php artisan p:environment:database
        
        # FQDN & Application setup command
        echo "Configuring Application (FQDN, SSL, etc.)..."
        php artisan p:environment:setup

        # Step 2: Official User Creation
        echo ""
        echo -e "${DARK_GREEN}--- Creating Official Admin User ---${NC}"
        php artisan p:user:make
    else
        echo -e "\e[31mError: Installation directory /var/www/pterodactyl not found!\e[0m"
    fi

    echo ""
    echo -e "${GREEN}✅ Full Installation Process Completed!${NC}"

elif [ "$choice" == "2" ]; then
    echo -e "${DARK_GREEN}Updating Panel...${NC}"
    cd /var/www/pterodactyl || { echo "Panel not found!"; exit 1; }
    php artisan down
    git pull
    composer install --no-dev --optimize-autoloader
    php artisan migrate --seed --force
    php artisan view:clear
    php artisan config:clear
    php artisan up
    echo -e "${GREEN}✅ Update Done!${NC}"

elif [ "$choice" == "3" ]; then
    echo -e "${DARK_GREEN}Launching Official User Creation...${NC}"
    if [ -d "/var/www/pterodactyl" ]; then
        cd /var/www/pterodactyl
        php artisan p:user:make
    else
        echo "Error: /var/www/pterodactyl directory nahi mili!"
    fi

else
    echo "Invalid option!"
fi
