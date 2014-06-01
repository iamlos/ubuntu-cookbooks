#!/bin/bash

function install()
{
    # Clean Up

    rm -rf "${installFolder}" '/usr/local/bin/go' '/usr/local/bin/godoc' '/usr/local/bin/gofmt'
    mkdir -p "${installFolder}"

    # Install

    unzipRemoteFile "${downloadURL}" "${installFolder}"
    chown -R "$(whoami)":"$(whoami)" "${installFolder}"
    symlinkLocalBin "${installFolder}/bin"

    # Config Profile

    local profileConfigData=('__INSTALL_FOLDER__' "${installFolder}")

    createFileFromTemplate "${appPath}/../files/profile/go-lang.sh" '/etc/profile.d/go-lang.sh' "${profileConfigData[@]}"
}

function main()
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash" || exit 1
    source "${appPath}/../attributes/default.bash" || exit 1

    checkRequireDistributor

    header 'INSTALLING GO-LANG'

    checkRequireRootUser

    install
    installCleanUp
}

main "${@}"
