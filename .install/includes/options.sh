#!/bin/bash
# This is NOT a script for execution, but for loading functions, so NOT need execution permission.
# NOTE that you NOT need to `cd ..' because the `$0' is NOT this file, but the script file which will source this file.

# The script that use this file should have two lines on its top as follows:
# cd "$(dirname "$0")" export base="$(pwd)"
showhelp() {
  echo -e "Syntax: $0 [Options]...

Idempotent installation script for dotfiles.
If no option is specified, run default install process.

  -h, --help                Print this help message and exit
  -f, --force               (Dangerous) Force mode without any confirm
  -c, --clean               Clean the build cache first
  -s, --skip-sysupdate      Skip \"sudo pacman -Syu\"
      --skip-ags            Skip installing ags and its config
      --skip-hyprland       Skip installing the config for Hyprland
      --skip-hypr-aur       Skip installing hyprland-git
      --skip-pymyc-aur      Skip installing python-materialyoucolor-git, gradience-git,
                            python-libsass and python-material-color-utilities
      --skip-fish           Skip installing the config for Fish
      --skip-plasmaintg     Skip installing plasma-browser-integration
      --skip-miscconf       Skip copying the dirs and files to \".configs\" except for
                            AGS, Fish and Hyprland
      --deplistfile <path>  Specify a dependency list file. By default
                            \"./scriptdata/dependencies.conf\"
      --fontset <set>       (Unavailable yet) Use a set of pre-defined font and config
"
}

cleancache() {
  rm -rf "$base/cache"
}

# `man getopt` to see more
para=$(getopt \
  -o hfk:cs \
  -l help,force,fontset:,deplistfile:,clean,skip-sysupdate,skip-ags,skip-fish,skip-hyprland,skip-hypr-aur,skip-pymyc-aur,skip-plasmaintg,skip-miscconf \
  -n "$0" -- "$@")
[ $? != 0 ] && echo "$0: Error when getopt, please recheck parameters." && exit 1
#####################################################################################
## getopt Phase 1
# ignore parameter's order, execute options below first
eval set -- "$para"
while true; do
  case "$1" in
  -h | --help)
    showhelp
    exit
    ;;
  -c | --clean)
    cleancache
    shift
    ;;
  --) break ;;
  *) shift ;;
  esac
done
#####################################################################################
## getopt Phase 2
DEPLISTFILE=.install/includes/dependencies.conf

eval set -- "$para"
while true; do
  case "$1" in
  ## Already processed in phase 1, but not exited
  -c | --clean) shift ;;
  ## Ones without parameter
  -f | --force)
    ask=false
    shift
    ;;
  -s | --skip-sysupdate)
    SKIP_SYSUPDATE=true
    shift
    ;;
  --skip-ags)
    SKIP_AGS=true
    shift
    ;;
  --skip-hyprland)
    SKIP_HYPRLAND=true
    shift
    ;;
  --skip-hypr-aur)
    SKIP_HYPR_AUR=true
    shift
    ;;
  --skip-pymyc-aur)
    SKIP_PYMYC_AUR=true
    shift
    ;;
  --skip-fish)
    SKIP_FISH=true
    shift
    ;;
  --skip-miscconf)
    SKIP_MISCCONF=true
    shift
    ;;
  --skip-plasmaintg)
    SKIP_PLASMAINTG=true
    shift
    ;;
  ## Ones with parameter

  --deplistfile)
    if [ -f "$2" ]; then
      DEPLISTFILE="$2"
    else
      echo -e "Deplist file \"$2\" does not exist."
      exit 1
    fi
    shift 2
    ;;

  --fontset)
    case $2 in
    "default" | "zh-CN" | "vi") fontset="$2" ;;
    *)
      echo -e "Wrong argument for $1."
      exit 1
      ;;
    esac
    echo "The fontset is ${fontset}."
    shift 2
    ;;

  ## Ending
  --) break ;;
  *)
    echo -e "$0: Wrong parameters."
    exit 1
    ;;
  esac
done
