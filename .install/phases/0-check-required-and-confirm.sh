#!/bin/bash
if ! command -v pacman >/dev/null 2>&1; then
  echo -e "${RED}[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...${NONE}"
  exit 1
fi
prevent_sudo_or_root

pacman -Syu --noconfirm --needed gum

startask() {
  echo -e "${BLUE}"
  echo "[$0]: Hi there! Before we start:"
  echo "This script 1. only works for ArchLinux and Arch-based distros."
  echo "            2. does not handle system-level/hardware stuff like Nvidia drivers"

  if gum confirm "Please CONFIRM that you HAVE ALREADY BACKED UP \"$HOME/.config/\" and \"$HOME/.local/\" folders!"; then
    sleep 0
  else
    echo "Aborting..."
    exit 1
  fi

  echo -e "${NONE}"
  echo "Do you want to confirm every time before a command executes?"
  p=$(gum choose "Yes, ask me before executing each of them." "No, just execute them automatically." "Abort.")
  case $p in
  "No, just execute them automatically.") ask=false ;;
  "Abort.") exit 1 ;;
  *) ask=true ;;
  esac
}

case $ask in
false) sleep 0 ;;
*) startask ;;
esac
