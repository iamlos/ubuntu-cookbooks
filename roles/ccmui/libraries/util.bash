#!/bin/bash -e

source "$(dirname "${BASH_SOURCE[0]}")/../../../libraries/util.bash"

function cleanUpITMess
{
    header 'CLEANING UP IT MESS'

    deleteUser 'itcloud'
    rm -f -r '/home/ubuntu' '/opt/chef' '/opt/lost+found'

    # Remove and Disable Dovecot Process

    local dovecotStatus="$(status 'dovecot' 2> '/dev/null' | grep -F -o 'start/running')"

    if [[ "$(isEmptyString "${dovecotStatus}")" = 'false' ]]
    then
        stop 'dovecot'
        rm -f '/etc/init/dovecot.conf'
    fi

    # Enable Hostname Service

    sysv-rc-conf --level 2345 'hostname' on
}

function displayNotice()
{
    local userLogin="${1}"

    header 'NOTICES'

    local userHome="$(getUserHomeFolder "${userLogin}")"

    checkExistFolder "${userHome}"
    checkExistFile "${userHome}/.ssh/id_rsa.pub"

    info "-> Next is to copy this RSA to your git account :"
    cat "${userHome}/.ssh/id_rsa.pub"
    echo
}

function extendOPTPartition()
{
    local disk="${1}"
    local mountOn="${2}"
    local mounthdPartitionNumber="${3}"

    if [[ "$(existDisk "${disk}")" = 'true' ]]
    then
        if [[ "$(existDiskMount "${disk}${mounthdPartitionNumber}" "${mountOn}")" = 'false' ]]
        then
            rm -f -r "${mountOn}"
            "$(dirname "${BASH_SOURCE[0]}")/../../../cookbooks/mount-hd/recipes/install.bash" "${disk}" "${mountOn}"
        else
            header 'EXTENDING OPT PARTITION'
            info "Already mounted '${disk}${mounthdPartitionNumber}' to '${mountOn}'\n"
            df -h -T
        fi
    else
        header 'EXTENDING OPT PARTITION'
        info "Extended volume '${disk}' not found"
    fi
}