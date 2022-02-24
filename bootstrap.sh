#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Removing existing dotfiles"
rm -rf ~/.aliases ~/.exports ~/.functions ~/.vim ~/.vimrc ~/.zshrc ~/.tmux ~/.tmux.conf ~/.config/nvim 2> /dev/null

echo "Setting zsh as default ..."
chsh -s $(which zsh)

echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

source $HOME/.zshrc

echo "Installing Homebrew ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" -s --batch || {
  echo "Could not install homebrew" >/dev/stderr
  exit 1
}

source $HOME/.zshrc

brew update
brew tap homebrew/cask
brew tap homebrew/cask-fonts

echo "Installing fonts"
brew install --cask font-fira-code-nerd-font \
font-cascadia-mono \
font-iosevka-nerd-font \
font-meslo-lg-nerd-font

echo "Installing GNU utilities .."
# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

echo "Installing apps .."

brew install htop \
vim \
nvim \
git \
tmux \

echo "Installing cask apps .."

brew install --cask firefox \
spotify \
visual-studio-code \
docker \
postman \
microsoft-office

brew cleanup

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

echo "Installing node LTS"
nvm install node lts

echo "Installing Oh-My-Zsh .."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
  echo "Could not install Oh My Zsh" >/dev/stderr
  exit 1
}

echo "installing zsh plugins ..."
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


echo "Symlinking files"
ln -s ~/dotfiles/zshrc ~/.zshrc
ln -s ~/dotfiles/aliases ~/.aliases
ln -s ~/dotfiles/functions ~/.functions
ln -s ~/dotfiles/exports ~/.exports
ln -s ~/dotfiles/gitconfig ~/.gitconfig
ln -s ~/dotfiles/gitignore ~/.gitignore
ln -s ~/dotfiles/p10k.zsh ~/.p10k.zsh


###############################################################################
# Finder                                                                      #
###############################################################################
# Show extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false


###############################################################################
# Dock                                                                      #
###############################################################################
# Set the icon size of Dock items to 48 pixels
defaults write com.apple.dock tilesize -int 48
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.1
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5
# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Others                                                           #
###############################################################################
# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" > /dev/null 2>&1
done