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

## NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
