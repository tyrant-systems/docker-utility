#!/bin/bash

################################################################################
# configure permissions on the shared mount directory used by the service user.
#

set -e

function main() {
    local user_name
    local run_dir

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

    run_dir="/var/run/${user_name}"

    printf "[user_name] %s\n" "${user_name}"
    printf "[run_dir] %s\n" "${run_dir}"

    set -u

    mkdir -p ${run_dir}

    chown -R root:${user_name} ${run_dir}
    chmod -R u=rwX,g=rwX,o=--- ${run_dir}

    return 0
}

main "$@"
