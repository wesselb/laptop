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
    contexts \
    daisydisk \
    dash \
    duet \
    dropbox \
    filezilla \
    flux \
    gfxcardstatus \
    google-chrome \
    handbrake \
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
    xquartz \
    java \
    gimp \
    the-unarchiver

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
    htop \
    bower \
    trash \
    cmake \
    coreutils \
    sox \
    gawk \
    duti \
    ruby \
    ag \
    imagemagick \
    graphviz --with-gts

# Link python.
ln -sf /usr/local/bin/python2 /usr/local/bin/python

echo "Installing python packages..."
/usr/local/bin/pip install \
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
    pylint \
    ipdb

echo "Installing gems..."
sudo /usr/local/bin/gem install \
    jekyll \
    bundler

echo "Allowing apps to open from anywhere..."
sudo spctl --master-disable

echo "Configuring Dock..."
sed "s@{{HOME_PATH}}@${HOME}@" Resources/com.apple.dock.plist \
    | plutil \
        -convert binary1 \
        -o ~/Library/Preferences/com.apple.dock.plist \
        -
killall cfprefsd  # Reload plist files.
killall Dock  # Restart Dock.

# Install Package Control for Sublime Text.
if ! file_exists "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"; then
    echo "Installing Package Control for Sublime Text..."
    wget \
        "https://packagecontrol.io/Package%20Control.sublime-package" \
        -P "$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
fi

echo "Fixing your Mac..."
cd Resources
bash homecall.sh fixmacos
cd ..

echo "Please log into Dropbox and let it sync."
wait_confirmation

echo "Setting desktop picture..."
osascript -e 'tell application "System Events" to set picture of every desktop to ("'$HOME'/Dropbox/Private/Media/Backgrounds/Liquicity Escapism.jpg" as POSIX file as alias)'

echo "Please configure Chrome."
open -a "Google Chrome"
wait_confirmation

echo "Please close Atom after it opens."
open -a "Atom"
wait_confirmation
/usr/local/bin/apm install sync-settings
echo "Please restore settings from backup, and close Atom afterwards."
open -a "Atom"
wait_confirmation

# Save current folder.
here=`pwd`

echo "Syncing configs..."
cd ~/Dropbox/Private/Sync/
./link.sh
cd "$here"

echo "Relinking resources..."
cd ~/Dropbox/Resources/Utils/
./link.sh
cd "$here"

echo "Syncing iTunes..."
ln -sf ~/Dropbox/Private/Media/iTunes ~/Music/

if ! file_exists ~/.vim/bundle/Vundle.vim; then
    echo "Setting up vim..."
    echo "Exit vim after the installation completes."
    wait_confirmation
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim -c "PluginInstall"
    return_path="`pwd`"
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer
    cd "$return_path"
fi

echo "Configuring keyboard..."
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g com.apple.swipescrolldirection -bool FALSE
killall cfprefsd
echo "In \"System Preferences/Keyboard/Shortcuts\", please"
echo "  - uncheck \"Spotlight/Show Spotlight Search\","
echo "  - uncheck \"Mission Control/Move left a space\","
echo "  - uncheck \"Mission Control/Move right a space\", and"
echo "  - change \"Keyboard/Move focus to the next window\" to <alt-\`>."
echo "Furthermore,"
echo "  - uncheck \"Keyboard/Text/Correct spelling automatically\","
echo "  - uncheck \"Keyboard/Text/Capitalize words automatically\","
echo "  - uncheck \"Keyboard/Text/Add period with double-space\","
echo "  - set \"Keyboard/Modifier Keys/Caps Lock\" to \"Escape\", and"
echo "  - set \"Shortcuts/Full Keyboard Access\" to \"All controls\"."
wait_confirmation

echo "Please log into 1Password..."
open -a "1Password 6"
wait_confirmation
echo "...configure Alfred..."
open -a "Alfred 3"
wait_confirmation
echo "...configure Moom..."
open -a Moom
wait_confirmation
echo "...configure Contexts..."
open -a Contexts
wait_confirmation
echo "...configure BTT..."
open -a BetterTouchTool
wait_confirmation
echo "...configure DaisyDisk..."
open -a DaisyDisk
wait_confirmation
echo "...configure Dash..."
open -a Dash
wait_confirmation
echo "...configure iStatMenus..."
open -a "iStat Menus"
wait_confirmation
echo "...configure Slack..."
open -a Slack
wait_confirmation
echo "...configure gfxCardStatus..."
open -a gfxCardStatus
wait_confirmation
echo "...configure Telegram..."
open -a Telegram
wait_confirmation
echo "...and configure Sublime Text."
open -a "Sublime Text"
wait_confirmation

echo "Configuring defaults apps for extensions..."
./extensions.sh

echo "Configuring login iterms..."
items=$(osascript -e 'tell application "System Events" to get the name of every login item')
if [[ $items == *"Dash"* ]]; then
    osascript -e 'tell application "System Events" to delete login item "Dash"'
fi
if [[ $items != *"iTerm"* ]]; then
    osascript -e 'tell application "System Events" to make login item at end with properties {name: "iTerm", path: "/Applications/iTerm.app", hidden: false}'
fi

echo "Please configure the following:"
echo "  - check \"Bluetooth/Show Bluetooth in menu bar\","
echo "  - set \"Trackpad/Point & Click/Look up & data detectors\" to \"Tap with three fingers\","
echo "  - slide \"Energy Saver/Battery/Turn display off after\" to the right,"
echo "  - uncheck \"Energy Saver/Battery/Slightly dim display while on battery power\","
echo "  - slide \"Energy Saver/Power Adapter/Turn display off after\" to the right,"
echo "  - set \"Desktop & Screen Saver/Screen Saver/Start after\" to \"Never\","
echo "  - uncheck \"Energy Saver/Show battery status in menu bar\","
echo "  - uncheck \"Displays/Automatically adjust brightness\","
echo "  - uncheck \"Date & Time/Clock/Show date and time in menu bar\","
echo "  - uncheck \"Accessibility/Display/Shake mouse pointer to locate\","
echo "  - change the user picture,"
echo "  - change the name of the computer in \"Sharing\","
echo "  - uncheck \"Users & Groups/Guest User/Allow guests to log into the computer\","
echo "  - uncheck \"Users & Groups/Guest User/Allow guest users to connect to shared folders\", and"
echo "  - set \"Security & Privacy/General/Require password <option> after sleep or a screen saver begins\" to \"immediately\"."
open "Resources/Account Pictures"
wait_confirmation

echo "Please configure Finder's preferences to"
echo "  - open in the right folder, "
echo "  - show the right items in the side sidebar,"
echo "  - show the right tags,"
echo "  - have the right advanced settings:"
echo "    - check \"Show all filename extensions\", and"
echo "    - check \"Show warning before changing an extension\"; and"
echo "  - set the right default view settings (<cmd-j>)."
wait_confirmation

echo "Please configure iCould, internet accounts, and web.whatsapp.com."
wait_confirmation

if ! file_exists "/Applications/Little Snitch Configuration.app"; then
    echo "Installing Little Snitch; afterwards, the installation is complete; enable FileVault if wanted."
    open "$(brew_latest Caskroom/little-snitch)/Little Snitch Installer.app"
else
    echo "The installation is complete; enable FileVault if wanted."
fi
