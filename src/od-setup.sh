#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function op_dashboard_project_setup () {
    lock_and_load
    load_op_dashboard_config
    create_op_dashboard_menu_controllers
    setup_op_dashboard_menu_controllers
    return 0
}

function setup_op_dashboard_menu_controllers () {
    setup_op_dashboard_dependencies
    setup_main_menu_controller
    setup_log_viewer_menu_controller
    setup_settings_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# LOADERS

function load_op_dashboard_config () {
    load_op_dashboard_script_name
    load_op_dashboard_prompt_string
    load_settings_op_dashboard_default
    load_op_dashboard_logging_levels
}

function load_op_dashboard_prompt_string () {
    if [ -z "$OD_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    set_project_prompt "$OD_PS3"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$OD_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$OD_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_op_dashboard_logging_levels () {
    if [ ${#OD_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${OD_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_op_dashboard_default () {
    if [ ${#OD_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for ioc_setting in ${!OD_DEFAULT[@]}; do
        MD_DEFAULT[$ioc_setting]=${OD_DEFAULT[$ioc_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$ioc_setting - ${OD_DEFAULT[$ioc_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_op_dashboard_script_name () {
    if [ -z "$OD_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SCRIPT_NAME."
        return 1
    fi
    set_project_name "$OD_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$OD_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$OD_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

# SETUP DEPENDENCIES

function setup_op_dashboard_dependencies () {
    setup_op_dashboard_apt_dependencies
    return 0
}

function setup_op_dashboard_apt_dependencies () {
    if [ ${#OD_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${OD_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

# MAIN MENU SETUP

function setup_main_menu_controller () {
    setup_main_menu_option_addon_modules
    setup_main_menu_option_log_viewer
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_main_menu_option_addon_modules () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Addon-Modules${RESET}"\
        "to action ${CYAN}action_addon_module_panel${RESET}"
    bind_controller_option \
        "to_action" "$MAIN_CONTROLLER_LABEL" \
        "Addon-Modules" "action_addon_module_panel"
    return $?
}

function setup_main_menu_option_log_viewer () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Log-Viewer${RESET}"\
        "to controller ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Log-Viewer' "$LOGVIEWER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_control_panel () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Control-Panel${RESET}"\
        "to controller ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Control-Panel' "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# LOG VIEWER MENU SETUP

function setup_log_viewer_menu_controller () {
    setup_log_viewer_menu_option_display_tail
    setup_log_viewer_menu_option_display_head
    setup_log_viewer_menu_option_display_more
    setup_log_viewer_menu_option_clear_log_file
    setup_log_viewer_menu_option_back
    done_msg "${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_log_viewer_menu_option_clear_log_file () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Clear-Log${RESET}"\
        "to function ${MAGENTA}action_clear_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Clear-Log' "action_clear_log_file"
    return $?
}

function setup_log_viewer_menu_option_display_tail () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Tail${RESET}"\
        "to function ${MAGENTA}action_display_log_tail${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Tail' "action_log_view_tail"
    return $?
}

function setup_log_viewer_menu_option_display_head () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Head${RESET}"\
        "to function ${MAGENTA}action_display_log_head${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Head' "action_log_view_head"
    return $?
}

function setup_log_viewer_menu_option_display_more () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-More${RESET}"\
        "to function ${MAGENTA}action_display_log_more${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-More' "action_log_view_more"
    return $?
}

function setup_log_viewer_menu_option_back () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# SETTINGS MENU SETUP

function setup_settings_menu_controller () {
    setup_settings_menu_option_set_banner
    setup_settings_menu_option_set_log_file
    setup_settings_menu_option_set_log_lines
    setup_settings_menu_option_install_dependencies
    setup_settings_menu_option_back
    done_msg "${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_settings_menu_option_set_banner () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Banner${RESET}"\
        "to function ${MAGENTA}action_set_banner_script${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Banner" 'action_set_banner_script'
    return $?
}

function setup_settings_menu_option_set_log_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-File${RESET}"\
        "to function ${MAGENTA}action_set_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-File" 'action_set_log_file'
    return $?
}

function setup_settings_menu_option_set_log_lines () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-Lines${RESET}"\
        "to function ${MAGENTA}action_set_log_lines${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-Lines" 'action_set_log_lines'
    return $?
}

function setup_settings_menu_option_install_dependencies () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Install-Dependencies" 'action_install_dependencies'
    return $?
}

function setup_settings_menu_option_back () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# CODE DUMP

#   function setup_main_menu_option_addon () {
#       local ADDON_KEY="$1"
#       info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
#           "${YELLOW}$ADDON_KEY${RESET}"\
#           "to action ${CYAN}${OD_ADDONS[$ADDON_KEY]}${RESET}"
#       bind_controller_option \
#           "to_action" "$MAIN_CONTROLLER_LABEL" \
#           "$ADDON_KEY" "${OD_ADDONS[$ADDON_KEY]}"
#       return $?
#   }

#   function setup_main_menu_options_addons () {
#       if [ ${#OD_ADDONS[@]} -eq 0 ]; then
#           warning_msg "No modules declared as addons."
#           return 1
#       fi
#       SUCCESS_COUNT=0
#       FAILURE_COUNT=0
#       for module in ${!OD_ADDONS[@]}; do
#           setup_main_menu_option_addon "$module"
#           if [ $? -ne 0 ]; then
#               nok_msg "Failed to load module (${RED}$module${RESET})."
#               FAILURE_COUNT=$((FAILURE_COUNT + 1))
#           else
#               ok_msg "Loaded module (${GREEN}$module${RESET})."
#               SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
#           fi
#       done
#       info_msg "Loaded (${GREEN}$SUCCESS_COUNT${RESET}/${WHITE}${#OD_ADDONS[@]}${RESET}) modules,"\
#           "(${RED}$FAILURE_COUNT${RESET}) failures."
#       return 0
#   }

