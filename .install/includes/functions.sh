#!/usr/bin/env bash
# This is NOT a script for execution, but for loading functions, so NOT need execution permission.
# NOTE that you NOT need to `cd ..' because the `$0' is NOT this file, but the script file which will source this file.

# The script that use this file should have two lines on its top as follows:
# cd "$(dirname "$0")"
# export base="$(pwd)"

# source ./colors.sh

function try { "$@" || sleep 0; }
function v() {
  echo -e "####################################################"
  echo -e "${BLUE}[$0]: Next command:${NONE}"
  echo -e "${GREEN}$@${NONE}"
  execute=true
  if $ask; then
    while true; do
      p=$(gum choose "Yes, execute it." "No, skip it." "Exit now." "Yes and don't ask again.")
      echo -e "${BLUE}Execute?${NONE}"
      case $p in
      "Yes, execute it.")
        echo -e "${BLUE}OK, executing...${NONE}"
        break
        ;;
      "Exit now.")
        echo -e "${BLUE}Exiting...${NONE}"
        exit
        break
        ;;
      "No, skip it.")
        echo -e "${BLUE}Alright, skipping this one...${NONE}"
        execute=false
        break
        ;;
      "Yes and don't ask again.")
        echo -e "${BLUE}Alright, won't ask again. Executing...${NONE}"
        ask=false
        break
        ;;
      esac
    done
  fi
  if $execute; then x "$@"; else
    echo -e "${YELLOW}[$0]: Skipped \"$@\"${NONE}"
  fi
}
# When use v() for a defined function, use x() INSIDE its definition to catch errors.
function x() {
  if "$@"; then cmdstatus=0; else cmdstatus=1; fi # 0=normal; 1=failed; 2=failed but ignored
  while [ $cmdstatus == 1 ]; do
    echo -e "${RED}[$0]: Command \"${GREEN}$@${RED}\" has failed."
    echo -e "You may need to resolve the problem manually BEFORE repeating this command.${NONE}"
    p=$(gum choose "Repeat this command" "Exit now" "Ignore this error and continue (your setup might not work correctly)")
    case $p in
    "Repeat this command")
      echo -e "${BLUE}OK, repeating...${NONE}"
      if "$@"; then cmdstatus=0; else cmdstatus=1; fi
      ;;
    "Exit now")
      echo -e "${BLUE}Alright, exiting...${NONE}"
      exit 1
      ;;
    "Ignore this error and continue (your setup might not work correctly)")
      echo -e "${BLUE}Alright, ignore and continue...${NONE}"
      cmdstatus=2
      ;;
    esac
  done

  case $cmdstatus in
  0) echo -e "${LBLUE}[$0]: Command \"${GREEN}$@${LBLUE}\" finished.${NONE}" ;;
  1)
    echo -e "${RED}[$0]: Command \"${GREEN}$@${RED}\" has failed. Exiting...${NONE}"
    exit 1
    ;;
  2) echo -e "${RED}[$0]: Command \"${GREEN}$@${RED}\" has failed but ignored by user.${NONE}" ;;
  esac
}
function showfun() {
  echo -e "${BLUE}[$0]: The definition of function \"$1\" is as follows:${NONE}"
  echo -e "${GREEN}"
  type -a $1
  echo -e "${NONE}"
  # printf "\e[97m"
}
function remove_bashcomments_emptylines() {
  mkdir -p $(dirname $2)
  cat $1 | sed -e '/^[[:blank:]]*#/d;s/#.*//' -e '/^[[:space:]]*$/d' >$2
}
function prevent_sudo_or_root() {
  case $(whoami) in
  root)
    echo -e "${RED}[$0]: This script is NOT to be executed with sudo or as root. Aborting...${NONE}"
    exit 1
    ;;
  esac
}
