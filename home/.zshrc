# EDITOR
export EDITOR="vi";
export VISUAL="vi";

# iCloud Directory
export DOCS="/Users/henryunite/Library/Mobile Documents/com~apple~CloudDocs";

# Work Directory
export WORD="/Users/henryunite/bicycletransit";

# Credentials Fetcher
function username() {
  export PASS_BACK_PATH=$(pwd);
  cd $DOCS/passwords;
  echo $(cat $(fzf) | grep "Username:" | cut -d ":" -f2) | pbcopy;
  cd $PASS_BACK_PATH && unset PASS_BACK_PATH;
}

function password() {
  export PASS_BACK_PATH=$(pwd);
  cd $DOCS/passwords;
  echo $(cat $(fzf) | grep "Password:" | cut -d ":" -f2) | pbcopy;
  cd $PASS_BACK_PATH && unset PASS_BACK_PATH;
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

  npx prettier --write --single-quote $@;

  unset FILENAME; unset EXTENSION;
}

## Spellcheck
function spellcheck-file() {
  npx spellchecker-cli --files $@;
}

## What the Commit
function wtf() { git commit -am "$(curl http://whatthecommit.com/index.txt)"; }

## Cheat
function cheat(){ curl https://cheat.sh/"$@"; }

## Generate Markdown
function generate-doc() { 
  if [ -n "$2" ]
  then
    pandoc -s $1 -c $2 -o "/tmp/$1.html";
    cp $2 /tmp;
  else
    pandoc -s $1 -o "/tmp/$1.html"; 
  fi
  open "/tmp/$1.html";
}

## Generate Slide
function generate-slide() {
  # https://revealjs.com/config/
  pandoc -t revealjs \
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

source ~/.nvmrc;
source ~/.rvmrc;
