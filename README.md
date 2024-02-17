# Personal config files

This repository stores my personal config files.

# Installation

1. Install GNU Stow
2. Clone this repository to your home directory (for example `~/.stow-config`)
3. Run `stow .` inside the repository root

# Adding new files

1. Create an empty file
2. Run `stow . --adopt`

# Brewfile

Brew files contains all programs installed by homebrew.

```bash
# Run to install all programs
brew bundle

# Run to update brewfile
brew bundle --force dump
```
