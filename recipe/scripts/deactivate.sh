#!/usr/bin/env bash

if [ -n "$ZSH_VERSION" ]; then
    source ${0%.sh}.zsh
    return
fi

if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    return
fi

reset_dotenv_stack
unset reset_dotenv_stack
