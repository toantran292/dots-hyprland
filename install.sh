#!/bin/bash
cd "$(dirname "$0")"
export base="$(pwd)"
source .install/includes/installers.sh
source .install/includes/colors.sh
source .install/includes/functions.sh
source .install/includes/options.sh

#####################################################################################
source .install/phases/0-check-required-and-confirm.sh
source .install/phases/1-get-packages-and-setup-user-groups-services.sh
source .install/phases/2-installing-parts-from-source-repo.sh
source .install/phases/3-copying-and-configuring.sh
source .install/phases/4-finished.sh
