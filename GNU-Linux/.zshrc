# Only sourced for interactive shell, last
export NCURSES_NO_UTF8_ACS=1

# Check for and load terminal-specific keybindings
[ -f ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ] && source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#History-Control
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-history
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-history

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_UNICODE=true

# default plugins - is overruled by .zshenv
[ -z "$plugins" ] && plugins=(git)
# Disable some plugins while running in Emacs
if [[ -n "$INSIDE_EMACS" ]]; then
    plugins=(git)
    ZSH_THEME="simple"
else
    ZSH_THEME="compact-grey"
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

## global aliases
# case insensitive matches, recursive, show filename
alias -g GW="grep -iHR"
# case insensitive matches, recursive, filename only
alias -g GF="grep -ilR"
# redirect / pipe output"
alias -g N=">/dev/null"
alias -g L="|less"
alias -g M="|more"

show_colors() {
    for i in {0..255} ; do
        let j=255-$i
        printf "\x1b[38;5;${i}m ${i} \x1b[0m"
        printf "\x1b[48;5;${i}m\x1b[38;5;${j}m ${i} \x1b[0m"
    done
    printf "\n"
}

urlencode() {
    setopt localoptions extendedglob
    input=( ${(s::)1} )
    print ${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-])/%${(l:2::0:)$(([##16]#match))}}
}

# Using the AUTOCD option, you can simply type the name of a directory,
# and it will become the current directory.
setopt AUTOCD

## History
# + HIST_VERIFY :: don't execute history command immediately
setopt HIST_VERIFY
# + HIST_IGNORE_SPACE :: don't add command to history if it starts with space
setopt HIST_IGNORE_SPACE
# + HIST_IGNORE_ALL_DUPS :: ignore duplicate entries when showing results
setopt HIST_IGNORE_ALL_DUPS
# + HIST_FIND_NO_DUPS :: ignore duplicates when match has been found
setopt HIST_FIND_NO_DUPS
# + INC_APPEND_HISTORY :: adds entries to history as they are typed (don't wait for exit)
# setopt INC_APPEND_HISTORY
# + SHARE_HISTORY :: share history between different zsh processes
unsetopt SHARE_HISTORY
# Don't error out on zero matches
setopt NULL_GLOB
## Line editor
setopt NO_BEEP

# create hashes for all subdirectories / repositories
for sub in public private projects; do
    if [ -d ${REPOS}/${sub} ]; then
        pushd ${REPOS}/${sub} &>/dev/null
        for repo in echo *(/); do
            hash -d ${repo}=${REPOS}/${sub}/${repo}
        done
        popd &>/dev/null
    fi
done

[ ! -z ${REPOS} ] && [ -d ${REPOS} ] && hash -d repos=${REPOS} || true

# load Bash and zsh compatible aliases
[ -f $HOME/.aliases ] && source $HOME/.aliases

# Start oh-my-zsh
[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# update shortcut
alias update='sudo apt-get update && sudo apt-get -y dist-upgrade'