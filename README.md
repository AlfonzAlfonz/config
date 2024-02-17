# Environment setup repository

This repository stores all config files required for setting up environment
which is replicable on any MacOS system.

# Installation

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/AlfonzAlfonz/config/main/install.sh)"
```

# Adding an pre-existing config file

1. Create an empty file
2. Run `stow . --adopt`

# Brewfile

Brew files contains all programs installed by homebrew.

```bash
# Run to install all programs
brew bundle

# Run to update Brewfile
brew bundle --force dump
```
