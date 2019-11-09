# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# LINKs:
#  - https://gist.github.com/bb010g/379e0788e21fb119b5271fc22a896272
# TODOs:
#  - fasd/zaw for fast navigation between recently visited folders
#  - locate for finding files

# ++++++++++++++++++++++++++++++++++++++
# PLUGINS
# --------------------------------------
ZPLUG_HOME=$HOME/.zplug
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug $ZPLUG_HOME
    source $ZPLUG_HOME/init.zsh && zplug --self-manage update
else
    source $ZPLUG_HOME/init.zsh
fi

# zplug basics:
# - `zplug status` to see if packages are up to date
# - `zplug update` to update packages
# - `zplug list` to see currently managed packages
# - `zplug clean` to clear out now unmanaged packages
# - `zplug 'owner/repo'` to use a plugin from https://github.com/$owner/$repo
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "romkatv/powerlevel10k", as:theme, depth:1 # fancy theme with nice prompt
zplug "jhawthorn/fzy", \
    as:command, \
    rename-to:fzy, \
    hook-build:"make && sudo make install"
zplug "modules/fasd", from:prezto # productifity booster to perofr
zplug "modules/utility", from:prezto # sane defaults (ls aliases and ctrl+arrow cursor movements)
zplug "plugins/git",   from:oh-my-zsh # nice git aliases
zplug "plugins/tmux", from:oh-my-zsh # tmux aliases
zplug "zsh-users/zsh-completions" # more completions
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2 # (like fish)
zplug 'zsh-users/zsh-history-substring-search', defer:3 # loaded after syntax-highlighting

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# ++++++++++++++++++++++++++++++++++++++
# OPTIONS
# --------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=$HOME/.zsh_history
setopt append_history # better concurrent shell history sharing
setopt extended_history # better history
setopt share_history # better concurrent shell history sharing
setopt hist_expire_dups_first # don't fill your history as quickly with junk
setopt hist_ignore_space # ` command` doesn't save to history
setopt hist_reduce_blanks # `a  b` normalizes to `a b` in history
setopt auto_cd # can navigate without cd when using directories
setopt complete_in_word # more intuitive completions
setopt no_beep

# ++++++++++++++++++++++++++++++++++++++
# KEYBINDINGS
# --------------------------------------
# Use the Emacs-like keybindings
bindkey -e
bindkey -M main '^[OA' history-substring-search-up
bindkey -M main '^[OB' history-substring-search-down
bindkey -M main '^[[A' history-substring-search-up
bindkey -M main '^[[B' history-substring-search-up

bindkey '^r' history-incremental-search-backward
bindkey '^R' history-incremental-pattern-search-backward

# ++++++++++++++++++++++++++++++++++++++
# ALIASES
# --------------------------------------
# cd
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
# # basic file operations
alias md='mkdir -p'
alias rd=rmdir
# xclip
alias xc="xclip -selection clipboard"
alias xco="xclip -selection clipboard -o"
alias xcm="xclip"
alias xcmo="xclip -o"
# misc
alias grep='grep --color=auto'
alias em="emacs -nw"
alias rg="ranger"
alias glastb="git for-each-ref --sort=-committerdate --count=10 --format='%(refname:short)' refs/heads/"
alias gs=gss
# fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

function _gotoDir {
    echo "visit recently viewed directory"
    cd $(d -l | fzy)
    zle accept-line
}
zle -N goto _gotoDir
bindkey '^g' goto

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
