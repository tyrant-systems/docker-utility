#!/bin/sh

################################################################################
# configures a service user used by the container to match the uid/guid of
# other running containers on the same network.
#

set -eu

function main() {
    if [[ -z "${1}" || "${1}" == "-h" || "${1}" == "--help" ]]; then
        printf "%s target_user_name target_user_home target_user_id target_group_id\n" "${BASH_SOURCE[1]}"
        return 1
    fi

    local user_name="${1:-}"
    local user_home="${2:-}"
    local user_id="${3:-}"
    local user_guid="${4:-}"

    if [[ -z "${user_name}" || -z "${user_home}" || -z "${user_id}" || -z "${user_guid}" ]]; then
        printf "error: %s\n" "missing argument (user_name=${user_name}, user_home=${user_home}, user_id=${user_id}, user_guid=${user_guid}), see \"--help\" for required positional arguments"
        return 1
    fi

    addgroup ${user_name} --gid ${user_guid} &&
        adduser ${user_name} -D --uid ${user_id} --gid ${user_guid} --home ${suhome}

    chown -R ${suhome}:${suhome}

    return 0
}

main "$@"
