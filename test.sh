#!/usr/bin/env bash

set -e

. utils.sh

if ! command_exists brew; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
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
    totalspaces \
    transmission \
    usb-overdrive \
    vlc \
    witch \
    xquartz \
    java

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
/usr/local/bin/python2 -m pip install \
    numpy \
    scipy \
    sklearn \
    pandas \
    matplotlib \
    ipython \
    virtualenv \
    virtualenvwrapper \
    autopep8 \
    flake8 \
    jupyter \
    pep8 \
    yapf \
    pygments \
    pyflakes \
    pylint

echo "Configuring Dock..."
sed "s@{{HOME_PATH}}@${HOME}@" resources/com.apple.dock.plist \
    | plutil \
        -convert binary1 \
        -o ~/Library/Preferences/com.apple.dock.plist \
        -
killall cfprefsd  # Reload plist files.
killall Dock  # Restart Dock.

if ! file_exists "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"; then
    echo "Installing Package Control for Sublime Text..."
    wget \
        "https://packagecontrol.io/Package%20Control.sublime-package" \
        -P "$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
fi

echo "Please log into Dropbox."
wait_confirmation

echo "Installation finished."

