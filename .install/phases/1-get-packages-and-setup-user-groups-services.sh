#!/bin/bash

set -e
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
