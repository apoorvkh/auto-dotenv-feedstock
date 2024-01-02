#!/usr/bin/env zsh

# Reset env variables to pre-activation values
for key in ${(@k)dotenv_stack}; do
    export $key=$dotenv_stack[$key]
done

unset dotenv_stack
