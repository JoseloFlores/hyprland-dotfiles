# Project Instructions - Hyprland + GNOME (Debian 13)

Este proyecto utiliza Hyprland sobre una base de Debian con GNOME instalado. Para garantizar la compatibilidad y funcionalidad de los módulos de Waybar, se deben seguir las siguientes convenciones:

## Herramientas de Gestión

- **Red (WiFi/Ethernet):** Utilizar `nmtui` ejecutado en la terminal `foot` para la gestión de conexiones. `gnome-control-center wifi` presenta problemas de autenticación Polkit en Hyprland si no hay un agente activo.
- **Bluetooth:** Utilizar `blueman-manager` para la gestión gráfica de dispositivos.
- **Audio:** Utilizar `XDG_CURRENT_DESKTOP=GNOME gnome-control-center sound` para la configuración de audio.
- **Confirmaciones:** Los diálogos de confirmación del menú de energía (`confirm_power.sh`) deben utilizar `zenity --question` por su fiabilidad en este entorno.
- **Bloqueo de Pantalla:** El botón de bloqueo debe llamar directamente a `hyprlock`.

## Solución de Problemas

### Iconos de Tray Ausentes (Spotify, Discord, etc.)
Si aplicaciones como Spotify muestran un espacio vacío en el Tray:
1. Asegurarse de tener `libayatana-appindicator3-1` instalado.
2. Ejecutar la aplicación sin forzar Wayland nativo (dejar que use XWayland para el tray).
3. Reiniciar Waybar con `Super + Shift + B`.

## Requisitos de Entorno

- **Polkit Agent:** Se requiere un agente de autenticación activo. Se recomienda `hyprpolkitagent` (instalado y gestionado vía systemd). Debe iniciarse con `exec-once = systemctl --user start hyprpolkitagent` en `hyprland.conf`.
- **Variables de Entorno:** Para herramientas de GNOME como `gnome-control-center`, es necesario prefijar con `XDG_CURRENT_DESKTOP=GNOME` para habilitar paneles específicos.
