# MY FOLDERS
export WORK="$HOME/Work"
export PRIVATE="$HOME/Private"
export PROJECTS="$HOME/Private/github.com/npx"
export DOTFILES="$PROJECTS/.dotfiles"
export SLIDES="${HOME}/Work/Materials/slides"

# SECRETS
if [ -f "$HOME/.secrets" ]; then
  source "$HOME/.secrets"
fi

# export HTTP_PROXY=http://192.168.64.2:3128

alias ww="cd $WORK"
alias pp="cd $PROJECTS"
alias df="cd $DOTFILES"

bindkey -s ^f "tmux-sessionizer\n"

# PATH
PATH="${PATH}:/usr/local/sbin"

# personal executables
PATH="${PATH}:$HOME/.bin"

# user-local installs (claude native installer lives here)
PATH="$HOME/.local/bin:${PATH}"

# directory switching
function d() {
  local dir=$(dirs -v | fzf --prompt="Select dir> " | awk '{print $2}')
  [ -n "$dir" ] && cd "${dir/#\~/$HOME}"
}

# alacritty
function fs() {
  alacritty msg config --window-id -1 font.size="${1:-18}"
}

# node via fnm: default version on PATH in every shell; the hook switches on
# cd, and the startup check below covers panes that BEGIN inside a project
# (tmux-sessionizer), so .nvmrc pins apply without a manual `fnm use`.
if command -v fnm >/dev/null; then
  eval "$(fnm env --use-on-cd)"
  { [ -f .nvmrc ] || [ -f .node-version ]; } && fnm use --silent-if-unchanged
fi

# make path available
export PATH

# Make vim the default editor
export EDITOR='nvim'

# Python UTF-8 stuff
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Updating git log
function git-watch() {
  watch -ct -n1 git --no-pager log --color --all --oneline --decorate --graph
}
function git-watch1() {
  watch -ct -n1 git lgw
}
function git-status() {
  watch -ct -n1 git -c color.status=always --no-optional-locks status -s --show-stash
}

# Chrome
function chrome_work() {
  aerospace workspace 2-company
  # open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Work
  open -na 'Google Chrome'
}

function chrome_dev() {
  aerospace workspace 5-build
  open -na 'Google Chrome'
}

function chrome_private() {
  aerospace workspace 7-private
  open -na 'Google Chrome'
  # open -na 'Google Chrome' --args --user-data-dir=$HOME/Documents/Chrome-Private
}

# parrot
alias party="ssh ssh.caarlos0.dev -p 2225"

# big files
alias ducks='du -cks -- * | sort -rn | head'

# marp
alias slides="marp -p -s --allow-local-files ${SLIDES}"
