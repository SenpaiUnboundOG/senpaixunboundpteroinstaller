#!/bin/bash

clear

# Colors
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
echo "1) PANEL (Fresh Install)"
echo "2) UPDATE PANEL"
echo "3) CREATE ADMIN USER (Official)"
echo ""

read -p "Enter choice [1-3]: " choice

if [ "$choice" == "1" ]; then
    clear
    echo -e "${DARK_GREEN}--- Pterodactyl Installation ---${NC}"
    
    # Hum yahan user se pehle hi details nahi mangenge, 
    # balki installer ko chalne denge taaki aap database skip kar sakein.
    
    echo "Starting installer... Jab Database ka option aaye toh aap manually skip/config kar sakte hain."
    sleep 2
    
    # 'bash <(curl...)' bina pipe ke chalayenge taaki yeh interactive rahe
    bash <(curl -s https://pterodactyl-installer.se)

    echo ""
    echo -e "${GREEN}✅ Installation script finished!${NC}"
    echo "Ab aap Option 3 use karke Admin user bana sakte hain."

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
        # Official command to create user
        php artisan p:user:make
    else
        echo "Error: /var/www/pterodactyl directory nahi mili!"
    fi

else
    echo "Invalid option!"
fi
