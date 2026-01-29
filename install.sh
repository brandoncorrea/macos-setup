#!/bin/sh

# Turn off wallpaper click behavior
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"\n' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Babashka
brew install borkdude/brew/babashka
echo "bb() {\n  rlwrap bb \"\$@\"\n}\n" >> ~/.zprofile

# Java
brew install openjdk@21 jenv
JDK_PREFIX=$(brew --prefix openjdk@21)
sudo ln -sfn "$JDK_PREFIX/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-21.jdk
echo 'export PATH="~/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
mkdir -p ~/.jenv/versions
jenv add "$(/usr/libexec/java_home -v 21)"

# Clojure
brew install clojure/tools/clojure

# .NET
brew install --cask dotnet-sdk
echo "export PATH=\"\$PATH:$HOME/.dotnet/tools\"" >> ~/.zprofile
export PATH="$PATH:$HOME/.dotnet/tools"
echo "export DOTNET_CLI_TELEMETRY_OPTOUT=1" >> ~/.zshrc
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Clojure CLR
dotnet tool install --global Clojure.Main
dotnet tool install --global Clojure.Cljr --version 0.1.0-alpha6

# Docker
brew install --cask docker

# Claude Code
brew install node
npm install -g @anthropic-ai/claude-code

# VSCodium
brew install --cask vscodium

# Slack
brew install --cask slack

# Tuple
brew install --cask tuple

# Firefox
brew install --cask firefox

# NordVPN
brew install --cask nordvpn

# Obsidian
brew install --cask obsidian

# IntelliJ
brew install --cask intellij-idea
echo 'export PATH="/Applications/Intellij IDEA.app/Contents/MacOS:$PATH"' >> ~/.zshrc

# SSH
ssh-keygen -t ed25519 -C $(whoami) -f ~/.ssh/id_ed25519 -N ""

# Datomic
DATOMIC_ROOT=~/Services/datomic
DATOMIC_VERSION=1.0.7387
DATOMIC_NAME=datomic-pro-$DATOMIC_VERSION
DATOMIC_ZIP=$DATOMIC_NAME.zip
DATOMIC_DIR=$DATOMIC_ROOT/$DATOMIC_NAME
mkdir -p $DATOMIC_ROOT
curl https://datomic-pro-downloads.s3.amazonaws.com/$DATOMIC_VERSION/$DATOMIC_ZIP -O
unzip $DATOMIC_ZIP -d $DATOMIC_ROOT
rm $DATOMIC_ZIP

SERVICE_ROOT=~/Library/LaunchAgents
DATOMIC_SERVICE=$SERVICE_ROOT/datomic.plist
mkdir -p $SERVICE_ROOT
cat datomic.plist | sed "s#\$DATOMIC_ROOT#$DATOMIC_DIR#g" > $DATOMIC_SERVICE
cp transactor.properties $DATOMIC_DIR/config

launchctl load $DATOMIC_SERVICE

# Flutter / Dart
brew tap leoafarias/fvm
brew install fvm
fvm install stable
fvm doctor
fvm global stable
echo "export PATH=\"\$PATH:$HOME/fvm/default/bin)\"" >> ~/.zshrc
fvm flutter doctor
