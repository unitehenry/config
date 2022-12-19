# EDITOR
export EDITOR="vi";
export VISUAL="vi";

# iCloud Directory
export DOCS="/Users/$(whoami)/Library/Mobile Documents/com~apple~CloudDocs";

# Work Directory
export WORK="/Users/$(whoami)/Projects/lula";

# Vault Lula
export VAULT_ADDR=https://vault.stallions.dev/

# Credentials Management
function op-create() {
  op item template get Login > /tmp/login.json;
  if [ -n "$3" ]
  then
    echo $(cat /tmp/login.json | jq -r -c "(.fields[] | select(.id | contains(\"username\"))) .value = \"$2\"") > /tmp/login.json;
    echo $(cat /tmp/login.json | jq -r -c "(.fields[] | select(.id | contains(\"password\"))) .value = \"$3\"") > /tmp/login.json;
    op item create --template /tmp/login.json --title $1;
  else
    echo $(cat /tmp/login.json | jq -r -c "(.fields[] | select(.id | contains(\"username\"))) .value = \"$2\"") > /tmp/login.json;
    op item create --template /tmp/login.json --title $1 --generate-password;
  fi
  rm /tmp/login.json;
}

function op-list() {
  op item list --format=json | jq -c -r '.[].title';
}

function op-username() {
 op item get $@ --format=json | jq -c -r '.fields[] | select(.id | contains("username")) | .value';
}

function op-password() {
  op item get $@ --format=json | jq -c -r '.fields[] | select(.id | contains("password")) | .value';
}

function op-delete() {
  op item delete $@;
}

## Code Formatter
function format-file() {
  export FILENAME="$(basename $@)";
  export EXTENSION="${FILENAME##*.}";

  if [ $EXTENSION = 'py' ]
  then
    yapf --in-place $@;
    return 0;
  fi

  if [ $EXTENSION = 'php' ]
  then
    php-cs-fixer fix $@;
    rm .php_cs.cache;
    return 0;
  fi

  if [ $EXTENSION = 'sql' ]
  then
    npx sql-formatter-cli --file $@ --out $@;
    return 0;
  fi

  npx prettier --write --single-quote $@;

  unset FILENAME; unset EXTENSION;
}

## Spellcheck
function spellcheck-file() {
  npx spellchecker-cli --files $@;
}

## Git
function wtf() { git commit -am "$(curl http://whatthecommit.com/index.txt)"; }

function commit-count() {
  if [ -n "$1" ]
  then
    git rev-list --count $1;
  else
    echo "commit-count <branch-name>";
  fi
}

function clear-branches() {
  git branch --merged | grep -v \* | xargs git branch -D 
}

