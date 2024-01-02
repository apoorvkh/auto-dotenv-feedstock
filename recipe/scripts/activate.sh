#!/usr/bin/env bash

if [ -n "$ZSH_VERSION" ]; then
    source ${0%.sh}.zsh
    return
fi

if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    source ./.env
    return
fi

if [ ! -e "./.env" ]; then
    return
fi

# Parse .env file
declare -A dotenv_keys
for key in $(
    sed \
    -e 's/^[[:space:]]*//' \
    -e 's/^export[[:space:]]\{1,\}//' \
    -e '/^[^[:space:]#]\{1,\}=/!d' \
    -e 's/=.*//' \
    .env
); do
    dotenv_keys[$key]=""
done

# Preserve environment variables
declare -A dotenv_stack

## preserve every new .env key
for key in ${!dotenv_keys[@]}; do
    if [[ ! ${dotenv_stack[$key]+_} ]]; then
        dotenv_stack[$key]="${!key}"
    fi
done

## reset every preserved key that is not in .env
for key in ${!dotenv_stack[@]}; do
    if [[ ! ${dotenv_keys[$key]+_} ]]; then
        export $key="${dotenv_stack[$key]}"
        unset "dotenv_stack[$key]"
    fi
done

# Load new environment variables
source ./.env

# helper function for deactivation
source /dev/stdin <<EOF
function reset_dotenv_stack() {
    $(declare -p dotenv_stack)
    for key in \${!dotenv_stack[@]}; do
        export \$key="\${dotenv_stack[\$key]}"
    done
};
EOF
export -f reset_dotenv_stack
