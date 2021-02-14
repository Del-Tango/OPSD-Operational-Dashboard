#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_dashboard_banner_cargo_keys () {
    local CARGO_KEYS="$1"
    if [ -z "$CARGO_KEYS" ]; then
        warning_msg "No cargo keys supplied to be set as dashboard banner."
        return 1
    fi
    MD_DEFAULT['banner']="$CARGO_KEYS"
    return 0
}

function set_log_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
        return 1
    fi
    MD_DEFAULT['log-file']="$FILE_PATH"
    return 0
}

function set_log_lines () {
    local LOG_LINES=$1
    if [ -z "$LOG_LINES" ]; then
        error_msg "Log line value (${RED}$LOG_LINES${RESET}) is not a number."
        return 1
    fi
    MD_DEFAULT['log-lines']=$LOG_LINES
    return 0
}
