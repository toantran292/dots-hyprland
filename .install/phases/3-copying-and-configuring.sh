#!/bin/bash

echo -e "${LBLUE}[$0]: 3. Copying + Configuring${NONE}"

# In case some folders does not exists
v mkdir -p "$HOME"/.{config,cache,local/{bin,share}}

# `--delete' for rsync to make sure that
# original dotfiles and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together

# MISC (For .config/* but not AGS, not Fish, not Hyprland)
case $SKIP_MISCCONF in
true) sleep 0 ;;
*)
  for i in $(find .config/ -mindepth 1 -maxdepth 1 ! -name 'ags' ! -name 'fish' ! -name 'hypr' -exec basename {} \;); do
    i=".config/$i"
    echo "[$0]: Found target: $i"
    if [ -d "$i" ]; then
      v rsync -av --delete "$i/" "$HOME/$i/"
    elif [ -f "$i" ]; then
      v rsync -av "$i" "$HOME/$i"
    fi
  done
  ;;
esac

case $SKIP_FISH in
true) sleep 0 ;;
*)
  v rsync -av --delete .config/fish/ "$HOME"/.config/fish/
  ;;
esac

# For AGS
case $SKIP_AGS in
true) sleep 0 ;;
*)
  v rsync -av --delete --exclude '/user_options.js' .config/ags/ "$HOME"/.config/ags/
  t="$HOME/.config/ags/user_options.js"
  if [ -f $t ]; then
    echo -e "${BLUE}[$0]: \"$t\" already exists.${NONE}"
    # v cp -f .config/ags/user_options.js $t.new
    existed_ags_opt=y
  else
    echo -e "${YELLOW}[$0]: \"$t\" does not exist yet.${NONE}"
    v cp .config/ags/user_options.js $t
    existed_ags_opt=n
  fi
  ;;
esac

# For Hyprland
case $SKIP_HYPRLAND in
true) sleep 0 ;;
*)
  v rsync -av --delete --exclude '/custom' --exclude '/hyprland.conf' .config/hypr/ "$HOME"/.config/hypr/
  t="$HOME/.config/hypr/hyprland.conf"
  if [ -f $t ]; then
    echo -e "${BLUE}[$0]: \"$t\" already exists.${NONE}"
    v cp -f .config/hypr/hyprland.conf $t.new
    existed_hypr_conf=y
  else
    echo -e "${YELLOW}[$0]: \"$t\" does not exist yet.${NONE}"
    v cp .config/hypr/hyprland.conf $t
    existed_hypr_conf=n
  fi
  t="$HOME/.config/hypr/custom"
  if [ -d $t ]; then
    echo -e "${BLUE}[$0]: \"$t\" already exists, will not do anything.${NONE}"
  else
    echo -e "${YELLOW}[$0]: \"$t\" does not exist yet.${NONE}"
    v rsync -av --delete .config/hypr/custom/ $t/
  fi
  ;;
esac

# some foldes (eg. .local/bin) should be processed separately to avoid `--delete' for rsync,
# since the files here come from different places, not only about one program.
v rsync -av ".local/bin/" "$HOME/.local/bin/"

# Dark mode by default
v gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Prevent hyprland from not fully loaded
sleep 1
try hyprctl reload

cp $base/.zshrc $HOME/.zshrc
existed_zsh_conf=n
grep -q 'source ~/.config/zshrc.d/dots-hyprland.zsh' ~/.zshrc && existed_zsh_conf=y
