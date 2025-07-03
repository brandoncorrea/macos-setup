#!/bin/sh

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
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
mkdir -p ~/.jenv/versions
jenv add "$(/usr/libexec/java_home -v 21)"

# Clojure
brew install clojure/tools/clojure

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
echo "export PATH=\"\$PATH:$(echo ~/fvm/default/bin)\"" >> ~/.zshrc
fvm flutter doctor
