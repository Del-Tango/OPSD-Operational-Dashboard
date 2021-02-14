#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# COLD BANNER

TMP_FILE="/tmp/od-hb-${RANDOM}.tmp"
BLUE=`tput setaf 4`
CYAN=`tput setaf 6`
RESET=`tput sgr0`

function display_cold_banner () {
    figlet -f lean -w 1000 Ops.Dash > $TMP_FILE
    echo "${BLUE}`cat $TMP_FILE`${RESET}"
    echo "    ${CYAN}Operational Dashboard ${RESET}*${CYAN}"\
        "Powered by Alveare Solutions!${RESET}"
    rm $TMP_FILE &> /dev/null
    return 0
}

display_cold_banner
