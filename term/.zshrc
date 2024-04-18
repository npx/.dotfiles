autoload -U compinit; compinit
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

setopt autocd autopushd pushdignoredups

bindkey -v

# setup fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.bash_profile
