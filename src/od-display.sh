#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_available_cargo () {
    echo; info_msg "Available cargo scripts -
    "
    echo "${CYAN}${!OD_CARGO[@]}${RESET}" | column
    return $?
}

function display_op_dashboard_settings () {
    echo "[ ${CYAN}Banner${RESET}        ]: ${MAGENTA}${MD_DEFAULT['banner']}${RESET}
[ ${CYAN}Log File${RESET}      ]: ${YELLOW}${MD_DEFAULT['log-file']}${RESET}
[ ${CYAN}Log Lines${RESET}     ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}Modules${RESET}       ]: ${WHITE}${#OD_ADDONS[@]}${RESET}
    "
    return $?
}

function display_op_dashboard_banner () {
    clear
    case "${MD_DEFAULT['banner']}" in
        *','*)
            for cargo_key in `echo ${MD_DEFAULT['banner']} | sed 's/,/ /g'`; do
                ${OD_CARGO[$cargo_key]} "$CONF_FILE_PATH"
            done
            ;;
        *)
            ${OD_CARGO[${MD_DEFAULT['banner']}]}
            ;;
    esac
    return $?
}
