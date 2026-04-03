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
echo "1) PANEL (Fully Automatic)"
echo "2) WINGS (COMING SOON..)"
echo ""

read -p "Enter choice [1-2]: " choice

if [ "$choice" == "1" ]; then
    clear
    read -p "Enter your Email: " user_email
    read -p "Enter your Domain (FQDN): " user_domain
    
    echo ""
    echo "🚀 Starting High-Speed Installation..."
    echo "Bypass Mode Active: Menu and Database prompts skipped."

    # Step 1: Installer ko download karke uske main functions load karna
    # Hum unattended flag use karke installation trigger karenge
    # Lekin hum ise 'bash' ke through arguments pass karenge jo NobitaHost karta hai
    
    bash <(curl -s https://pterodactyl-installer.se) --panel \
        --unattended \
        --email "$user_email" \
        --fqdn "$user_domain" \
        --timezone "Asia/Kolkata" \
        --panel-db-name "pterodactyl" \
        --panel-db-user "pterodactyl" \
        --panel-db-pass "$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)" <<EOF
0
EOF

    echo ""
    echo "======================================"
    echo "      CREATE YOUR ADMIN USER NOW"
    echo "======================================"
    
    # NobitaHost style: Force direct user creation trigger
    if [ -d "/var/www/pterodactyl" ]; then
        cd /var/www/pterodactyl
        # Yahan dark green screen aayegi
        php artisan p:user:make
    else
        echo "❌ Error: Panel directory not found! Something went wrong."
        exit 1
    fi

    echo ""
    echo "✅ Installation Success! Access: http://$user_domain"
fi
