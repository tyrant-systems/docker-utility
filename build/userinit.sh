#!/bin/sh

################################################################################
# configures a service user used by the container to match the uid/guid of
# other running containers on the same network.
#

set -eu

function main() {
    if [[ -z "${1}" || "${1}" == "-h" || "${1}" == "--help" ]]; then
        printf "%s target_user_name target_user_id target_group_id [OPTS...] \n" "${BASH_SOURCE[1]}"
    fi

    local user_name="${1:-}"
    local user_id="${2:-}"
    local user_guid="${3:-}"

    if [[ -n "${user_id}" ]]; then
        usermod -u "${user_id}" "${user_name}"
    fi

    if [[ -n "${user_guid}" ]]; then
        groupmod -g "${user_guid}" "${user_name}"
    fi

    # configure permissions on the directory used by the service user

    mkdir -p /var/run/${user_name}

    chown -R root:"${user_name}" /var/run/${user_name}
    chmod -R u=rwX,g=rwX,o=--- /var/run/${user_name}
}

main "$@"
