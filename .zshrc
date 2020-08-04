# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/henryunite/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/henryunite/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/henryunite/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/henryunite/google-cloud-sdk/completion.zsh.inc'; fi

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

alias f='vi $(fzf)'
