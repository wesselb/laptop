#!/usr/bin/env bash

command_exists() {
    if [ -z "$(command -v $1)" ]; then
        return 1
    else
        return 0
    fi
}

file_exists() {
    if [ -e "$1" ]; then
        return 0
    else
        return 1
    fi
}

wait_confirmation() {
    echo "Press <ENTER> to continue."
    read
}
