#!/bin/sh

################################################################################
# configure permissions on the shared mount directory used by the service user.
#

set -eu

function main() {
    if [[ -z "${1}" || "${1}" == "-h" || "${1}" == "--help" ]]; then
        printf "%s target_user_name\n" "${BASH_SOURCE[1]}"
    fi

    local user_name="${1:-}"

    mkdir -p /var/run/${user_name}

    chown -R root:${user_name} /var/run/${user_name}
    chmod -R u=rwX,g=rwX,o=--- /var/run/${user_name}

    return 0
}

main "$@"
