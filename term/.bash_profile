export WDSM_NPM_TOKEN="unknown"
export DOTFILES="$HOME/.dotfiles"

# PATH
PATH="${PATH}:/usr/local/sbin"

# dotnet tools
PATH="${PATH}:$HOME/.dotnet/tools"

# personal executables
PATH="${PATH}:$HOME/.bin"

# nvm
export NVM_DIR="$HOME/.nvm"
lazynvm() {
  unset -f nvm node npm npx nvim
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
  if [ -f "$NVM_DIR/bash_completion" ]; then
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
  fi
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}

nvim() {
  lazynvm
  nvim $@
}

# make path available
export PATH

# Make vim the default editor
export EDITOR='nvim'

# Python UTF-8 stuff
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Rename current tab
function tabname() {
    DISABLE_AUTO_TITLE="true"
    printf "\e]1;$1\a"
}

function it2prof() { 
    echo -e "\033]50;SetProfile=$1\a"
}

# Setup Git demo
function git-demo() {
    PROMPT='%{$FG[255]%}'"$1"'$(git_prompt_info)%{$FG[255]%}$%{$reset_color%} '

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}("
    ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="*"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    tabname $1
    it2prof Presentation
}

# Setup Git demo
function webinar() {
    PROMPT='%{$FG[255]%}'"$1"'$%{$reset_color%} '

    tabname $1
    it2prof Presentation
}

# Updating git log
function git-watch() {
    watch -ct -n1 git --no-pager log --color --all --oneline --decorate --graph
}

# Chrome
function chrome_work () {
  yabai -m space --focus company
  open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Work
}

function chrome_dev () {
  yabai -m space --focus build
  open -na 'Google Chrome'
}

function chrome_private () {
  yabai -m space --focus private
  open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Private
}

# Folders
alias ww="cd ~/Work"
alias pp="cd ~/Private/github.com/npx"
alias df="cd $DOTFILES"

# Fuzzy find projects
bindkey -s ^f "tmux-sessionizer\n"

# export path
export PATH=$PATH:/Users/ybaron/bin

# setup rust env
. "$HOME/.cargo/env"
