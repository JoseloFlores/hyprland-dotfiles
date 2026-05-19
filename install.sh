#!/bin/bash
set -e

# --- Configuración de Colores ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=======================================================${NC}"
echo -e "${BLUE}   Instalador Unificado: Hyprland, Waybar, Foot, Wofi  ${NC}"
echo -e "${BLUE}=======================================================${NC}"

# --- 1. Verificación de Distribución y Backports ---
if [ -f /etc/debian_version ]; then
    VERSION_CODENAME=$(lsb_release -sc 2>/dev/null || cat /etc/debian_version | cut -d/ -f1)
    echo -e "${GREEN}Detectado Debian: $VERSION_CODENAME${NC}"
    
    if [[ "$VERSION_CODENAME" == "trixie" || "$VERSION_CODENAME" == "13" ]]; then
        echo -e "${YELLOW}Configurando Backports para Debian 13 (Trixie) para versiones recientes...${NC}"
        if ! grep -q "trixie-backports" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
            echo "deb http://deb.debian.org/debian trixie-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
        fi
        sudo apt update
    fi
else
    echo -e "${RED}Este script está optimizado para Debian 13. Continuando con precaución...${NC}"
fi

# --- 2. Instalación de Dependencias ---
echo -e "${GREEN}Instalando paquetes y dependencias...${NC}"
PACKAGES="hyprland waybar swaybg wofi foot nautilus playerctl wireplumber brightnessctl grim slurp swappy jq fonts-font-awesome pavucontrol blueman hyprlock hypridle libayatana-appindicator3-1 zenity nwg-look"

# Intentar instalar desde backports primero, si falla, intentar normal
sudo apt install -y -t trixie-backports $PACKAGES || sudo apt install -y $PACKAGES

# --- 3. Despliegue de Configuraciones ---
CONFIG_DIR="$HOME/.config"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$CONFIG_DIR"

COMPONENTS=("hypr" "foot" "wofi" "gtk-3.0" "gtk-4.0")

for COMP in "${COMPONENTS[@]}"; do
    TARGET="$CONFIG_DIR/$COMP"
    SOURCE="$SCRIPT_DIR/$COMP"
    
    if [ -d "$SOURCE" ]; then
        # Evitar sobreescribir si el origen y destino son el mismo (ej. ejecutando desde ~/.config/hyprland-dotfiles)
        if [ "$SOURCE" == "$TARGET" ]; then
            echo -e "${BLUE}Saltando $COMP (Origen y destino coinciden)${NC}"
            continue
        fi

        # Backup si ya existe
        if [ -d "$TARGET" ]; then
            BACKUP_NAME="${TARGET}_backup_$(date +%Y%m%d_%H%M%S)"
            echo -e "${YELLOW}Resguardando configuración existente en: $BACKUP_NAME${NC}"
            mv "$TARGET" "$BACKUP_NAME"
        fi
        
        # Copiar configuración
        echo -e "${GREEN}Desplegando configuración de $COMP...${NC}"
        cp -r "$SOURCE" "$CONFIG_DIR/"
    else
        echo -e "${RED}Error: No se encontró la carpeta '$SOURCE' en el instalador.${NC}"
    fi
done

# --- 4. Permisos de Ejecución ---
echo -e "${GREEN}Ajustando permisos para scripts internos...${NC}"
if [ -d "$CONFIG_DIR/hypr" ]; then
    chmod +x "$CONFIG_DIR/hypr"/*.sh 2>/dev/null || true
fi

echo -e "${BLUE}=======================================================${NC}"
echo -e "${GREEN}   ¡Instalación Finalizada Exitosamente!              ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e "Sugerencia: Reinicia Hyprland o cierra sesión para aplicar todo."
