#!/bin/bash -e

function main()
{
    local -r attributeFile="${1}"

    local -r appFolderPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${appFolderPath}/../../attributes/it-cloud-slave.bash"

    local -r command="cd /var/tmp &&
                      sudo rm -f -r ubuntu-cookbooks &&
                      sudo git clone --depth=1 https://github.com/gdbtek/ubuntu-cookbooks.git &&
                      sudo /var/tmp/ubuntu-cookbooks/cookbooks/node-js/recipes/install.bash '${CCMUI_JENKINS_NODE_JS_VERSION}' '${CCMUI_JENKINS_NODE_JS_INSTALL_FOLDER}'
                      sudo rm -f -r /var/tmp/ubuntu-cookbooks"

    "${appFolderPath}/../../../../../../../../tools/run-remote-command.bash" \
        --attribute-file "${attributeFile}" \
        --command "${command}" \
        --machine-type 'masters-slaves'
}

main "${@}"