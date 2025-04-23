export WDSM_NPM_TOKEN="unknown"

# MY FOLDERS
export WORK="$HOME/Work"
export PROJECTS="$HOME/Private/github.com/npx"
export DOTFILES="$PROJECTS/.dotfiles"
export SLIDES="${HOME}/Work/Materials/slides"

# SECRETS
if [ -f "$HOME/.secrets" ]; then
  source "$HOME/.secrets"
fi

export HTTP_PROXY=http://192.168.64.2:3128

alias ww="cd $WORK"
alias pp="cd $PROJECTS"
alias df="cd $DOTFILES"

bindkey -s ^f "tmux-sessionizer\n"

# PATH
PATH="${PATH}:/usr/local/sbin"

# dotnet tools
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
PATH="${PATH}:$HOME/.dotnet/tools"

# personal executables
PATH="${PATH}:$HOME/.bin"

# ruby
PATH="/opt/homebrew/opt/ruby/bin:${PATH}"

# directory switching
function d() {
  local dir=$(dirs -v | fzf --prompt="Select dir> " | awk '{print $2}')
  [ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

# alacritty
function fs() {
  alacritty msg config --window-id -1 font.size="${1:-18}"
}

# nvm
export NVM_DIR="$HOME/.nvm"
lazynvm() {
  unset -f nvm node npm npx nvim
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
  if [ -f "package.json" ]; then
    lazynvm
  fi
  command nvim $@
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
function git-status() {
  watch -ct -n1 git -c color.status=always --no-optional-locks status
}

# Chrome
function chrome_work() {
  yabai -m space --focus company
  # open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Work
  open -na 'Google Chrome'
}

function chrome_dev() {
  yabai -m space --focus build
  open -na 'Google Chrome'
}

function chrome_private() {
  yabai -m space --focus private
  open -na 'Google Chrome'
  # open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Private
}

# export path
export PATH=$PATH:/Users/ybaron/bin

# setup rust env
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# setup fuck
[ -x "$(command -v thefuck)" ] && eval $(thefuck --alias)

# parrot
alias party="ssh ssh.caarlos0.dev -p 2225"

# big files
alias ducks='du -cks -- * | sort -rn | head'

# marp
alias slides="marp -p -s --allow-local-files ${SLIDES}"
