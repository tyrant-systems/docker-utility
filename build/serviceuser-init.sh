#!/bin/bash

################################################################################
# configure permissions on the shared mount directory used by the service user.
#

set -e

function main() {
    local user_name

    while (("$#")); do
        case ${1} in
        -h | --help)
            printf "%s [OPTIONS]\n" "${BASH_SOURCE[1]}"
            printf "\t%s\n" "-N [--name]          USER_NAME"

            return 1
            ;;
        -N | --name)
            user_name=${2}
            shift
            ;;
        *)
            echo "invalid argument, '${1}'"
            return 1
            ;;
        esac
        shift
    done

    set -u

    mkdir -p /var/run/${user_name}

    chown -R root:${user_name} /var/run/${user_name}
    chmod -R u=rwX,g=rwX,o=--- /var/run/${user_name}

    return 0
}

main "$@"