## Cheat
function cheat(){ curl https://cheat.sh/"$@"; }

## Generate Markdown
function generate-doc() { 
  cp -rf . /tmp;
  if [ -n "$2" ]
  then
    pandoc -s $1 -c $2 -o "/tmp/$1.html";
  else
    pandoc -s $1 -o "/tmp/$1.html"; 
  fi
  open "/tmp/$1.html";
}

## Generate Slide
function generate-slide() {
  # https://revealjs.com/config/
  pandoc -t revealjs \
    -V controls="false" \
    -V progress="false" \
    -V navigationMode="linear" \
    -V transition="none" \
    -s $1 -o "/tmp/$1.html";
  cp -rf . /tmp;
  open "/tmp/$1.html";
}

## Generate Mermaid Docs
function mmdc() {
  npx @mermaid-js/mermaid-cli $@;
}

## Encrypt : aes-256-cbc
function encrypt-file() {
  if [ -z $@ ]
  then
    echo -n "Enter Encrypt Phrase: "; read -s ENCRYPTINPUT; echo "\n";
    echo $ENCRYPTINPUT | openssl enc -aes-256-cbc;
    unset ENCRYPTINPUT;
  else
    openssl enc -aes-256-cbc -in $@;
  fi
}

## Decrypt : aes-256-cbc
function decrypt-file() {
  if [ -z $@ ]
  then
    openssl enc -d -aes-256-cbc;
  else
    openssl enc -aes-256-cbc -d -in $@;
  fi
}

## Homebrew Install Script
function install-homebrew() { /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; }

## Vundle Install Script
function install-vundle() {
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
  sudo gem install vundle-cli;
  if ! grep -Fxq 'set rtp+=~/.vim/bundle/Vundle.vim' ~/.vimrc
  then
    echo "\nset nocompatible\nfiletype off\nset rtp+=~/.vim/bundle/Vundle.vim\ncall vundle#begin()\n\nPlugin 'VundleVim/Vundle.vim'\n\ncall vundle#end()\nfiletype plugin indent on" >> ~/.vimrc;
  fi
}

## Networking
function list-ports() {
  sudo lsof -i -P | grep LISTEN | grep :$PORT;
}

## Google Cloud Platform
function gcloud-adc() {
  gcloud auth login --update-adc
}

function vs() {
    # Verify inputs
    environment="$1"
    if [ "$environment" != "common" ] && [ "$environment" != "staging" ] && [ "$environment" != "production" ]; then
        echo "\"$environment\" is not a valid environment."
        return 1
    fi

    # Setup
    [ ! -d ~/.vault-tokens ] && mkdir ~/.vault-tokens

    # Move the current environment's token to the correct location
    if [ -f ~/.vault-tokens/current-environment ] && [ -f ~/.vault-token ]; then
        current="$(cat ~/.vault-tokens/current-environment)"
        cp ~/.vault-token ~/.vault-tokens/${current}
    fi

    # Set the new current environment
    echo "${environment}" > ~/.vault-tokens/current-environment

    # Set the correct vault address
    if [ "$environment" = "common" ]; then
        export VAULT_ADDR="https://vault.stallions.dev"
    else
        export VAULT_ADDR="https://vault.${environment}.stallions.dev"
    fi

    # Get the token from the current environment if it exist
    if [ -f ~/.vault-tokens/${environment} ] ; then
        cp ~/.vault-tokens/${environment} ~/.vault-token
    fi

    # Prompt login if the token is not valid
    if ! vault token lookup > /dev/null; then
        vault login --method oidc
    fi
}

function use-gcloud-project () {
  gcloud config set project "$1";
}

function impersonate() {
    if [ -z "$1" ]; then
        echo "Must provide a service account to impersonate."
        return 1
    fi
    gcloud config set auth/impersonate_service_account "$1"
}

function unimpersonate() {
    gcloud config unset auth/impersonate_service_account
}

function cloudsql() {
    # Set the environment
    ENVIRONMENT="${1}"
    if [ "${ENVIRONMENT:-}" = "" ]; then
        echo "Must pass in the environment to connect to."
        return 1
    fi

    # Get the ID for this environment's storage project
    PROJECT_ID=$(gcloud projects list --filter="NAME : ${ENVIRONMENT}-storage-*" --format="value(PROJECT_ID)")
    echo "Project: ${PROJECT_ID}"

    # Get the name of the Cloud SQL instance in this project
    INSTANCE=$(gcloud sql instances list --project="${PROJECT_ID}" --limit 1 --format "value(NAME)")
    echo "Instance: ${INSTANCE}"

    # Get the connection name from this instance
    CONNECTION_NAME=$(gcloud sql instances describe "${INSTANCE}" --project "${PROJECT_ID}" --format "value(connectionName)")
    echo "Connection Name: ${CONNECTION_NAME}"

    # Connect to this instance using the cloud_sql_proxy
    cloud_sql_proxy -instances="${CONNECTION_NAME}=tcp:54320"
}

function connect() {
    # Set the context
    CONTEXT=${1}

    export PGUSER=$(vault kv get -field=username secrets/${CONTEXT}/postgres-terraform)
    export PGPASSWORD=$(vault kv get -field=password "secrets/${CONTEXT}/postgres-terraform")
    psql -h 127.0.0.1 -p 54320  -d "${CONTEXT}"
}

function kex() {
  NS="$1"
  NAME="$2"
  ENTRYPOINT="${3:-/bin/bash}"
  POD=$(kubectl get pod -n $NS -l "app.kubernetes.io/name=$NAME" -o name | head -n 1)
  kubectl exec -it -n $NS $POD -c identity-service -- "${ENTRYPOINT}"
}

function esproxy() {
  # set kubernetes network in docker
  PORT="${1:-9000}"
  kubectl port-forward -n eventstore service/eventstore-haproxy "${PORT}:80" &
  open "http://127.0.0.1:${PORT}/web/index.html#/"
  fg
}

# ID Generators
function vin() {
  echo "$(curl -sS https://randomvin.com/getvin.php\?type\=fake | tr -d '[:space:]')"
}

function uuid() {
    uuidgen | tr '[:upper:]' '[:lower:]'
}

# Docker
function clear-docker() {
  docker system prune -a -f --volumes
}

function kill-docker() {
  killall Docker && open /Applications/Docker.app;
}

# Imports
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc;
source ~/.nvmrc;
source ~/.rvmrc;
