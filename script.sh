#!/usr/bin/env bash

# ==========================================================
# SENPAIXUNBOUND | PTERODACTYL HYPER-UPLINK
# DATE: 2026-04-03 | UI-TYPE: SEMA-VISUAL
# ==========================================================
set -euo pipefail

# --- COLORS ---
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[1;37m'
DG='\033[90m'
NC='\033[0m'

# --- UI RENDERER ---
render_header() {
    clear
    echo -e "${C}"
    cat << "EOF"
   ███████╗███████╗███╗   ██╗██████╗  █████╗ ██╗
   ██╔════╝██╔════╝████╗  ██║██╔══██╗██╔══██╗██║
   ███████╗█████╗  ██╔██╗ ██║██████╔╝███████║██║
   ╚════██║██╔══╝  ██║╚██╗██║██╔═══╝ ██╔══██║██║
   ███████║███████╗██║ ╚████║██║     ██║  ██║██║
   ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝
EOF
    echo -e "${NC}"
    echo -e "${DG}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${DG}│${NC}  ${R}☢️  SENPAI HYPER-UPLINK${NC} ${W}v1.0${NC}             ${DG}$(date +"%H:%M")${NC}  ${DG}│${NC}"
    echo -e "${DG}└──────────────────────────────────────────────────────────┘${NC}"
}

render_header

# --- INPUT SECTION ---
echo -e "  ${Y}REQUIRED CONFIGURATION${NC}"
echo -ne "  ${DG}├─ Enter Admin Email : ${NC}"
read -r USER_EMAIL
echo -ne "  ${DG}└─ Enter Panel FQDN  : ${NC}"
read -r PANEL_FQDN
echo -e "${DG}────────────────────────────────────────────────────────────${NC}"

# --- AUTO-CONFIG GENERATION ---
echo -e "\n  ${C}[1/2] PRE-CONFIGURING ENVIRONMENT${NC}"
echo -ne "  ${DG}├─ Generating Database Keys...${NC} "
DB_PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
sleep 0.5
echo -e "${G}DONE${NC}"

# --- TRIGGER INSTALLATION ---
echo -e "\n  ${C}[2/2] STARTING PTERODACTYL CORE${NC}"
echo -e "  ${DG}├─ Bypassing Official Prompts...${NC}"

# Setting Exports for the installer to read
export email="$USER_EMAIL"
export fqdn="$PANEL_FQDN"
export timezone="Asia/Kolkata"
export panel_db_name="pterodactyl"
export panel_db_user="pterodactyl"
export panel_db_pass="$DB_PASS"

# Executing official installer in non-interactive mode
# We pipe '0' to select "Install Panel" from the first menu
echo -e "  ${DG}└─ Handshake Status:${NC} ${G}AUTHORIZED${NC}"
echo -e "\n${DG}────────────────────────────────────────────────────────────${NC}"
echo -ne "  ${W}Launching Core Engine in ${R}3s${NC} "
for i in {1..3}; do echo -ne "${R}.${NC}"; sleep 0.7; done
echo -e "\n"

# The real command that skips everything
bash <(curl -s https://pterodactyl-installer.se) --panel \
    --unattended \
    --email "$USER_EMAIL" \
    --fqdn "$PANEL_FQDN" \
    --timezone "Asia/Kolkata" \
    --panel-db-name "pterodactyl" \
    --panel-db-user "pterodactyl" \
    --panel-db-pass "$DB_PASS" <<EOF
0
EOF

# --- POST-INSTALL (DARK GREEN SETUP) ---
echo -e "\n${DG}────────────────────────────────────────────────────────────${NC}"
echo -e "  ${G}SUCCESS: CORE ENGINE INSTALLED${NC}"
echo -e "  ${Y}ACTION: CONFIGURE YOUR ADMIN ACCOUNT${NC}"
echo -e "${DG}────────────────────────────────────────────────────────────${NC}\n"

if [ -d "/var/www/pterodactyl" ]; then
    cd /var/www/pterodactyl
    php artisan p:user:make
else
    echo -e "${R}CRITICAL ERROR: Installation Directory Not Found!${NC}"
    exit 1
fi

echo -e "\n${G}✅ ALL SYSTEMS ONLINE | URL: http://$PANEL_FQDN${NC}"
