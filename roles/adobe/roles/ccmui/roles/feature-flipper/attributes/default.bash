#!/bin/bash -e

source "$(dirname "${BASH_SOURCE[0]}")/../../../../../../../cookbooks/node-js/attributes/default.bash"

export CCMUI_FEATURE_FLIPPER_DISK='/dev/sdb'
export CCMUI_FEATURE_FLIPPER_MOUNT_ON='/opt'

export CCMUI_FEATURE_FLIPPER_GIT_USER_NAME='Nam Nguyen'
export CCMUI_FEATURE_FLIPPER_GIT_USER_EMAIL='namnguye@adobe.com'

export CCMUI_FEATURE_FLIPPER_NODE_JS_INSTALL_FOLDER="${NODE_JS_INSTALL_FOLDER}"
export CCMUI_FEATURE_FLIPPER_NODE_JS_VERSION='latest'

export CCMUI_FEATURE_FLIPPER_TORNADO_HTTP_PORT='8080'