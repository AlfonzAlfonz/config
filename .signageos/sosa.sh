sosa() {
    local RESTORE='\033[0m'
    local RED='\033[00;31m'
    local GREEN='\033[00;32m'
    local DOMAIN='signageos'
    local DOMAIN_OWNER=524256255273
    local REGISTRY_NAME='private'

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
    if [ "$1" = "-p" ]; then
        echo -e "export NPM_REGISTRY_URL=${NPM_REGISTRY_URL}"
        echo -e "export NPM_REGISTRY_HOST=${NPM_REGISTRY_HOST}"
        echo -e "export NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}"
    fi

    if [ "$1" = "-i" ]; then
        nvm use
        npm i --ignore-scripts

    fi

    return 0
}
