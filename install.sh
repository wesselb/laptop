#!/usr/bin/env bash

set -e

. utils.sh

echo "Is SIP turned off? (Boot into recovery mode (cmd-R) and run \"csrutil disable\".)"
wait_confirmation

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
brew install --cask \
    1password \
    alfred \
    appcleaner \
    bettertouchtool \
    betterzip \
    contexts \
    daisydisk \
    dash \
    db-browser-for-sqlite \
    docker \
    dropbox \
    firefox \
    flux \
    gcc \
    gfxcardstatus \
    handbrake \
    icons8 \
    istat-menus \
    iterm2 \
    launchcontrol \
    little-snitch \
    mactex \
    microsoft-office \
    microsoft-teams \
    miniconda \
    moom \
    nordvpn \
    pycharm-ce \
    qlcolorcode \
    qlmarkdown \
    qlstephen \
    sequel-pro \
    signal \
    skim \
    slack \
    sublime-text \
    telegram \
    the-unarchiver \
    totalspaces \
    transmission \
    usb-overdrive \
    vlc \
    whatsapp \
    xquartz \
    zoom

echo "Installing brew packages..."
brew install \
    ag \
    bazel \
    bower \
    cmake \
    coreutils \
    djview4 \
    duti \
    fzf \
    gawk \
    gnu-typist \
    htop \
    imagemagick \
    lame \
    macvim \
    pandoc \
    python \
    ranger \
    rbenv \
    ruby \
    sox \
    tmux \
    trash \
    vim \
    watch \
    wget

echo "Allowing apps to open from anywhere..."
sudo spctl --master-disable

echo "Please log into Dropbox and let it sync."
wait_confirmation

echo "Syncing iTunes..."
ln -sf ~/Dropbox/Private/Media/iTunes ~/Music/

# Install Package Control for Sublime Text.
if ! file_exists "$HOME/Library/Application Support/Sublime Text 3/Installed Packages/Package Control.sublime-package"; then
    echo "Installing Package Control for Sublime Text..."
    wget \
        "https://packagecontrol.io/Package%20Control.sublime-package" \
        -P "$HOME/Library/Application Support/Sublime Text 3/Installed Packages"
fi

# Setup vim.
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
open -a "1Password 7"
wait_confirmation
echo "...copy SSH keys from 1Password to ~/.ssh..."
open ~/.ssh
wait_confirmation
echo "...configure Alfred..."
open -a "Alfred 4"
wait_confirmation
echo "...configure Moom..."
open -a "Moom"
wait_confirmation
echo "...configure Contexts..."
open -a "Contexts"
wait_confirmation
echo "...configure BTT..."
open -a "BetterTouchTool"
wait_confirmation
echo "...configure DaisyDisk..."
open -a "DaisyDisk"
wait_confirmation
echo "...configure Dash..."
open -a "Dash"
wait_confirmation
echo "...configure iStatMenus..."
open -a "iStat Menus"
wait_confirmation
echo "...configure Slack..."
open -a "Slack"
wait_confirmation
echo "...configure gfxCardStatus..."
open -a "gfxCardStatus"
wait_confirmation
echo "...configure WhatsApp..."
open -a "WhatsApp"
wait_confirmation
echo "...configure Telegram..."
open -a "Telegram"
wait_confirmation
echo "...configure Signal..."
open -a "Signal"
wait_confirmation
echo "...and configure Sublime Text..."
open -a "Sublime Text"
wait_confirmation
echo "...and configure Little Snitch."
open -a "Little Snitch"
wait_confirmation

echo "Configuring defaults apps for extensions..."
./extensions.sh

echo "Configuring login iterms..."
items=$(osascript -e 'tell application "System Events" to get the name of every login item')
# Delete applications from login items.
for app in Dash
do
    if [[ $items != *"$app"* ]]; then
        osascript -e "tell application \"System Events\" to delete login item \"${app}\""
    fi
done
# Add applications to login items.
for app in iTerm Contexts Moom TotalSpaces2
do
    if [[ $items != *"$app"* ]]; then
        osascript -e "tell application \"System Events\" to make login item at end with properties {name: \"${app}\", path: \"/Applications/${app}.app\", hidden: false}"
    fi
done

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

echo "Please configure the following:"
echo "  - uncheck \"Accessibility/Display/Shake mouse pointer to locate\","
echo "  - slide   \"Battery/Battery/Turn display off after\" to the right,"
echo "  - uncheck \"Battery/Battery/Slightly dim display while on battery power\","
echo "  - slide   \"Battery/Power Adapter/Turn display off after\" to the right,"
echo "  - uncheck \"Battery/Show battery status in menu bar\","
echo "  - check   \"Bluetooth/Show Bluetooth in menu bar\","
echo "  - uncheck \"Date & Time/Clock/Show date and time in menu bar\","
echo "  - uncheck \"Displays/Automatically adjust brightness\","
echo "  - set     \"Desktop & Screen Saver/Screen Saver/Start after\" to \"Never\","
echo "  - uncheck \"Users & Groups/Guest User/Allow guests to log into the computer\","
echo "  - uncheck \"Users & Groups/Guest User/Allow guest users to connect to shared folders\","
echo "  - set     \"Security & Privacy/General/Require password <option> after sleep or a screen saver begins\" to \"immediately\","
echo "  - check   \"Time Machine/Show Time Machine n menu bar\"."
echo "  - set     \"Trackpad/Point & Click/Look up & data detectors\" to \"Tap with three fingers\","
echo "  - change the user picture,"
echo "  - change the name of the computer in \"Sharing\","
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

echo "Please set your preferred desktop background."
wait_confirm

echo "Please configure iCould and internet accounts."
wait_confirmation

killall cfprefsd  # Reload plist files.
killall Dock  # Restart Dock.

echo "The installation is complete."
