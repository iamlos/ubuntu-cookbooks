#!/bin/bash -e

function main()
{
    local -r attributeFile="${1}"

    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local -r command='last -a -F -i -w -x -10'

    "${appFolderPath}/../../../../../../../../tools/run-remote-command.bash" \
        --attribute-file "${attributeFile}" \
        --command "${command}" \
        --machine-type 'masters-slaves'
}

main "${@}"