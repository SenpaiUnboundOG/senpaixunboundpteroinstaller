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
echo "3) CLOUDFLARE (TUNNEL INSTALL)"
echo "4) TOOLS (COMING SOON..)"
echo ""

read -p "Enter choice [1-4]: " choice

# =============================
# PANEL MENU
# =============================
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
        echo "The installer will now ask for your FQDN and setup details."
        echo ""
        bash <(curl -s https://pterodactyl-installer.se) --install-panel
        echo ""
        echo "======================================"
        echo "      INSTALLATION COMPLETED"
        echo "======================================"
        echo "✅ Agar koi error nahi aaya, toh panel install ho chuka hai."

    elif [ "$panel_choice" == "2" ]; then
        echo ""
        echo "Updating Pterodactyl Panel..."
        echo ""
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

# =============================
# CLOUDFLARE INSTALLATION (Option 3)
# =============================
elif [ "$choice" == "3" ]; then
    clear
    echo "==== CLOUDFLARE TUNNEL INSTALLER ===="
    echo "Installing cloudflared repository and package..."
    echo ""

    # Add cloudflare gpg key
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

    # Add repo
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # Update and install
    sudo apt-get update && sudo apt-get install -y cloudflared

    echo ""
    echo "✅ Cloudflared installed successfully."
    echo ""
    
    # Ask for the Token
    read -p "Please enter your Cloudflare Tunnel Token: " cf_token

    if [ -z "$cf_token" ]; then
        echo "❌ Token cannot be empty. Installation aborted."
    else
        echo "Installing cloudflared service..."
        sudo cloudflared service install "$cf_token"
        echo ""
        echo "======================================"
        echo "    CLOUDFLARE SERVICE INSTALLED"
        echo "======================================"
        echo "✅ Cloudflare Tunnel is now active!"
    fi

# =============================
# OTHER OPTIONS
# =============================
elif [ "$choice" == "2" ]; then
    echo "WINGS - COMING SOON.."

elif [ "$choice" == "4" ]; then
    echo "TOOLS - COMING SOON.."

else
    echo "Invalid option!"
fi
