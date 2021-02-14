#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_addon_module_panel () {
    while :
    do
        echo; symbol_msg "${BLUE}$SCRIPT_NAME${RESET}" "Loaded Modules
            "
        ADDON=`fetch_selection_from_user 'Module' ${!OD_ADDONS[@]}`
        if [ $? -ne 0 ]; then
            return 0
        fi
        check_item_in_set "$ADDON" ${!OD_ADDONS_ARGS[@]}
        if [ $? -ne 0 ]; then
            local ARGS=''
        else
            local ARGS="${OD_ADDONS_ARGS[$ADDON]}"
        fi
        trap "echo; done_msg 'Terminating module ($ADDON)'" INT
        cd `dirname ${OD_ADDONS[$ADDON]}` &> /dev/null
        ${OD_ADDONS[$ADDON]} $ARGS
        cd - &> /dev/null
        EXIT_CODE=$?
        trap - INT
    done
}

function action_set_banner_script () {
    display_available_cargo
    echo; info_msg "Type cargo label(s) to execute as dashboard banner"\
        "or (${MAGENTA}.back${RESET})."
    info_msg "If multiple labels are required to build banner,"\
        "separate them by commas."
    while :
    do
        CARGO_KEYS=`fetch_data_from_user 'BannerCargo'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        break
    done
    echo; set_dashboard_banner_cargo_keys "$CARGO_KEYS"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set cargo key(s) (${RED}$CARGO_KEYS${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) banner."
    else
        ok_msg "Successfully set cargo key(s) (${GREEN}$CARGO_KEYS${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) banner."
    fi
    return $EXIT_CODE
}

function action_install_dependencies () {
    echo
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 1
    fi
    apt_install_dependencies
    return 0
}

function action_set_log_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    echo; set_log_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) log file."
    else
        ok_msg "Successfully set (${BLUE}$SCRIPT_NAME${RESET}) log file"\
            "(${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_log_lines () {
    echo; info_msg "Type log line number to display or (${MAGENTA}.back${RESET})."
    while :
    do
        LOG_LINES=`fetch_data_from_user 'LogLines'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 1
        fi
        check_value_is_number $LOG_LINES
        if [ $? -ne 0 ]; then
            warning_msg "LogViewer number of lines required,"\
                "not (${RED}$LOG_LINES${RESET})."
            echo; continue
        fi; break
    done
    echo; set_log_lines $LOG_LINES
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}log lines${RESET} to (${RED}$LOG_LINES${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}log lines${RESET} to (${GREEN}$LOG_LINES${RESET})."
    fi
    return $EXIT_CODE
}


