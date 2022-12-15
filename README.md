# MacOS settings
```bash
# do not open previous previewed files (e.g. PDFs) when opening a new one
defaults write com.apple.Preview ApplePersistenceIgnoreState YES

# show Library folder
chflags nohidden ~/Library

# show hidden files
defaults write com.apple.finder AppleShowAllFiles YES

# show path bar
defaults write com.apple.finder ShowPathbar -bool true

# show status bar
defaults write com.apple.finder ShowStatusBar -bool true

killall Finder;
```

## Homebrew

### Install
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Update
```bash
brew update
```

## Install MacOS-applications
```bash
brew tap homebrew/cask-fonts
brew install --cask \
  keeper-password-manager \
  firefox \
  brave-browser \
  iterm2 \
  font-hack-nerd-font \
  visual-studio-code \
  sublime-text \
  docker \
  jiggler \
  docker
```

## Install terminal-applications
```bash
brew install \
  wget \
  git \
  starship \
  nvm
 ```

## Oh My Zsh

### Install
```bash
cd;sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### Update
```bash
omz update
```

### Reload
```bash
source ~/.zshrc
```

### Set theme
```bash
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```
