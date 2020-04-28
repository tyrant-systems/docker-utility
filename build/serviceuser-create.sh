#!/bin/sh

################################################################################
# configures a service user used by the container to match the uid/guid of
# other running containers on the same network.
#

set -e

function main() {
    local user_name
    local user_home
    local user_id
    local user_guid
    local container_os

    container_os="UBUNTU"

    while (("$#")); do
        printf "FLAG VARS: %s\n" "${1}=${2}"
        case ${1} in
        --help)
            printf "%s [OPTIONS]\n" "${BASH_SOURCE[1]}"
            printf "\t%s\n" "-N [--name]          USER_NAME"
            printf "\t%s\n" "-H [--home]          HOME_DIR"
            printf "\t%s\n" "-U [--uid ]          USER_ID"
            printf "\t%s\n" "-G [--guid]          GROUP_ID"
            printf "\t(optional) %s\n" "-O [--os] ALPINE|UBUNTU|RHEL [default: UBUNTU]"

            return 1
            ;;
        --name)
            user_name=${2}
            shift
            ;;
        --home)
            user_home=${2}
            shift
            ;;
        --uid)
            user_id=${2}
            shift
            ;;
        --guid)
            user_guid=${2}
            shift
            ;;
        --os)
            container_os=${2}
            shift
            ;;
        *)
            echo "invalid argument, '${1}'"
            return 1
            ;;
        esac
        shift
    done

    printf "[container_os] %s\n" "${container_os}"
    printf "[user_name] %s\n" "${user_name}"
    printf "[user_home] %s\n" "${user_home}"
    printf "[user_id] %s\n" "${user_id}"
    printf "[user_guid] %s\n" "${user_guid}"

    set -u

    # if [[ -z "${user_name}" || -z "${user_home}" || -z "${user_id}" || -z "${user_guid}" ]]; then
    #     printf "error: %s\n" "missing argument (user_name=${user_name}, user_home=${user_home}, user_id=${user_id}, user_guid=${user_guid}), see \"--help\" for required positional arguments"
    #     return 1
    # fi

    case ${container_os} in
    ALPINE)
        addgroup ${user_name} -G ${user_guid} &&
            adduser ${user_name} -D -u ${user_id} -G ${user_name} -h ${user_home}
        ;;
    UBUNTU | RHEL)
        addgroup ${user_name} --gid ${user_guid} &&
            adduser ${user_name} -D --uid ${user_id} --gid ${user_guid} --home ${user_home}
        ;;
    *)
        printf "%s\n" "error: unsupported platform ${container_os}"
        return 1
        ;;
    esac

    chown -R ${user_name}:${user_name} ${user_home}

    return 0
}

main "$@"
