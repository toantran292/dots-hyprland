#!/bin/bash
cd "$(dirname "$0")"
export base="$(pwd)"
source .install/includes/installers.sh
source .install/includes/colors.sh
source .install/includes/functions.sh
source .install/includes/options.sh

#####################################################################################
source .install/phases/0-check-required-and-confirm.sh

set -e
#####################################################################################
echo -e "${LBLUE}[$0]: 1. Get packages and setup user groups/services${NONE}"
case $SKIP_SYSUPDATE in
true) sleep 0 ;;
*) v sudo pacman -Syu ;;
esac

remove_bashcomments_emptylines ${DEPLISTFILE} ./cache/dependencies_stripped.conf
readarray -t pkglist <./cache/dependencies_stripped.conf

if ! command -v yay >/dev/null 2>&1; then
  if ! command -v paru >/dev/null 2>&1; then
    echo -e "${YELLOW}[$0]: \"yay\" not found.${NONE}"
    showfun install-yay
    v install-yay
    AUR_HELPER=yay
  else
    echo -e "${YELLOW}"
    echo -e "[$0]: \"yay\" not found, but \"paru\" found."
    echo -e "It is not recommended to use \"paru\" as warned in Hyprland Wiki:"
    echo -e "    \"If you are using the AUR (hyprland-git) package, you will need to cleanbuild to update the package. Paru has been problematic with updating before, use Yay.\""
    echo -e "Reference: https://wiki.hyprland.org/FAQ/#how-do-i-update"
    echo -e "${NONE}"
    if $ask; then
      printf "Install \"yay\"?\n"
      p=$(gum choose "Yes, install \"yay\" for me first." "No, use \"paru\" at my own risk." "Abort.")
      sleep 2
      case $p in
      "No, use \"paru\" at my own risk.") AUR_HELPER=paru ;;
      "Abort.")
        echo -e "${LBLUE}Alright, aborting...${NONE}"
        exit 1
        ;;
      "Yes, install \"yay\" for me first.")
        v paru -S --needed --noconfirm yay-bin
        AUR_HELPER=yay
        ;;
      esac
    else
      AUR_HELPER=paru
    fi
  fi
else
  AUR_HELPER=yay
fi

if $ask; then
  # execute per element of the array $pkglist
  for i in "${pkglist[@]}"; do v $AUR_HELPER -S --needed $i; done
else
  # execute for all elements of the array $pkglist in one line
  v $AUR_HELPER -S --needed --noconfirm ${pkglist[*]}
fi

case $SKIP_HYPR_AUR in
true) sleep 0 ;;
*)
  if $ask; then
    v $AUR_HELPER -S --answerclean=a hyprland-git
  else
    v $AUR_HELPER -S --answerclean=a --noconfirm hyprland-git
  fi
  ;;
esac

pymyc=(python-materialyoucolor-git gradience-git python-libsass python-material-color-utilities)
case $SKIP_PYMYC_AUR in
true) sleep 0 ;;
*)
  if $ask; then
    v $AUR_HELPER -S --answerclean=a ${pymyc[@]}
  else
    v $AUR_HELPER -S --answerclean=a --noconfirm ${pymyc[@]}
  fi
  ;;
esac

if pacman -Qs ^plasma-browser-integration$; then SKIP_PLASMAINTG=true; fi

case $SKIP_PLASMAINTG in
true) sleep 0 ;;
*)
  if $ask; then
    echo -e "${LBLUE}"
    echo -e "[$0]: 2. Install \"plasma-browser-integration\""
    echo -e "NOTE: The size of \"plasma-browser-integration\" is about 250 MiB."
    echo -e "It is needed if you want playtime of media in Firefox to be shown on the music controls widget."
    echo -e "${NONE}"
    if gum confirm "Install it?"; then
      p=y
    fi
  else
    p=y
  fi
  case $p in
  y) x sudo pacman -S --needed --noconfirm plasma-browser-integration ;;
  *) echo "Ok, won't install" ;;
  esac
  ;;
esac

v sudo usermod -aG video,i2c,input "$(whoami)"
v bash -c "echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf"
v systemctl --user enable ydotool --now

#####################################################################################
echo -e "${LBLUE}[$0]: 2. Installing parts from source repo${NONE}"
sleep 1

case $SKIP_AGS in
true) sleep 0 ;;
*)
  if command -v ags >/dev/null 2>&1; then
    echo -e "${YELLOW}[$0]: Command \"ags\" already exists, no need to install.${NONE}"
    echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
    ask_ags=$ask
  else
    ask_ags=true
  fi
  if $ask_ags; then
    showfun install-ags
    v install-ags
  fi
  ;;
esac

if $(fc-list | grep -q Rubik); then
  echo -e "${YELLOW}[$0]: Font \"Rubik\" already exists, no need to install.${NONE}"
  echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
  ask_Rubik=$ask
else
  ask_Rubik=true
fi
if $ask_Rubik; then
  showfun install-Rubik
  v install-Rubik
fi

if $(fc-list | grep -q Gabarito); then
  echo -e "${YELLOW}[$0]: Font \"Gabarito\" already exists, no need to install.${NONE}"
  echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
  ask_Gabarito=$ask
else
  ask_Gabarito=true
fi
if $ask_Gabarito; then
  showfun install-Gabarito
  v install-Gabarito
fi

if $(test -d /usr/local/share/icons/OneUI); then
  echo -e "${YELLOW}[$0]: Icon pack \"OneUI\" already exists, no need to install.${NONE}"
  echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
  ask_OneUI=$ask
else
  ask_OneUI=true
fi
if $ask_OneUI; then
  showfun install-OneUI
  v install-OneUI
fi

if $(test -d /usr/local/share/icons/Bibata-Modern-Classic); then
  echo -e "${YELLOW}[$0]: Cursor theme \"Bibata-Modern-Classic\" already exists, no need to install.${NONE}"
  echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
  ask_bibata=$ask
else
  ask_bibata=true
fi
if $ask_bibata; then
  showfun install-bibata
  v install-bibata
fi

if command -v LaTeX >/dev/null 2>&1; then
  echo -e "${YELLOW}[$0]: Program \"LaTeX\" already exists, no need to install.${NONE}"
  echo -e "${LBLUE}You can reinstall it in order to update to the latest version anyway.${NONE}"
  ask_MicroTeX=$ask
else
  ask_MicroTeX=true
fi
if $ask_MicroTeX; then
  showfun install-MicroTeX
  v install-MicroTeX
fi
#####################################################################################
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

existed_zsh_conf=n
grep -q 'source ~/.config/zshrc.d/dots-hyprland.zsh' ~/.zshrc && existed_zsh_conf=y

#####################################################################################
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
