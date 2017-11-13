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

brew_latest() {
    versions=$(find /usr/local/$1/* -maxdepth 0 | sed "s@/usr/local/$1/@@")
    latest_version=$(echo $versions | sort -r | head -n1)
    echo "/usr/local/$1/$latest_version/"
}

vim() { `brew_latest Cellar/macvim`MacVim.app/Contents/bin/vim $@ }
vimdiff() { `brew_latest Cellar/macvim`MacVim.app/Contents/bin/vimdiff $@ }