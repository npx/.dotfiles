autoload -U compinit; compinit
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%(1j.%F{yellow}⚙%j %f.)$ '

setopt autocd autopushd pushdignoredups

bindkey -v

# fzf shell integration (ctrl-r/ctrl-t); path-independent, works on any machine
command -v fzf >/dev/null && source <(fzf --zsh)

source ~/.bash_profile

command -v direnv >/dev/null && eval "$(direnv hook zsh)"
