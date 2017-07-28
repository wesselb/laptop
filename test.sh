#!/usr/bin/env bash

. utils.sh

if ! command_exists brew; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! file_exists ~/.oh-my-zsh; then
    echo "Installing Oh My Zsh..."
    brew install zsh
    echo "Press <C-d> after the installed has finished to continue."
    wait_confirmation
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

echo "Installing brew casks..."
brew cask install \
    1password \
    alfred \
    appcleaner \
    atom \
    bettertouchtool \
    betterzipql \
    daisydisk \
    dash \
    dropbox \
    filezilla \
    flux \
    gfxcardstatus \
    google-chrome \
    haskell-platform \
    istat-menus \
    iterm2 \
    launchcontrol \
    little-snitch \
    mactex \
    microsoft-office \
    moom \
    pycharm-ce \
    qlcolorcode \
    qlmarkdown \
    qlstephen \
    karabiner-elements \
    sequel-pro \
    skim \
    slack \
    sqlitebrowser \
    sublime-text \
    telegram \
    the-unarchiver \
    totalspaces \
    transmission \
    usb-overdrive \
    vlc \
    witch \
    xquartz

echo "Installing brew packages..."
brew install \
    bazel \
    djview4 \
    fzf \
    gnu-typist \
    macvim \
    pandoc \
    python \
    tmux \
    watch \
    wget \
    lame \
    htop

echo "Installing python packages..."

# Configure dock.
sed "s@{{HOME_PATH}}@${HOME}@" resources/com.apple.dock.plist \
    | plutil \
        -convert binary1 \
        -o ~/Library/Preferences/com.apple.dock.plist \
        -
killall cfprefsd  # Reload plist files.
killall -HUP Dock  # Restart Dock.

echo "Installation finished."

