# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="vi"
export VISUAL="vi"

# iCloud Directory
export DOCS="/Users/henryunite/Library/Mobile Documents/com~apple~CloudDocs"

# Credentials Fetcher
alias username='
  export PASS_BACK_PATH=$(pwd) && \
  cd $DOCS/passwords && \
  echo $(cat $(fzf) | grep "Username:" | cut -d ":" -f2) | pbcopy && \
  cd $PASS_BACK_PATH && unset PASS_BACK_PATH'

alias password='
  export PASS_BACK_PATH=$(pwd) && \
  cd $DOCS/passwords && \
  echo $(cat $(fzf) | grep "Password:" | cut -d ":" -f2) | pbcopy && \
  cd $PASS_BACK_PATH && unset PASS_BACK_PATH'

## Copy Directory
alias c='echo $(pwd) | pbcopy'

## Fuzzy Finder
alias f='echo $(fzf) | pbcopy'

## Code Formatter
alias p='npx prettier --write --single-quote $(fzf)'

## What the Commit
alias wtf='git commit -m "$(curl http://whatthecommit.com/index.txt)"'

## Cheat
function cheat(){ curl https://cheat.sh/"$@"; }

## Generate Markdown
function generate-md() { pandoc -s $@ -o "/tmp/$@.html"; open "/tmp/$@.html"; }

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export DYLD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$DYLD_LIBRARY_PATH
