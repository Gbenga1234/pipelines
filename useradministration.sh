#!/bin/bash

AUDIT_LOG="/var/log/user_mgmt_audit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$AUDIT_LOG"
}

# Ensure script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

create_group() {
    local GROUP_NAME="$1"
    if getent group "$GROUP_NAME" > /dev/null; then
        log "Group '$GROUP_NAME' already exists."
    else
        groupadd "$GROUP_NAME"
        log "Group '$GROUP_NAME' created."
    fi
}

create_user() {
    local USER="$1"
    local GROUP="$2"

    if id "$USER" &>/dev/null; then
        log "User '$USER' already exists."
    else
        useradd -m -g "$GROUP" "$USER"
        log "User '$USER' created and added to group '$GROUP'."
    fi
}

add_user_to_group() {
    local USER="$1"
    local GROUP="$2"

    usermod -aG "$GROUP" "$USER"
    log "User '$USER' added to group '$GROUP'."
}

set_permissions() {
    local PATH_TARGET="$1"
    local OWNER="$2"
    local PERMS="$3"

    chown "$OWNER" "$PATH_TARGET"
    chmod "$PERMS" "$PATH_TARGET"
    log "Set ownership of $PATH_TARGET to '$OWNER' with permissions '$PERMS'."
}

# --------- SAMPLE OPERATIONS ---------

# Create groups
create_group "devops"
create_group "backend"

# Create users and assign to primary group
create_user "john" "devops"
create_user "mary" "backend"

# Add users to secondary groups
add_user_to_group "mary" "devops"

# Set file permissions (example)
set_permissions "/opt/app" "john:devops" "770"

log "User and group operations completed successfully."

