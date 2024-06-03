#!/bin/bash

echo -e "${LBLUE}"
echo -e "[$0]: 4. Finished. See the \"Import Manually\" folder and grab anything you need."
echo -e "If you are new to Hyprland, please read"
echo -e "https://end-4.github.io/dots-hyprland-wiki/en/i-i/01setup/#post-installation"
echo -e "for hints on launching Hyprland."
echo -e "If you are already running Hyprland,"
echo -e "Press ${BLUE}Ctrl+Super+T${NONE} to select a wallpaper"
echo -e "Press ${BLUE}Super+/${NONE} for a list of keybinds"
echo -e "${NONE}"

case $existed_ags_opt in
y)
  echo -e "${YELLOW}[$0]: Warning: \"~/.config/ags/user_options.js\" already existed before and we didn't overwrite it.${NONE}"
  #    printf "\e[33mPlease use \"~/.config/ags/user_options.js.new\" as a reference for a proper format.\e[0m\n"
  ;;
esac
case $existed_hypr_conf in
y)
  echo -e "${YELLOW}"
  echo -e "[$0]: Warning: \"~/.config/hypr/hyprland.conf\" already existed before and we didn't overwrite it."
  echo -e "Please use \"~/.config/hypr/hyprland.conf.new\" as a reference for a proper format."
  echo -e "If this is your first time installation, you must overwrite \"~/.config/hypr/hyprland.conf\" with \"~/.config/hypr/hyprland.conf.new\"."
  echo -e "${NONE}"
  ;;
esac
