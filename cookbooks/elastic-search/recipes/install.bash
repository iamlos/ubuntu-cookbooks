#!/bin/bash -e

function installDependencies()
{
    if [[ "$(existCommand 'java')" = 'false' || ! -d "${ELASTIC_SEARCH_JDK_INSTALL_FOLDER}" ]]
    then
        "${APP_FOLDER_PATH}/../../jdk/recipes/install.bash" "${ELASTIC_SEARCH_JDK_INSTALL_FOLDER}"
    fi
}

function install()
{
    # Clean Up

    initializeFolder "${ELASTIC_SEARCH_INSTALL_FOLDER}"

    # Install

    unzipRemoteFile "${ELASTIC_SEARCH_DOWNLOAD_URL}" "${ELASTIC_SEARCH_INSTALL_FOLDER}"

    # Config Profile

    local -r profileConfigData=('__INSTALL_FOLDER__' "${ELASTIC_SEARCH_INSTALL_FOLDER}")

    createFileFromTemplate "${APP_FOLDER_PATH}/../templates/elastic-search.sh.profile" '/etc/profile.d/elastic-search.sh' "${profileConfigData[@]}"

    # Config Upstart

    local -r upstartConfigData=(
        '__INSTALL_FOLDER__' "${ELASTIC_SEARCH_INSTALL_FOLDER}"
        '__JDK_INSTALL_FOLDER__' "${ELASTIC_SEARCH_JDK_INSTALL_FOLDER}"
        '__USER_NAME__' "${ELASTIC_SEARCH_USER_NAME}"
        '__GROUP_NAME__' "${ELASTIC_SEARCH_GROUP_NAME}"
    )

    createFileFromTemplate "${APP_FOLDER_PATH}/../templates/elastic-search.conf.upstart" "/etc/init/${ELASTIC_SEARCH_SERVICE_NAME}.conf" "${upstartConfigData[@]}"

    # Start

    addUser "${ELASTIC_SEARCH_USER_NAME}" "${ELASTIC_SEARCH_GROUP_NAME}" 'false' 'true' 'false'
    chown -R "${ELASTIC_SEARCH_USER_NAME}:${ELASTIC_SEARCH_GROUP_NAME}" "${ELASTIC_SEARCH_INSTALL_FOLDER}"
    start "${ELASTIC_SEARCH_SERVICE_NAME}"

    # Display Open Ports

    displayOpenPorts '10'

    # Display Version

    info "\n$("${ELASTIC_SEARCH_INSTALL_FOLDER}/bin/elasticsearch" --version)"
}

function main()
{
    APP_FOLDER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${APP_FOLDER_PATH}/../../../libraries/util.bash"
    source "${APP_FOLDER_PATH}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING ELASTIC SEARCH'

    checkRequirePort '9200' '9300'

    installDependencies
    install
    installCleanUp
}

main "${@}"