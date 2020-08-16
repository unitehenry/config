# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Fuzzy Finder
alias f='vi $(fzf)'

# Code Formatter
alias p='npx prettier --write --single-quote $(fzf)'

# What the Commit
alias wtf='git commit -m "$(curl http://whatthecommit.com/index.txt)"'
