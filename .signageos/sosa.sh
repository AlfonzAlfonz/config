#!/bin/zsh

sosa() {
    local RESTORE='\033[0m'
    local RED='\033[00;31m'
    local GREEN='\033[00;32m'
    local DOMAIN='signageos'
    local DOMAIN_OWNER=524256255273
    local REGISTRY_NAME='private'
    local SOSA_TOKENV=~/.scfg/.signageos/tokenv
    local SOSA_TOKENV_DIR=$(dirname $SOSA_TOKENV)

    if ! [[ $(find $SOSA_TOKENV_DIR -print) ]]; then
      echo "missing sos folder $SOSA_TOKENV_DIR"
    fi

    local env_setup=""

    if [ -f "$SOSA_TOKENV" ]; then
      ((tokenv_age_s = $(date +%s) - $(date -r $SOSA_TOKENV +%s)))

      if (( tokenv_age_s < 18000 )); then # 18000s is 5 hours
        source $SOSA_TOKENV
        env_setup=1
      else
        rm $SOSA_TOKENV
      fi
    fi

    if [ -z "$env_setup" ]; then

      export NPM_REGISTRY_URL=$(aws codeartifact get-repository-endpoint --domain ${DOMAIN} --domain-owner ${DOMAIN_OWNER} --repository ${REGISTRY_NAME} --format npm --query repositoryEndpoint --output text --region eu-central-1)
      export NPM_REGISTRY_HOST=$(echo $NPM_REGISTRY_URL | sed -n "s/^https:\\/\\/\\(.*\\)\\/$/\\1/p")
      export NPM_AUTH_TOKEN=$(aws codeartifact get-authorization-token --domain ${DOMAIN} --domain-owner ${DOMAIN_OWNER} --query authorizationToken --output text --region eu-central-1)

      if [[ -z "${NPM_REGISTRY_URL}" || -z "${NPM_REGISTRY_HOST}" || -z "${NPM_AUTH_TOKEN}" ]]; then
        echo -e "${RED}Failed to get NPM_credencials!${RESTORE}"
        echo NPM_REGISTRY_URL="${NPM_REGISTRY_URL}"
        echo NPM_REGISTRY_HOST="${NPM_REGISTRY_HOST}"
        echo NPM_AUTH_TOKEN="${NPM_AUTH_TOKEN}"
        return 1
      fi

      echo -e "${GREEN}Successfully set connection to ${NPM_REGISTRY_URL}.${RESTORE}"

      echo "#!/bin/zsh" > $SOSA_TOKENV
      echo "export NPM_REGISTRY_URL=${NPM_REGISTRY_URL}" >> $SOSA_TOKENV
      echo "export NPM_REGISTRY_HOST=${NPM_REGISTRY_HOST}" >> $SOSA_TOKENV
      echo "export NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}" >> $SOSA_TOKENV
    fi

    if [ "$1" = "-p" ]; then
      echo "export NPM_REGISTRY_URL=${NPM_REGISTRY_URL}"
      echo "export NPM_REGISTRY_HOST=${NPM_REGISTRY_HOST}"
      echo "export NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}"
    fi

    if [ "$1" = "-i" ]; then
      fnm use
      npm i
    fi

    return 0
}

if [ -n "$ZSH_VERSION" ]; then

  autoload -U add-zsh-hook
  _sosa_autoload_hook () {
    if [[ $PWD/ = /Users/denishomolik/projects/s/* ]]; then
      if [ -z "$NPMNPM_AUTH_TOKEN" ]; then
        sosa
      fi
    fi
  }

  add-zsh-hook chpwd _sosa_autoload_hook \
      && _sosa_autoload_hook

  rehash

elif [ -n "$BASH_VERSION" ]; then
  # bash is not supported rn:(
else
  # not supported as well:/
fi
