#!/bin/bash -e

function installDependencies()
{
    installAptGetPackages 'build-essential'
}

function install()
{
    # Install

    local -r tempFolder="$(getTemporaryFolder)"

    unzipRemoteFile "${VMWARE_TOOLS_DOWNLOAD_URL}" "${tempFolder}"
    cd "${tempFolder}"
    "${tempFolder}/vmware-install.pl"
    rm -f -r "${tempFolder}"
}

function main()
{
    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${appFolderPath}/../../../libraries/util.bash"
    source "${appFolderPath}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING VMWARE-TOOLS'

    installDependencies
    install
    installCleanUp
}

main "${@}"