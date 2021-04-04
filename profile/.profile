XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# to make dolphin load icons
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"
