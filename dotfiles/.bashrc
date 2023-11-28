#!/bin/bash
# shellcheck disable=SC1090,SC1091
# Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
# Environment: exported variables {{{

# Run 'dircolors --print-database' for more info about this.
export LS_COLORS='di=1;34:fi=0:ln=1;36:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;92:*.rpm=90'

# Use true color by default
export COLORTERM=truecolor

# React
export REACT_EDITOR='less'

# Colored GCC warnings and errors
GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01"
GCC_COLORS="$GCC_COLORS;32:locus=01:quote=01"
export GCC_COLORS

# Configure less (de-initialization clears the screen)
# Gives nicely-colored man pages
LESS="--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS"
LESS="$LESS --HILITE-UNREAD --tabs=4 --quit-if-one-screen"
export LESS
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export PAGER=less

# Configure Man Pager
export MANWIDTH=79
export MANPAGER=less

# Git
export GIT_PAGER=less

# Set default text editor to nano (recommendation: change to code, vim, or nvim)
export EDITOR=nano

# Environment variable controlling difference between HI-DPI / Non HI_DPI
# Turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.bash_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

# Python virtualenv (disable the prompt so I can configure it myself below)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Default browser for some programs (eg, urlview)
export BROWSER='/usr/bin/firefox'

# Enable editor to scale with monitor's DPI
export WINIT_HIDPI_FACTOR=1.0

# Bat
export BAT_PAGER=''

# }}}
# Environment: path appends + misc env setup {{{

# Takes 1 argument and adds it to the beginning of the PATH
function path_ladd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

# Takes 1 argument and adds it to the end of the PATH
function path_radd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

path_ladd "$HOME/bin"
path_ladd "$HOME/.bin"
path_ladd "$HOME/.local/bin"

export PATH

# }}}
# Script Sourcing {{{

function include() {
  [[ -f "$1" ]] && source "$1"
}

include "$HOME/.config/sensitive/secrets.sh"
include "$HOME/.asdf/asdf.sh"

# }}}
# PS1 Bash Prompt {{{

PS1_COLOR_BRIGHT_BLUE="\033[38;5;115m"
PS1_COLOR_RED="\033[0;31m"
PS1_COLOR_YELLOW="\033[0;33m"
PS1_COLOR_GREEN="\033[0;32m"
PS1_COLOR_ORANGE="\033[38;5;202m"
PS1_COLOR_SILVER="\033[38;5;248m"
PS1_COLOR_RESET="\033[0m"
PS1_BOLD="$(tput bold)"

function ps1_git_color() {
  local git_status
  local branch
  local git_commit
  git_status="$(git status 2> /dev/null)"
  branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  git_commit="$(git --no-pager diff --stat "origin/${branch}" 2>/dev/null)"
  if [[ $git_status == "" ]]; then
    echo -e "$PS1_COLOR_SILVER"
  elif [[ $git_status =~ "not staged for commit" ]]; then
    echo -e "$PS1_COLOR_RED"
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e "$PS1_COLOR_YELLOW"
  elif [[ $git_status =~ "nothing to commit" ]] && \
      [[ -z $git_commit ]]; then
    echo -e "$PS1_COLOR_GREEN"
  else
    echo -e "$PS1_COLOR_ORANGE"
  fi
}

function ps1_git_branch() {
  local git_status
  local on_branch
  local on_commit
  git_status="$(git status 2> /dev/null)"
  on_branch="On branch ([^${IFS}]*)"
  on_commit="HEAD detached at ([^${IFS}]*)"
  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo " $branch"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo " $commit"
  else
    echo ""
  fi
}

function ps1_python_virtualenv() {
  if [[ -z $VIRTUAL_ENV ]]; then
    echo ""
  else
    echo "($(basename "$VIRTUAL_ENV"))"
  fi
}

PS1_DIR="\[$PS1_BOLD\]\[$PS1_COLOR_BRIGHT_BLUE\]\w"
PS1_GIT="\[\$(ps1_git_color)\]\[$PS1_BOLD\]\$(ps1_git_branch)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
PS1_VIRTUAL_ENV="\[$PS1_BOLD\]\$(ps1_python_virtualenv)\[$PS1_BOLD\]\[$PS1_COLOR_RESET\]"
PS1_END="\[$PS1_BOLD\]\[$PS1_COLOR_GREEN\]$ \[$PS1_COLOR_RESET\]"
PS1="${PS1_DIR} ${PS1_GIT} ${PS1_VIRTUAL_ENV}\

${PS1_END}"

# }}}
# Aliases {{{

# Easier directory navigation for going up a directory tree
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias ......='cd ../../../../../..'
alias .......='cd ../../../../../../..'
alias ........='cd ../../../../../../../..'
alias .........='cd ../../../../../../../../..'
alias ..........='cd ../../../../../../../../../..'

# ls et al, with color support and handy aliases
alias ls='ls --color=auto'
alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy/paste helpers: perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'

# }}}
# Functions {{{

function push() { # current branch from origin to current branch
  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$current_branch"
}

function pull() { # current branch from origin to current branch
  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$current_branch"
}

function nth_row () {
        local filename=$(basename -- "$1")
        local extension="${filename##*.}"
        local local_filename="fiq.${filename}"
        aws s3 cp $1 $local_filename
        local proceed=true
        local comp_type=$(file $local_filename)
        if [[ "$comp_type" == *"bzip2"* ]]
        then
                bzip2 -d $local_filename
                local local_filename=${local_filename%.*}
        elif [[ "$comp_type" == *"gzip"* ]]
        then
                gunzip $local_filename
                local local_filename=${local_filename%.*}
        else
                if [[ $extension != "csv" && $extension != "tsv" && $extension != "json" ]]
                then
                        tput setaf 1
                        echo -e "Attention: this file is of $extension extension!"
                        echo -e "Can't deal with '$comp_type' this type of file yet!"
                        proceed=false
                fi
        fi
        if [[ $proceed = "true" ]]
        then
                local txt_type=$(file $local_filename)
                local total_lines=$(wc -l < $local_filename)
                if (( $2 > $total_lines ))
                then
                        tput setaf 1
                        echo -e "The line you want to see exceed total lines $total_lines"
                        proceed=false
                else
                        echo "========== See data below =========="
                        if [[ "$txt_type" == *"JSON"* ]]
                        then
                                sed "${2}q;d" $local_filename | jq
                        else
                                sed "${2}q;d" $local_filename
                        fi
                fi
        fi
        if [ -f $local_filename ]
        then
                rm $local_filename
        fi
        if [[ $proceed = "false" ]]
        then
                false
        fi
}

# }}}
# Runtime: executed commands for interactive shell {{{

# turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
stty -ixon

# Assigns permissions so that only I have read/write access for files, and
# read/write/search for directories I own. All others have read access only
# to my files, and read/search access to my directories.
umask 022

# }}}
eval "$(/bin/brew shellenv)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
