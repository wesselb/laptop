#!/usr/bin/env bash

# TODO: The unarchiver
# TODO: Atom settings

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
    duet \
    dropbox \
    filezilla \
    flux \
    gfxcardstatus \
    google-chrome \
    handbreak \
    haskell-platform \
    istat-menus \
    iterm2 \
    julia \
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
sed "s@{{HOME_PATH}}@${HOME}@" Resources/com.apple.dock.plist \
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

echo "Installing Source Code Pro for Powerline..."
cp "resources/Source Code Powerline Regular.otf" /Library/Fonts

echo "Fixing your Mac..."
cd Resources
bash homecall.sh fixmacos
cd ..

echo "Please log into Dropbox."
wait_confirmation

echo "Setting desktop picture..."
sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value = '"$HOME"/Dropbox/Private/Media/Backgrounds/Liquicity Escapism.jpg'" && killall Dock

echo "Syncing configs..."
cd ~/Dropbox/Private/Sync/Configs
./link.sh

echo "Please manually sync the following apps with Dropbox:"
echo "    1Password"
echo "    Alfred"
echo "    Dash"
wait_confirmation

echo "Please configure the energy management saving settings to your liking."
wait_confirmation

echo "Please configure the sharing settings to your liking."
wait_confirmation

echo "Please delete unnecessary preinstalled apps with AppCleaner."
open -a AppCleaner
wait_confirmation

echo "Installation finished."

