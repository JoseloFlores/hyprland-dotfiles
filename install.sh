#!/bin/bash
set -e

# ... (Colores y cabecera igual)

# --- 1. Verificación mejorada ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    VERSION_CODENAME=$VERSION_CODENAME
    echo -e "${GREEN}Detectado Debian: $VERSION_CODENAME${NC}"
fi

# --- 2. Instalación de Dependencias (Más robusta) ---
# Separar la instalación asegura que si algo falla, sepamos exactamente qué es
echo -e "${GREEN}Instalando paquetes...${NC}"
# Instalar lsb-release por si acaso
sudo apt update && sudo apt install -y lsb-release

PACKAGES="hyprland waybar swaybg wofi foot nautilus playerctl wireplumber brightnessctl grim slurp swappy jq fonts-font-awesome pavucontrol blueman hyprlock hypridle libayatana-appindicator3-1 zenity nwg-look hyprpolkitagent"

# Instalación estándar; apt resolverá versiones de backports si tienes /etc/apt/preferences configurado
sudo apt install -y $PACKAGES

# --- 3. Despliegue (Corrección de copia) ---
for COMP in "${COMPONENTS[@]}"; do
    TARGET="$CONFIG_DIR/$COMP"
    SOURCE="$SCRIPT_DIR/$COMP"
    
    if [ -d "$SOURCE" ]; then
        if [ "$SOURCE" == "$TARGET" ]; then continue; fi

        if [ -d "$TARGET" ]; then
            BACKUP_NAME="${TARGET}_backup_$(date +%Y%m%d_%H%M%S)"
            mv "$TARGET" "$BACKUP_NAME"
        fi
        
        # Corregido: copiar contenido, no la carpeta padre
        cp -r "$SOURCE" "$CONFIG_DIR/"
    fi
done
