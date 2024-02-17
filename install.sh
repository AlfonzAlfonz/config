set -e

title() {
  local RESTORE='\033[0m'
  local BOLD='\033[1m'
  local GREEN='\033[00;32m'

  echo
  echo "\n${GREEN}${BOLD}${1}${RESTORE}"
}

title "Installing your environment"
cd ~

title "Ensuring brew"
if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
   brew update
fi

title "Cloning config repository"
if [ -d ~/.stow-config ]; then
  cd ~/.stow-config
  git pull
else
  git clone https://github.com/AlfonzAlfonz/config.git ~/.stow-config
fi

title "Symlinking dotfiles"

brew install stow

cd ~/.stow-config
mkdir -p ~/Library/Application Support/Code/globalStorage
stow .

title "Installing Brewfile"

cd ~
brew bundle

title "Setting up lastpass"

if ! lpass status &> /dev/null
then
  lpass login alfonz@homolik.cz
fi

echo "Success"

title "Setting up ssh"

if [ -e ~/.ssh/id_ed25519 ]; then
  echo "ssh key already exists"
else

  lpass show "ssh main" --field="Private Key" > ~/.ssh/id_ed25519
  lpass show "ssh main" --field="Public Key" > ~/.ssh/id_ed25519.pub

  chmod 400 ~/.ssh/id_ed25519

  eval "$(ssh-agent -s)"

  ssh-add --apple-use-keychain ~/.ssh/id_ed25519

fi

title "Clean up"

lpass logout -f

cd ~/.stow-config
git remote set-url origin git@github.com:AlfonzAlfonz/config.git

echo
echo "Your environment is now ready"
