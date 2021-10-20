export WDSM_NPM_TOKEN="unknown"

# PATH
PATH="${PATH}:/usr/local/sbin"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# make path available
export PATH

# Make vim the default editor
export EDITOR='vim'

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

# Flush dns
function flushdns() {
    sudo dscacheutil -flushcache;
    sudo killall -HUP mDNSResponder;
    echo "DNS cache flushed"
}
export PATH=$PATH:/Users/ybaron/bin
