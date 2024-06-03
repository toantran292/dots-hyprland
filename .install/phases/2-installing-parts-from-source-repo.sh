#!/bin/bash

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
