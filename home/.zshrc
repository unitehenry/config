# EDITOR
export EDITOR="vi";
export VISUAL="vi";

# iCloud Directory
export DOCS="/Users/$(whoami)/Library/Mobile Documents/com~apple~CloudDocs";

# Work Directory
export WORK="/Users/$(whoami)/Projects/lula";

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

## What the Commit
function wtf() { git commit -am "$(curl http://whatthecommit.com/index.txt)"; }

## Commit Count
function commit-count() {
  if [ -n "$1" ]
  then
    git rev-list --count $1;
  else
    echo "commit-count <branch-name>";
  fi
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

function clear-docker() {
  docker system prune -a -f --volumes
}

function gcloud-adc() {
  gcloud auth login --update-adc
}

export VAULT_ADDR=https://vault.stallions.dev/
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc;
source ~/.nvmrc;
source ~/.rvmrc;
